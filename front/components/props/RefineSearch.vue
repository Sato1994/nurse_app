<template>
  <v-app-bar color="#B0C4B1" class="bar" dark flat dense>
    <v-btn-toggle v-model="copiedText" group mandatory>
      <v-btn v-if="rates || targets || issues" plain value="all">
        すべて
      </v-btn>

      <v-tooltip bottom>
        <template #activator="{ on, attrs }">
          <v-btn v-if="rates" plain value="female" v-bind="attrs" v-on="on">
            <v-icon>mdi-face-woman</v-icon>
          </v-btn>
        </template>
        <span>女性からの評価</span>
      </v-tooltip>

      <v-tooltip bottom>
        <template #activator="{ on, attrs }">
          <v-btn v-if="rates" plain value="male" v-bind="attrs" v-on="on">
            <v-icon>mdi-face-man</v-icon>
          </v-btn>
        </template>
        <span>男性からの評価</span>
      </v-tooltip>

      <v-tooltip bottom>
        <template #activator="{ on, attrs }">
          <v-btn
            v-if="targets && $cookies.get('user') === 'user'"
            plain
            value="distance"
            v-bind="attrs"
            v-on="on"
          >
            <v-icon>mdi-map-marker</v-icon>
          </v-btn>
        </template>
        <span>距離順</span>
      </v-tooltip>

      <v-tooltip bottom>
        <template #activator="{ on, attrs }">
          <v-btn v-if="targets" plain value="rate" v-bind="attrs" v-on="on">
            <v-icon>mdi-star</v-icon>
          </v-btn>
        </template>
        <span>評価順</span>
      </v-tooltip>

      <v-tooltip bottom>
        <template #activator="{ on, attrs }">
          <v-btn v-if="issues" plain value="times" v-bind="attrs" v-on="on">
            <v-icon>mdi-coffee</v-icon>
          </v-btn>
        </template>
        <span>募集時間</span>
      </v-tooltip>
      <v-tooltip bottom>
        <template #activator="{ on, attrs }">
          <v-btn v-if="issues" plain value="offers" v-bind="attrs" v-on="on">
            <v-icon>mdi-arrow-down-bold</v-icon>
          </v-btn>
        </template>
        <span>オファー</span>
      </v-tooltip>

      <v-tooltip bottom>
        <template #activator="{ on, attrs }">
          <v-btn v-if="issues" plain value="requests" v-bind="attrs" v-on="on">
            <v-icon>mdi-arrow-up-bold</v-icon>
          </v-btn>
        </template>
        <span>リクエスト</span>
      </v-tooltip>
    </v-btn-toggle>

    <v-tooltip bottom>
      <template #activator="{ on, attrs }">
        <v-btn
          v-if="searchButton"
          plain
          v-bind="attrs"
          v-on="on"
          @click="openSearchDialog"
        >
          <v-icon>mdi-magnify</v-icon>
        </v-btn>
      </template>
      <span>検索</span>
    </v-tooltip>
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

    searchButton: {
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

    openSearchDialog() {
      this.$emit('open-search-dialog-click')
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