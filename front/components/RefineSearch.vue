<template>
  <v-app-bar color="red" class="bar" dark flat dense>
    <v-btn-toggle v-model="copiedText" group mandatory>
      <v-btn v-if="rates || targets || issues" plain value="all">
        すべて
      </v-btn>

      <v-tooltip bottom>
        <template #activator="{ on, attrs }">
          <v-btn v-if="rates" v-bind="attrs" v-on="on" plain value="female">
            <v-icon>mdi-face-woman</v-icon>
          </v-btn>
        </template>
        <span>女性からの評価</span>
      </v-tooltip>

      <v-tooltip bottom>
        <template #activator="{ on, attrs }">
          <v-btn v-if="rates" v-bind="attrs" v-on="on" plain value="male">
            <v-icon>mdi-face-man</v-icon>
          </v-btn>
        </template>
        <span>男性からの評価</span>
      </v-tooltip>

      <v-tooltip bottom>
        <template #activator="{ on, attrs }">
          <v-btn v-if="targets" v-bind="attrs" v-on="on" plain value="distance">
            <v-icon>mdi-map-marker-distance</v-icon>
          </v-btn>
        </template>
        <span>距離順</span>
      </v-tooltip>

      <v-tooltip bottom>
        <template #activator="{ on, attrs }">
          <v-btn v-if="targets" v-bind="attrs" v-on="on" plain value="rate">
            <v-icon>mdi-star</v-icon>
          </v-btn>
        </template>
        <span>評価順</span>
      </v-tooltip>

      <v-tooltip bottom>
        <template #activator="{ on, attrs }">
          <v-btn v-if="issues" v-bind="attrs" v-on="on" plain value="times">
            <v-icon>mdi-coffee</v-icon>
          </v-btn>
        </template>
        <span>募集時間</span>
      </v-tooltip>
      <v-tooltip bottom>
        <template #activator="{ on, attrs }">
          <v-btn v-if="issues" v-bind="attrs" v-on="on" plain value="offers">
            <v-icon>mdi-arrow-down-bold</v-icon>
          </v-btn>
        </template>
        <span>オファー</span>
      </v-tooltip>

      <v-tooltip bottom>
        <template #activator="{ on, attrs }">
          <v-btn v-if="issues" v-bind="attrs" v-on="on" plain value="requests">
            <v-icon>mdi-arrow-up-bold</v-icon>
          </v-btn>
        </template>
        <span>リクエスト</span>
      </v-tooltip>
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

    issues: {
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