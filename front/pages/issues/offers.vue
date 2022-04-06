<template>
  <v-container>
    <Offers />
  </v-container>
</template>


<script>
import Offers from '@/components/issues/Offers.vue'
export default {
  components: {
    Offers,
  },

  head: {
    title: '届いたリクエスト',
  },
}
</script>
