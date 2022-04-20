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
      <v-btn v-if="updateStateButton" text @click="clickUpdateStateButton">
        {{ updateStateButtonText }}
      </v-btn>

      <v-btn v-if="updateTimeButton" text @click="clickUpdateTimeButton">
        時間を変更
      </v-btn>

      <v-btn v-if="editAgreementButton" text @click="clickEditAgreementButton">
        契約時間を変更
      </v-btn>

      <v-btn
        v-if="cancellAgreementButton"
        text
        @click="clickCancellAgreementButton"
      >
        契約をキャンセル
      </v-btn>

      <v-btn v-if="createRoomButton" text @click="clickCreateRoomButton">
        受け取る
      </v-btn>

      <v-btn v-if="removeOfferButton" text @click="clickRemoveOfferButton">
        拒否する
      </v-btn>

      <v-btn v-if="removeRequestButton" text @click="clickRemoveRequestButton">
        取り消し
      </v-btn>

      <v-btn v-if="removeTimeButton" text @click="clickRemoveTimeButton">
        取り消し
      </v-btn>

      <v-btn v-if="createRequestButton" text @click="clickCreateRequestButton">
        リクエストを送る
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
    dotsButton: {
      type: Boolean,
      default: false,
    },
    updateStateButton: {
      type: Boolean,
      default: false,
    },
    updateStateButtonText: {
      type: String,
      default: null,
    },
    updateTimeButton: {
      type: Boolean,
      default: false,
    },
    editAgreementButton: {
      type: Boolean,
      default: false,
    },
    createRoomButton: {
      type: Boolean,
      default: false,
    },
    removeOfferButton: {
      type: Boolean,
      default: false,
    },
    removeRequestButton: {
      type: Boolean,
      default: false,
    },
    removeTimeButton: {
      type: Boolean,
      default: false,
    },
    createRequestButton: {
      type: Boolean,
      default: false,
    },
    cancellAgreementButton: {
      type: Boolean,
      default: false,
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
    clickDotsButton() {
      this.$emit('dots-button-click')
    },

    clickCreateRoomButton() {
      this.$emit('create-room-button-click')
    },
    clickCreateRequestButton() {
      this.$emit('create-request-button-click')
    },

    clickUpdateStateButton() {
      this.$emit('update-state-button-click')
    },
    clickUpdateTimeButton() {
      this.$emit('update-time-button-click')
    },
    clickEditAgreementButton() {
      this.$emit('edit-agreement-button-click')
    },

    clickCancellAgreementButton() {
      this.$emit('cancell-agreement-button-click')
    },

    clickRemoveOfferButton() {
      this.$emit('remove-offer-button-click')
    },
    clickRemoveRequestButton() {
      this.$emit('remove-request-button-click')
    },
    clickRemoveTimeButton() {
      this.$emit('remove-time-button-click')
    },
  },
}
</script>

<style scoped>
.pointer:hover {
  cursor: pointer;
}
</style>