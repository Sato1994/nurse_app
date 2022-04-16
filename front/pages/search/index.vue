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
    <infinite-loading
      :identifier="infiniteId"
      @infinite="infiniteHandler"
    ></infinite-loading>
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
    nextPage: 1,
    name: '',
    address: '',
    lowerYear: 0,
    wanted: true,
    infiniteId: 0,
    sortBy: 'distance',
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
      const config = {
        headers: this.$cookies.get('authInfo'),
        params: {
          page: this.nextPage,
          name: this.name,
          address: this.address,
          lowerYear: this.lowerYear,
          wanted: this.wanted === true ? true : '',
          skillsId: this.skillsId,
          sortBy: this.sortBy,
        },
      }

      this.$axios
        .get(
          `/api/${this.$cookies.get('user') === 'host' ? 'user' : 'host'}s`,
          config
        )
        .then((response) => {
          setTimeout(() => {
            if (this.nextPage <= response.data.kaminari.pagination.pages) {
              this.nextPage += 1
              this.targets.push(...response.data.partners)
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

      this.nextPage = 1
      this.targets = []
      this.infiniteId += 1

      this.infiniteHandler()
    },
  },
}
</script>
