<template>
  <v-container>
    <Agreements />
    <Times />
    <Offers />
    <Requests />
  </v-container>
</template>


<script>
import Agreements from '@/components/issues/Agreements.vue'
import Times from '@/components/issues/Times.vue'
import Offers from '@/components/issues/Offers.vue'
import Requests from '@/components/issues/Requests.vue'
export default {
  components: {
    Agreements,
    Times,
    Requests,
    Offers,
  },

  head: {
    title: '登録一覧',
  },
}
</script>
