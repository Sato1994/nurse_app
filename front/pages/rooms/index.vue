<template>
  <v-container>
    <Agreements />
    <Rooms />
    <v-img
      class="noContent"
      v-if="noContentDisplay"
      width="100"
      src="/image/no_content.png"
    ></v-img>
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

  computed: {
    noContentDisplay() {
      return (
        this.$store.state.issues.rooms.rooms.length === 0 &&
        this.$store.state.issues.agreements.agreements.length === 0
      )
    },
  },
}
</script>

<style scoped>
.noContent {
  position: fixed;
  top: 50%;
  left: 43%;
}
</style>