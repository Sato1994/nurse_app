<template>
  <v-card :color="color" flat dark>
    <v-app-bar flat color="rgba(0, 0, 0, 0)">
      <v-btn v-if="partner" :to="partnerLink" nuxt text class="text-h6 pl-0"
        >{{ partner.name }}
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

    <v-card-title class="text-h5">
      {{ startTime.month }}/{{ startTime.day }}&nbsp;{{ startTime.hour }}:{{
        startTime.minute
      }}0&nbsp;-&nbsp;{{ finishTime.month }}/{{ finishTime.day }}&nbsp;{{
        finishTime.hour
      }}:{{ finishTime.minute }}0</v-card-title
    >

    <slot name="description"></slot>

    <v-card-actions>
      <v-btn v-if="firstButton" text @click="clickFirstButton">
        {{ buttonText }}</v-btn
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
    partner: {
      type: Object,
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
      required: true,
    },
    buttonText: {
      type: String,
      required: true,
    },
    secondButtonText: {
      type: String,
      required: true,
    },
    dotsButtonText: {
      type: String,
      required: true,
    },
    color: {
      type: String,
      required: true,
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