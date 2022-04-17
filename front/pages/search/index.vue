<template>
  <v-container>
    <Search />
  </v-container>
</template>

<script>
import Search from '@/components/Search.vue'
export default {
  components: {
    Search,
  },

  head: {
    title: '検索',
  },
}
</script>