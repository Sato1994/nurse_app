<template>
  <v-container>
    <Message />
  </v-container>
</template>

<script>
import Message from '@/components/Message.vue'
export default {
  components: {
    Message,
  },

  async fetch({ store, route }) {
    await store.dispatch('room/getRoom', { roomId: route.params.id })
  },
}
</script>