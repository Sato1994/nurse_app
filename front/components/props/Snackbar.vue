<template>
  <v-snackbar v-model="snackbar" color="warning">
    {{ getMessageText }}
  </v-snackbar>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'

export default {
  data() {
    return {
      snackbar: false,
    }
  },

  computed: {
    isShow() {
      return this.existsMessage()
    },

    getMessageText() {
      return this.getMessage()
    },
  },

  watch: {
    isShow() {
      this.snackbar = this.existsMessage()
    },

    snackbar() {
      if (!this.snackbar) {
        this.clearMessage()
      }
    },
  },

  methods: {
    ...mapGetters('snackbar', ['getMessage', 'existsMessage']),
    ...mapActions('snackbar', ['clearMessage']),
  },
}
</script>