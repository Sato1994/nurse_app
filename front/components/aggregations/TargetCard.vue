<template>
  <v-card class="mx-auto" max-width="344">
    <v-img
      class="white--text align-end"
      src="https://cdn.vuetifyjs.com/images/cards/sunshine.jpg"
      height="200px"
    >
      <v-card-title> {{ target.name }}</v-card-title>
    </v-img>

    <v-card-title> {{ target.address }}</v-card-title>

    <v-card-text v-if="target.rate_average || target.rate_average === 0">
      <v-row align="center" class="mx-0">
        <v-rating
          :value="target.rate_average"
          color="amber"
          dense
          half-increments
          readonly
          size="14"
        ></v-rating>
        <div class="grey--text ms-4">
          {{ target.rate_average }} （{{ target.rate_count }}）
        </div>
      </v-row>
    </v-card-text>

    <v-card-text v-if="target.distance">
      <div class="grey--text ms-4">
        <v-icon color="blue">mdi-map-marker</v-icon>{{ target.distance }}キロ
      </div>
    </v-card-text>

    <v-chip small class="ma-2" text-color="white" :color="wantedChipColor">{{
      target.wanted === true ? '募集中' : '募集していません'
    }}</v-chip>

    <v-card-actions>
      <v-btn color="orange lighten-2" text :to="targetPageURL" nuxt>
        お相手のページへ移動
      </v-btn>

      <v-spacer></v-spacer>

      <v-btn icon @click="show = !show">
        <v-icon>{{ show ? 'mdi-chevron-up' : 'mdi-chevron-down' }}</v-icon>
      </v-btn>
    </v-card-actions>

    <v-expand-transition>
      <div v-show="show">
        <v-divider></v-divider>

        <v-card-text>
          {{ target.profile }}
        </v-card-text>
      </div>
    </v-expand-transition>
  </v-card>
</template>


<script>
export default {
  props: {
    target: {
      type: Object,
      default: () => {},
    },
  },

  data: () => ({
    show: false,
  }),

  computed: {
    targetPageURL() {
      return `/${this.$cookies.get('user') === 'host' ? 'user' : 'host'}/${
        this.target.myid
      }`
    },

    wantedChipColor() {
      return this.target.wanted === true ? 'green' : 'red'
    },
  },
}
</script>