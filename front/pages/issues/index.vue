<template>
  <v-container>
    <Agreements />
    <Times />
  </v-container>
</template>


<script>
import Agreements from '@/components/issues/Agreements.vue'
import Times from '@/components/issues/Times.vue'
export default {
  components: {
    Agreements,
    Times,
  },

  head: {
    title: '登録一覧',
  },
}
</script>
