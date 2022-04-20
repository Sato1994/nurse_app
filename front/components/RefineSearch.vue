<template>
  <v-app-bar color="teal" class="bar" dark flat dense>
    <v-btn-toggle v-model="text" group mandatory>
      <v-btn v-if="rates" plain value="all"> すべて </v-btn>
      <v-btn v-if="rates" plain value="female"> 女性の評価 </v-btn>
      <v-btn v-if="rates" plain value="male"> 男性の評価 </v-btn>
    </v-btn-toggle>
  </v-app-bar>
</template>

<script>
export default {
  data() {
    return {
      text: 'all',
    }
  },

  props: {
    rates: {
      type: Boolean,
      default: false,
    },
  },

  watch: {
    text(newValue) {
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