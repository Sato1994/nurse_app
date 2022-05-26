<template>
  <v-container>
    <v-card class="mx-auto">
      <div>
        <GmapMap
          v-if="mapDisplay"
          map-type-id="roadmap"
          :center="endLocation"
          :zoom="15"
          :style="{ width: '100%', height: '250px' }"
          :options="mapOptions"
        >
          <DirectionsRenderer
            travelMode="DRIVING"
            :origin="startLocation"
            :destination="endLocation"
          />
        </GmapMap>
      </div>

      <TimeCard
        :partnerLink="partnerLink"
        :partnerName="room.partnerName"
        :startTime="room.startTime"
        :finishTime="room.finishTime"
        :updateStateButton="updateStateButton"
        :updateTimeButton="updateTimeButton"
        :updateStateButtonText="updateStateButtonText"
        :editAgreementButton="editAgreementButton"
        :cancellAgreementButton="cancellAgreementButton"
        :leaveButton="leaveButton"
        :cancellRoomButton="cancellRoomButton"
        :color="timeCardColor"
        :tile="true"
        :lockButton="lockButton"
        @update-state-button-click="updateState"
        @update-time-button-click="openDatePicker"
        @edit-agreement-button-click="
          editAgreement({ agreementId: agreement.id })
        "
        @cancell-agreement-button-click="displayAsCancellAgreement"
        @cancell-room-button-click="displayConfirm"
        @leave-button-click="leaveRoom"
      >
        <template #description>
          <v-card-subtitle
            v-if="
              room.closed ===
              ($cookies.get('user') === 'user' ? 'host' : 'user')
            "
            class="pb-0"
            >お相手がトークルームから退出しました</v-card-subtitle
          >
          <v-card-subtitle
            v-if="room.state === $cookies.get('user')"
            class="pb-0"
            >お相手の同意をお待ちください。</v-card-subtitle
          >
          <v-card-subtitle
            v-if="
              room.state === ($cookies.get('user') === 'user' ? 'host' : 'user')
            "
            class="pb-0"
          >
            あなたの同意で契約完了します。</v-card-subtitle
          >
          <v-card-subtitle
            v-if="room.state === 'conclusion' && agreement.state === 'before'"
            class="pb-0"
          >
            契約の途中変更は推奨されていません。</v-card-subtitle
          >

          <v-card-subtitle v-if="agreement.state === 'during'" class="pb-0">
            現在勤務時間です</v-card-subtitle
          >

          <v-card-subtitle v-if="room.state === 'cancelled'" class="pb-0">
            やむを得ない理由により交渉がキャンセルされました。</v-card-subtitle
          >

          <v-card-subtitle v-if="timeCardColor === '#2EC4B6'" class="pb-0">
            {{
              agreement6HoursLater
            }}までに確定されない場合、契約は破棄されます。
          </v-card-subtitle>
        </template>
      </TimeCard>
      <Rate
        :inputRateDisplay="inputRateDisplay"
        :rateDisplay="rateDisplay"
        :rate="agreement.rate"
        @agree-button-click="createRate"
      />

      <CancellComment
        :cancellCommentDisplay="cancellCommentDisplay"
        :comment="agreement.cancellComment.comment"
      />

      <Message />
      <Confirm
        :confirmDisplay="confirmDialog"
        :phone="room.partnerPhone"
        @agree-button-click="actionConfirmAgree"
        @disagree-button-click="hideConfirm"
      />
      <DatePicker
        title="時間の登録"
        :datePickerDisplay="datePickerDisplay"
        :startTime="room.startTime"
        :finishTime="room.finishTime"
        @register-button-click="updateTime"
        @close-button-click="hideDatePicker"
      />
    </v-card>
  </v-container>
</template>

<script>
import { mapActions } from 'vuex'
import Message from '@/components/props/Message.vue'
import TimeCard from '@/components/props/TimeCard.vue'
import Confirm from '@/components/dialog/Confirm.vue'
import DatePicker from '@/components/dialog/DatePicker.vue'
import DirectionsRenderer from '@/components/props/DirectionsRenderer.vue'
import Rate from '@/components/props/Rate.vue'
import CancellComment from '@/components/props/CancellComment.vue'
export default {
  components: {
    Message,
    TimeCard,
    Confirm,
    DatePicker,
    DirectionsRenderer,
    Rate,
    CancellComment,
  },

  data: () => ({
    inputStar: 0,
    inputComment: '',
    confirmDialog: false,
    datePickerDisplay: false,
    agreementId: null,
    roomId: null,
    phone: null,
    mapOptions: {
      streetViewControl: false,
      mapTypeControl: false,
      zoomControl: false,
    },
  }),

  async fetch({ store, route }) {
    await store.dispatch('room/getRoom', { roomId: route.params.id })
  },

  computed: {
    agreement() {
      return this.$store.getters['agreement/agreement']
    },
    room() {
      return this.$store.getters['room/room']
    },

    agreement6HoursLater() {
      return this.$store.getters['agreement/agreement6HoursLater']
    },

    timeCardColor() {
      if (this.agreement.state === 'requesting') {
        return '#2EC4B6'
      } else if (
        this.agreement.state === 'before' ||
        this.agreement.state === 'during'
      ) {
        return '#F26157'
      } else if (
        this.agreement.state === 'cancelled' ||
        this.room.state === 'cancelled' ||
        this.agreement.state === 'finished'
      ) {
        return '#89A7A7'
      } else {
        return '#FCAF58'
      }
    },

    partnerLink() {
      return `/${this.$cookies.get('user') === 'user' ? 'host' : 'user'}/${
        this.room.partnerMyid
      }`
    },

    updateStateButton() {
      return this.room.state !== 'conclusion' && this.room.state !== 'cancelled'
    },

    updateStateButtonText() {
      return this.room.state === this.$cookies.get('user')
        ? '同意を解除'
        : '時間に同意'
    },

    updateTimeButton() {
      return (
        this.room.state === 'negotiating' && this.room.state !== 'cancelled'
      )
    },

    editAgreementButton() {
      return this.agreement.state === 'before'
    },

    cancellAgreementButton() {
      return (
        (this.agreement.state === 'before' ||
          this.agreement.state === 'requesting') &&
        this.$cookies.get('user') === 'user'
      )
    },

    cancellRoomButton() {
      return this.agreement.id === null && this.room.state !== 'cancelled'
    },

    leaveButton() {
      return (
        (this.room.state === 'cancelled' ||
          this.agreement.state === 'finished') &&
        this.room.closed !== this.$cookies.get('user') &&
        this.room.closed !== 'both'
      )
    },

    lockButton() {
      return (
        this.updateStateButton ||
        this.updateTimeButton ||
        this.editAgreementButton ||
        this.cancellAgreementButton ||
        this.leaveButton ||
        this.cancellRoomButton
      )
    },

    mapDisplay() {
      if (this.agreement.id) {
        return (
          this.$cookies.get('user') === 'user' &&
          (this.agreement.state === 'before' ||
            this.agreement.state === 'requesting')
        )
      } else {
        return (
          this.$cookies.get('user') === 'user' &&
          this.room.state !== 'cancelled'
        )
      }
    },

    inputRateDisplay() {
      return (
        this.$cookies.get('user') === 'user' &&
        this.agreement.state === 'finished' &&
        !this.agreement.rate.comment
      )
    },

    rateDisplay() {
      return (
        this.$cookies.get('user') === 'user' &&
        this.agreement.state === 'finished' &&
        this.agreement.rate.comment !== null
      )
    },

    cancellCommentDisplay() {
      return this.agreement.cancellComment.comment !== null
    },

    maplocation() {
      return {
        lng: this.room.partnerLng,
        lat: this.room.partnerLat,
      }
    },

    startLocation() {
      return {
        lng: this.$store.state.info.info.lng,
        lat: this.$store.state.info.info.lat,
      }
    },

    endLocation() {
      return {
        lng: this.room.partnerLng,
        lat: this.room.partnerLat,
      }
    },
  },

  methods: {
    ...mapActions('room', ['updateState', 'leaveRoom']),
    ...mapActions('agreement', ['editAgreement']),

    actionConfirmAgree(comment) {
      this.agreement.id === null
        ? this.cancellRoom()
        : this.cancellAgreement(comment)
    },

    cancellRoom() {
      this.$store.dispatch('room/cancellRoom')
      this.confirmDialog = false
    },

    async createRate(payload) {
      try {
        await this.$axios.post(
          '/api/rates',
          {
            agreement_id: this.agreement.id,
            comment: payload.comment,
            star: payload.star,
          },
          {
            headers: this.$cookies.get('authInfo'),
          }
        )
        this.$store.commit('agreement/saveRate', {
          comment: payload.comment,
          star: payload.star,
        })
      } catch {}
    },

    displayConfirm() {
      this.confirmDialog = true
      this.$store.commit('dialog/confirm/displayAsLeaveRoom')
    },

    hideConfirm() {
      this.confirmDialog = false
      this.$store.commit('dialog/confirm/hideConfirm')
    },
    hideDatePicker() {
      this.datePickerDisplay = false
    },

    openDatePicker() {
      this.datePickerDisplay = true
    },

    updateTime(payload) {
      this.$store.dispatch('room/updateTime', {
        startTime: payload.startTime,
        finishTime: payload.finishTime,
        roomId: this.$route.params.id,
      })
      this.datePickerDisplay = false
    },

    displayAsCancellAgreement() {
      this.confirmDialog = true
      this.$store.commit('dialog/confirm/displayAsCancellAgreement')
    },

    async cancellAgreement(comment) {
      try {
        const { data } = await this.$axios.patch(
          '/api/agreements/cancell',
          { id: this.agreement.id, comment },
          { headers: this.$cookies.get('authInfo') }
        )
        this.$store.commit('dialog/confirm/reset')
        this.confirmDialog = false
        this.$store.dispatch(
          'snackbar/setMessage',
          '契約をキャンセルしました。'
        )
        if (comment.length) {
          this.$store.commit('agreement/saveCancellComment', { comment })
        }
        this.$store.commit('agreement/updateState', { state: 'cancelled' })
        this.$store.commit('room/updateState', { state: 'cancelled' })
        // agreementsから削除
        this.$store.commit('issues/agreements/removeAgreement', {
          id: this.agreement.id,
        })
        // 代わりにroomsに代入
        this.$store.commit('issues/rooms/addRoom', data.room)
      } catch (error) {
        // 48時間以内だった場合
        if (error.response.status === 400) {
          this.confirmDisplay = true
          this.$store.commit('dialog/confirm/displayWithComment')
        }
      }
    },
  },
}
</script>