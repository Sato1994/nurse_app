<template>
  <v-container>
    <Search sortBy="rate" />
  </v-container>
</template>

<script>
export default {
  components: {
    Search: () => import('@/components/aggregations/Search.vue'),
  },

  head: {
    title: '距離順検索',
  },
}
</script>