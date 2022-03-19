<template>
  <v-container>
    <v-row>
      <v-col
        v-for="(target, index) in targets"
        :key="index"
        cols="12"
        sm="6"
        md="6"
        lg="4"
      >
        <TargetCard :target="target" />
      </v-col>

      <v-btn
        fixed
        fab
        bottom
        right
        small
        color="warning"
        style="bottom: 50px"
        @click="openSearchDialog"
      >
        <v-icon color="white">mdi-magnify</v-icon>
      </v-btn>
      <Search ref="search" @search-button-click="searchUser" />
    </v-row>
    <infinite-loading @infinite="infiniteHandler"></infinite-loading>
  </v-container>
</template>

<script>
import { mapGetters } from 'vuex'
import TargetCard from '@/components/organisms/TargetCard.vue'
import Search from '@/components/dialog/Search.vue'
export default {
  components: {
    TargetCard,
    Search,
  },

  data: () => ({
    targets: [],
    page: 1,
    name: '',
    address: '',
    lowerYear: 0,
    wanted: true,
  }),

  computed: {
    ...mapGetters({
      skillsId: 'skills/skillsId',
    }),

    mypageURL() {
      return `/${this.$cookies.get('user')}/${this.$store.state.info.info.myid}`
    },
  },

  methods: {
    infiniteHandler($state) {
      this.$axios
        .get(
          `/api/${this.$cookies.get('user') === 'host' ? 'user' : 'host'}s`,
          {
            params: {
              page: this.page,
              name: this.name,
              address: this.address,
              lowerYear: this.lowerYear,
              wanted: this.wanted === true ? true : '',
              skillsId: this.skillsId,
            },
          }
        )
        .then((response) => {
          setTimeout(() => {
            if (this.page <= response.data.kaminari.pagination.pages) {
              this.page += 1
              this.targets.push(...response.data.users)
              $state.loaded()
            } else {
              $state.complete()
            }
          }, 5)
        })
        .catch(() => {
          $state.complete()
        })
    },

    openSearchDialog() {
      this.$refs.search.name = this.name
      this.$refs.search.address = this.address
      this.$refs.search.lowerYear = this.lowerYear
      this.$refs.search.wanted = this.wanted
      this.$refs.search.isDisplay = true
    },

    searchUser(name, address, lowerYear, wanted) {
      this.name = name
      this.address = address
      this.lowerYear = lowerYear
      this.wanted = wanted
      this.$axios
        .get(
          `/api/${this.$cookies.get('user') === 'user' ? 'host' : 'user'}s`,
          {
            params: {
              page: 1,
              name: this.name,
              address: this.address,
              lowerYear: this.lowerYear,
              wanted: this.wanted === true ? true : '',
              skillsId: this.skillsId,
            },
          }
        )
        .then((response) => {
          this.targets = []
          this.targets.push(...response.data.users)
        })
        .catch((error) => {
          console.log(error)
        })
    },
  },
}
</script>
