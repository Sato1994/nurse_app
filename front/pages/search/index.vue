<template>
  <v-container>
    <Search />
  </v-container>
</template>

<script>
export default {
  components: {
    Search: () => import('@/components/aggregations/Search.vue'),
  },

  head: {
    title: '検索',
  },
}
</script>