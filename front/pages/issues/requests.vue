<template>
  <v-container>
    <Requests />
  </v-container>
</template>


<script>
import Requests from '@/components/issues/Requests.vue'
export default {
  components: {
    Requests,
  },

  head: {
    title: '送ったリクエスト一覧',
  },
}
</script>
