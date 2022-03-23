<template>
  <v-container>
    <Agreements />
  </v-container>
</template>


<script>
import Agreements from '@/components/issues/Agreements.vue'
export default {
  components: {
    Agreements,
  },

  head: {
    title: '契約一覧',
  },
}
</script>
