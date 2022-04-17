<template>
  <v-container>
    <Search sortBy="distance" />
  </v-container>
</template>

<script>
import Search from '@/components/Search.vue'
export default {
  components: {
    Search,
  },

  head: {
    title: '評価順検索',
  },
}
</script>