<template>
  <v-container>
    <RefineSearch
      :targets="refineSearchTargets"
      :text="text"
      :searchButton="true"
      @refine-button-click="refineSearch"
      @open-search-dialog-click="openSearchDialog"
    />
    <v-row class="pt-5">
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

      <SearchDialog
        ref="search"
        :searchDisplay="searchDisplay"
        @search-button-click="searchUser"
        @close-button-click="closeSearchDialog"
      />
    </v-row>
    <infinite-loading
      :identifier="infiniteId"
      @infinite="infiniteHandler"
    ></infinite-loading>
  </v-container>
</template>

<script>
import { mapGetters } from 'vuex'
import RefineSearch from '@/components/props/RefineSearch.vue'
import TargetCard from '@/components/aggregations/TargetCard.vue'
import SearchDialog from '@/components/dialog/Search.vue'
export default {
  components: {
    RefineSearch,
    TargetCard,
    SearchDialog,
  },

  props: {
    sortBy: {
      type: String,
      default: null,
    },
  },

  data: () => ({
    targets: [],
    nextPage: 1,
    name: '',
    address: '',
    lowerYear: null,
    wanted: true,
    infiniteId: 0,
    searchDisplay: false,
  }),

  computed: {
    ...mapGetters('skills', ['skillsId']),

    mypageURL() {
      return `/${this.$cookies.get('user')}/${this.$store.state.info.info.myid}`
    },

    text() {
      if (this.$route.path === '/search') {
        return 'all'
      } else if (this.$route.path === '/search/distance') {
        return 'distance'
      } else if (this.$route.path === '/search/rate') {
        return 'rate'
      } else {
        return null
      }
    },

    refineSearchTargets() {
      return this.$cookies.get('user') !== 'host'
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
              if ($state !== undefined) $state.loaded()
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

      this.searchDisplay = true
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

    refineSearch(value) {
      switch (value) {
        case 'all':
          this.$router.push('/search')
          break
        case 'distance':
          this.$router.push('/search/distance')
          break
        case 'rate':
          this.$router.push('/search/rate')
          break
      }
    },

    closeSearchDialog() {
      this.searchDisplay = false
    },
  },
}
</script>
