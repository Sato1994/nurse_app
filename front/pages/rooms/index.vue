<template>
  <v-container>
    <Agreements />
    <Rooms />
  </v-container>
</template>

<script>
import Agreements from '@/components/issues/Agreements.vue'
import Rooms from '@/components/issues/Rooms.vue'

export default {
  components: {
    Agreements,
    Rooms,
  },
  data: () => ({}),

  head: {
    title: 'メッセージ',
  },
}
</script>
