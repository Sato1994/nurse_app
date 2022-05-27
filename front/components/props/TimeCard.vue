<template>
  <v-card
    v-click-outside="onClickOutside"
    outlined
    :tile="tile"
    :class="{ pointer: cardIsHover }"
    :color="color"
    dark
  >
    <v-card-actions class="pb-0 pt-2 text-truncate">
      <v-btn v-if="partnerName" :to="partnerLink" text class="text-h6">
        {{ partnerName }}
      </v-btn>
    </v-card-actions>

    <v-card-text class="body-1 pb-0 pt-2">
      {{ displayDay }}
    </v-card-text>

    <v-card-text class="text-h3 py-0">
      {{ startTime.hour }}:{{ startTime.minute.toString().padStart(2, 0) }}-{{
        finishTime.hour
      }}:{{ finishTime.minute.toString().padStart(2, 0) }}</v-card-text
    >

    <slot name="description"></slot>

    <v-card-actions>
      <v-btn
        v-if="updateStateButton"
        :disabled="!clickable"
        text
        @click="clickUpdateStateButton"
      >
        {{ updateStateButtonText }}
      </v-btn>

      <v-btn
        v-if="updateTimeButton"
        :disabled="!clickable"
        text
        @click="clickUpdateTimeButton"
      >
        時間変更
      </v-btn>

      <v-btn
        v-if="editAgreementButton"
        :disabled="!clickable"
        text
        @click="clickEditAgreementButton"
      >
        時間変更
      </v-btn>

      <v-btn
        v-if="cancellAgreementButton"
        :disabled="!clickable"
        text
        @click="clickCancellAgreementButton"
      >
        契約キャンセル
      </v-btn>

      <v-btn
        v-if="createRoomButton"
        :disabled="!clickable"
        text
        @click="clickCreateRoomButton"
      >
        受け取る
      </v-btn>

      <v-btn
        v-if="removeOfferButton"
        :disabled="!clickable"
        text
        @click="clickRemoveOfferButton"
      >
        拒否する
      </v-btn>

      <v-btn
        v-if="removeRequestButton"
        :disabled="!clickable"
        text
        @click="clickRemoveRequestButton"
      >
        取り消し
      </v-btn>

      <v-btn
        v-if="removeTimeButton"
        :disabled="!clickable"
        text
        @click="clickRemoveTimeButton"
      >
        取り消し
      </v-btn>

      <v-btn
        v-if="createRequestButton"
        :disabled="!clickable"
        text
        @click="clickCreateRequestButton"
      >
        リクエストを送る
      </v-btn>

      <v-btn
        v-if="cancellRoomButton"
        :disabled="!clickable"
        text
        @click="clickCancellRoomButton"
      >
        キャンセル
      </v-btn>

      <v-btn
        v-if="leaveButton"
        :disabled="!clickable"
        text
        @click="clickLeaveButton"
      >
        退出
      </v-btn>
    </v-card-actions>
    <v-card-actions class="pt-0">
      <v-btn v-if="lockButton" icon @click="switchClickable">
        <v-icon>{{ lockIcon }}</v-icon>
      </v-btn>
    </v-card-actions>
  </v-card>
</template>

<script>
export default {
  props: {
    tile: {
      type: Boolean,
      default: false,
    },
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
    cancellRoomButton: {
      type: Boolean,
      default: false,
    },
    leaveButton: {
      type: Boolean,
      default: false,
    },
    color: {
      type: String,
      required: true,
    },
    cardIsHover: {
      type: Boolean,
      default: false,
    },
    lockButton: {
      type: Boolean,
      default: true,
    },
  },

  data() {
    return {
      clickable: false,
    }
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

    lockIcon() {
      if (this.clickable === true) {
        return 'mdi-lock-open-outline'
      } else {
        return 'mdi-lock-outline'
      }
    },
  },

  methods: {
    onClickOutside() {
      this.clickable = false
    },
    switchClickable() {
      this.clickable = !this.clickable
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
    clickCancellRoomButton() {
      this.$emit('cancell-room-button-click')
    },
    clickLeaveButton() {
      this.$emit('leave-button-click')
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