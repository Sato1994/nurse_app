<template>
  <v-card :class="{ pointer: cardIsHover }" :color="color" flat dark>
    <v-app-bar flat color="rgba(0, 0, 0, 0)">
      <v-btn v-if="partnerName" :to="partnerLink" nuxt text class="text-h6 pl-0"
        >{{ partnerName }}
      </v-btn>
      <v-spacer></v-spacer>

      <v-menu v-if="dotsButton" bottom left>
        <template #activator="{ on, attrs }">
          <v-btn icon color="white" v-bind="attrs" v-on="on">
            <v-icon>mdi-dots-vertical</v-icon>
          </v-btn>
        </template>

        <v-list btn dense>
          <v-list-item link>
            <v-list-item-title @click="clickDotsButton">{{
              dotsButtonText
            }}</v-list-item-title>
          </v-list-item>
        </v-list>
      </v-menu>
    </v-app-bar>
    <v-card-title class="body-1">
      {{ displayDay }}
    </v-card-title>
    <v-card-text class="text-h3">
      {{ startTime.hour }}:{{ startTime.minute.toString().padStart(2, 0) }}-{{
        finishTime.hour
      }}:{{ finishTime.minute.toString().padStart(2, 0) }}</v-card-text
    >

    <slot name="description"></slot>

    <v-card-actions>
      <v-btn v-if="firstButton" text @click="clickFirstButton">
        {{ firstButtonText }}</v-btn
      >
      <v-btn v-if="secondButton" text @click="clickSecondButton">
        {{ secondButtonText }}
      </v-btn>
    </v-card-actions>
  </v-card>
</template>

<script>
export default {
  props: {
    partnerLink: {
      type: String,
      default: null,
    },
    partnerName: {
      type: String,
      default: null,
    },
    startTime: {
      type: Object,
      required: true,
    },
    finishTime: {
      type: Object,
      required: true,
    },
    firstButton: {
      type: Boolean,
      required: true,
    },
    secondButton: {
      type: Boolean,
      required: true,
    },
    dotsButton: {
      type: Boolean,
      default: false,
    },
    firstButtonText: {
      type: String,
      required: true,
    },
    secondButtonText: {
      type: String,
      default: null,
    },
    dotsButtonText: {
      type: String,
      default: '',
    },
    color: {
      type: String,
      required: true,
    },
    cardIsHover: {
      type: Boolean,
      default: false,
    },
  },

  computed: {
    displayDay() {
      if (
        this.startTime.month === this.finishTime.month &&
        this.startTime.day === this.finishTime.day
      ) {
        return `${this.startTime.month}/${this.startTime.day}`
      } else {
        return `${this.startTime.month}/${this.startTime.day}  -  ${this.finishTime.month}/${this.finishTime.day}`
      }
    },
  },

  methods: {
    clickFirstButton() {
      this.$emit('first-button-click')
    },
    clickSecondButton() {
      this.$emit('second-button-click')
    },
    clickDotsButton() {
      this.$emit('dots-button-click')
    },
  },
}
</script>

<style scoped>
.pointer:hover {
  cursor: pointer;
}
</style>