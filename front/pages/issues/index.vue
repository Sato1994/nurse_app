<template>
  <v-container>
    <RefineSearch
      :issues="true"
      text="all"
      @refine-button-click="refineSearch"
    />

    <Times />
    <Offers />
    <Requests />
    <v-img
      class="noContent"
      v-if="noContentDisplay"
      width="100"
      src="/image/no_content.png"
    ></v-img>
  </v-container>
</template>


<script>
import Times from '@/components/issues/Times.vue'
import Offers from '@/components/issues/Offers.vue'
import Requests from '@/components/issues/Requests.vue'
import RefineSearch from '@/components/props/RefineSearch.vue'
export default {
  components: {
    Times,
    Requests,
    Offers,
    RefineSearch,
  },

  head: {
    title: '登録一覧',
  },

  computed: {
    noContentDisplay() {
      return (
        this.$store.state.issues.times.times.length === 0 &&
        this.$store.state.issues.offers.offers.length === 0 &&
        this.$store.state.issues.requests.requests.length === 0
      )
    },
  },

  methods: {
    refineSearch(value) {
      switch (value) {
        case 'all':
          this.$router.push('/issues')
          break
        case 'times':
          this.$router.push('/issues/times')
          break
        case 'offers':
          this.$router.push('/issues/offers')
          break
        case 'requests':
          this.$router.push('/issues/requests')
          break
      }
    },
  },
}
</script>

<style scoped>
.noContent {
  position: fixed;
  top: 50%;
  left: 43%;
}
</style>