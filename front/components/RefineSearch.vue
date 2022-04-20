<template>
  <v-app-bar color="red" class="bar" dark flat dense>
    <v-btn-toggle v-model="copiedText" group mandatory>
      <v-btn v-if="rates || targets" plain value="all"> すべて </v-btn>
      <v-btn v-if="rates" plain value="female"> 女性の評価 </v-btn>
      <v-btn v-if="rates" plain value="male"> 男性の評価 </v-btn>

      <v-btn v-if="targets" plain value="distance"> 距離順 </v-btn>
      <v-btn v-if="targets" plain value="rate"> 評価順 </v-btn>
    </v-btn-toggle>
  </v-app-bar>
</template>

<script>
export default {
  props: {
    text: {
      type: String,
      default: 'all',
    },
    rates: {
      type: Boolean,
      default: false,
    },

    targets: {
      type: Boolean,
      default: false,
    },
  },

  computed: {
    copiedText: {
      get() {
        return this.text
      },
      set(newValue) {
        this.changeText(newValue)
      },
    },
  },

  methods: {
    changeText(newValue) {
      this.$emit('refine-button-click', newValue)
    },
  },
}
</script>


<style scoped>
.bar {
  position: fixed;
  top: 96px;
  z-index: 5;
}
</style>