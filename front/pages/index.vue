<template>
<div>
  <TargetCards :targets="targets" />
  <infinite-loading @infinite="infiniteHandler"></infinite-loading>
    <v-btn fixed fab bottom right color="blue" style="bottom: 50px" @click="openSearchModal">
      <v-icon color="white">mdi-magnify</v-icon>
    </v-btn>
    <modal name="search-modal" height="auto">
      <Search @search-button-click="searchUser" />
    </modal>
</div>
</template>

<script>
import TargetCards from "@/components/pages/TargetCards.vue";
import Search from '@/components/pages/modal/Search.vue'
export default {
  
  components: {
    TargetCards,
    Search,
  },

  data: () => ({
    targets: [],
    page: 1,
    name: '',
    address: '',
  }),

  methods: {
    infiniteHandler($state) {
      this.$axios.get(`/api/${this.$cookies.get('user') === 'user' ? 'host' : 'user'}s`, {
        params: {
          page: this.page,
          name: this.name,
          address: this.address
        },
      })
      .then((response) => {
        setTimeout(() => {
          if (this.page <= response.data.kaminari.pagination.pages) {
            this.page += 1
            this.targets.push(...response.data.users)
            $state.loaded()
          } else {
            $state.complete()
          }
        }, 700)
      }).catch((error) => {
        $state.complete()
        console.log(error)
      })
    },
    openSearchModal() {
      this.$modal.show("search-modal")
    },
    searchUser( name, address) {
      this.name = name
      this.address = address
      this.$axios.get(`/api/${this.$cookies.get('user') === 'user' ? 'host' : 'user'}s`, {
        params: {
          page: 1,
          name: this.name,
          address: this.address
        },
      })
      .then((response) => {
        this.targets = []
        this.targets.push(...response.data.users)       
      })
      .catch((error) => {
        console.log(error)
      })
    },
  },

  computed: {
    mypageURL() {
      return `/${this.$cookies.get('user')}/${this.$store.state.myInfo.myInfo.myid}`
    }
  },
};
</script>
