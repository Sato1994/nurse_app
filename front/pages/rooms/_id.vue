<template>
  <v-container>
    <v-card class="mx-auto">
      <v-img
        v-if="agreement.state !== 'cancelled'"
        height="250"
        src="https://cdn.vuetifyjs.com/images/cards/cooking.png"
        class="map"
      ></v-img>

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
        :cancellRoomButton="cancellRoomButton"
        :color="timeCardColor"
        :shaped="false"
        :tile="true"
        @update-state-button-click="updateState"
        @update-time-button-click="openDatePicker"
        @edit-agreement-button-click="editAgreement"
        @cancell-agreement-button-click="displayAsCancellAgreement"
        @cancell-room-button-click="displayConfirm"
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

          <!--これがリアクティブじゃない-->
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
        @agree-button-click="cancellRoom"
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

    // button 関係
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
      return this.agreement.state === 'before'
    },
    cancellRoomButton() {
      return this.room.state !== 'conclusion'
    },

    // ///////////
  },

  methods: {
    ...mapActions('room', ['updateState', 'cancellRoom']),
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

    editAgreement() {
      this.$axios
        .patch(
          `/api/agreements/${this.agreement.id}`,
          {},
          {
            headers: this.$cookies.get('authInfo'),
          }
        )
        .then((response) => {
          console.log('レスポンす', response)
          // リアクティブに反映させてね！！！！！！！2
          // agreement 変更した後の更新
          // {"agreement":{
          //   "user_id":49,
          //   "start_time":"2022-04-27T12:00:00.000+09:00",
          //   "id":1,
          //   "state":"requesting",
          //   "host_id":46,
          //   "room_id":1,
          //   "finish_time":"2022-04-27T17:00:00.000+09:00",
          //   "created_at":"2022-04-20T00:38:27.216+09:00",
          //   "updated_at":"2022-04-20T00:45:47.696+09:00"},
          //   "room":{
          //     "id":1,
          //     "state":"negotiating",
          //     "user_id":49,
          //     "host_id":46,
          //     "start_time":"2022-04-27T12:00:00.000+09:00",
          //     "finish_time":"2022-04-27T17:00:00.000+09:00",
          //     "closed":"na",
          //     "created_at":"2022-04-20T00:38:27.190+09:00",
          //     "updated_at":"2022-04-20T00:45:47.714+09:00"}
          //     }
        })
    },
    displayAsCancellAgreement() {
      this.confirmDialog = true
      this.$store.commit('dialog/confirm/displayAsCancellAgreement')
    },

    cancellAgreement(comment) {
      this.$store
        .dispatch('issues/agreements/cancellAgreement', {
          agreementId: this.agreement.id,
          roomId: this.room.id,
          comment,
        })
        .then(() => {
          this.confirmDisplay = false
        })
        // 48時間以内だった場合
        .catch((error) => {
          if (error.response.status === 400) {
            this.confirmDisplay = true
            this.$store.commit('dialog/confirm/displayWithComment')
          }
        })
    },
  },
}
</script>