<template>
  <v-container>
    <Search sortBy="distance" />
  </v-container>
</template>

<script>
export default {
  components: {
    Search: () => import('@/components/aggregations/Search.vue'),
  },

  head: {
    title: '評価順検索',
  },
}
</script>