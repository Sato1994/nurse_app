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
  </v-container>
</template>


<script>
import Times from '@/components/issues/Times.vue'
import Offers from '@/components/issues/Offers.vue'
import Requests from '@/components/issues/Requests.vue'
import RefineSearch from '@/components/RefineSearch.vue'
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
