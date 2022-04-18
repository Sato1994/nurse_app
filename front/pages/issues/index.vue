<template>
  <v-container>
    <Times />
    <Offers />
    <Requests />
  </v-container>
</template>


<script>
import Times from '@/components/issues/Times.vue'
import Offers from '@/components/issues/Offers.vue'
import Requests from '@/components/issues/Requests.vue'
export default {
  components: {
    Times,
    Requests,
    Offers,
  },

  head: {
    title: '登録一覧',
  },
}
</script>
