<template>
  <v-container>
    <RefineSearch
      :issues="true"
      text="times"
      @refine-button-click="refineSearch"
    />
    <Times />
  </v-container>
</template>


<script>
import Times from '@/components/issues/Times.vue'
import RefineSearch from '@/components/props/RefineSearch.vue'
export default {
  components: {
    Times,
    RefineSearch,
  },

  head: {
    title: '募集時間一覧',
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
