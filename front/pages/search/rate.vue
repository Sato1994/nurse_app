<template>
  <v-container>
    <Search sortBy="rate" />
  </v-container>
</template>

<script>
import Search from '@/components/Search.vue'
export default {
  components: {
    Search,
  },

  head: {
    title: '距離順検索',
  },
}
</script>