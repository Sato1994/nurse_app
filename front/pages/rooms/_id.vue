<template>
  <v-container>
    <v-card class="mx-auto">
      <v-img
        v-if="agreement.state !== 'cancelled'"
        height="250"
        src="https://cdn.vuetifyjs.com/images/cards/cooking.png"
        class="map"
      ></v-img>

      {{ agreement }} @@agreement.agreement@@ {{ room }} @@room.room@@

      <v-container v-if="agreement.state === 'finished'" fluid class="rateArea">
        <v-textarea
          v-model="inputComment"
          append-icon="mdi-send-outline"
          filled
          rows="4"
          label="勤務お疲れさまでした。この病院の評価を投稿しましょう！"
          auto-grow
          :counter="300"
          @click:append="createRate"
        ></v-textarea>
        <v-row align="center" class="mx-0">
          <v-rating
            v-model="inputStar"
            color="amber"
            dense
            size="30"
          ></v-rating>
        </v-row>
      </v-container>
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
        :shaped="false"
        :tile="true"
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
          <v-card-subtitle v-if="room.state === 'conclusion'" class="pb-0">
            契約の途中変更は推奨されていません。</v-card-subtitle
          >
          <v-card-subtitle v-if="room.state === 'cancelled'" class="pb-0">
            やむを得ない理由により交渉がキャンセルされました。</v-card-subtitle
          >

          <v-card-subtitle v-if="timeCardColor === 'teal'" class="pb-0">
            {{
              agreement6HoursLater
            }}までに確定されない場合、契約は破棄されます。
          </v-card-subtitle>
        </template>
      </TimeCard>
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
export default {
  components: {
    Message,
    TimeCard,
    Confirm,
    DatePicker,
  },

  data: () => ({
    inputStar: 0,
    inputComment: '',
    confirmDialog: false,
    datePickerDisplay: false,
    agreementId: null,
    roomId: null,
    phone: null,
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
        return 'teal'
      } else if (
        this.agreement.state === 'before' ||
        this.agreement.state === 'during'
      ) {
        return 'red'
      } else if (
        this.agreement.state === 'cancelled' ||
        this.room.state === 'cancelled' ||
        this.agreement.state === 'finished'
      ) {
        return 'grey'
      } else {
        return 'warning'
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
        : 'この時間で同意'
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
      return this.room.state === 'cancelled'
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

    createRate() {
      this.$axios.post(
        '/api/rates',
        {
          agreement_id: this.agreement.id,
          comment: this.inputComment,
        },
        {
          headers: this.$cookies.get('authInfo'),
        }
      )
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
        this.confirmDialog = false
        this.$store.dispatch(
          'snackbar/setMessage',
          '契約をキャンセルしました。'
        )

        // agreement status変更
        this.$store.commit('agreement/updateState', { state: 'cancelled' })
        // room status変更
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