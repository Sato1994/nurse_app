<template>
  <v-container>
    <Times />
  </v-container>
</template>


<script>
import Times from '@/components/issues/Times.vue'
export default {
  components: {
    Times,
  },

  head: {
    title: '募集時間一覧',
  },
}
</script>
