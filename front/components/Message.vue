<template>
  <v-card>
    <TimeCard
      :partnerLink="partnerLink"
      :partnerName="room.partnerName"
      :startTime="room.startTime"
      :finishTime="room.finishTime"
      :firstButton="firstButton"
      :secondButton="secondButton"
      :firstButtonText="firstButtonText"
      :dotsButton="dotsButton"
      :color="timeCardColor"
      secondButtonText="時間を変更する"
      dotsButtonText="トークルームを削除する"
      @first-button-click="updateState"
      @second-button-click="openDatePicker"
      @dots-button-click="displayConfirm"
    >
      <template #description>
        <v-card-subtitle
          v-if="
            room.closed === ($cookies.get('user') === 'user' ? 'host' : 'user')
          "
          >お相手がトークルームから退出しました</v-card-subtitle
        >
        <v-card-subtitle v-if="room.state === $cookies.get('user')"
          >上記の時間で同意しています。お相手の同意をお待ちください。</v-card-subtitle
        >
        <v-card-subtitle
          v-if="
            room.state === ($cookies.get('user') === 'user' ? 'host' : 'user')
          "
        >
          お相手が上記の時間で同意しました。双方の同意で契約完了します。</v-card-subtitle
        >
        <v-card-subtitle v-if="room.state === 'conclusion'">
          契約済みです。契約の途中変更は推奨されていません。</v-card-subtitle
        >
        <v-card-subtitle v-if="room.state === 'cancelled'">
          やむを得ない理由により交渉がキャンセルされました。</v-card-subtitle
        >
        <v-card-subtitle v-if="timeCardColor === 'teal'">
          契約変更中。{{
            agreement6HoursLater
          }}までに確定されない場合、契約は破棄されます。
        </v-card-subtitle>
      </template>
    </TimeCard>

    <v-container v-if="inputEnabled" fluid>
      <v-textarea
        v-model="inputMessage"
        append-icon="mdi-email-fast-outline"
        filled
        rows="2"
        label="入力してください"
        auto-grow
        :counter="500"
        @click:append="sendMessage"
      ></v-textarea>
    </v-container>

    <v-card-text>
      <div class="font-weight-bold ml-8 mb-2">最新</div>

      <v-timeline
        class="overflow-y-auto"
        style="max-height: 500px"
        align-top
        dense
      >
        <v-timeline-item
          v-for="message in room.messages"
          :key="message.createdAt"
          small
        >
          <template v-slot:icon>
            <v-avatar>
              <img :src="message.image" />
            </v-avatar>
          </template>

          <div>
            <div class="font-weight-normal">
              <strong>{{ message.name }}</strong> @{{
                new Date(message.createdAt).getMonth() + 1
              }}/{{ new Date(message.createdAt).getDate() }}&nbsp;{{
                new Date(message.createdAt).getHours()
              }}:{{ new Date(message.createdAt).getMinutes() }}
            </div>
            <div>{{ message.message }}</div>
          </div>
        </v-timeline-item>
      </v-timeline>
    </v-card-text>
    <DatePicker
      title="時間の登録"
      :datePickerDisplay="datePickerDisplay"
      :startTime="room.startTime"
      :finishTime="room.finishTime"
      @register-button-click="updateTime"
      @close-button-click="hideDatePicker"
    />
    <Confirm
      :confirmDisplay="confirmDialog"
      @agree-button-click="cancellRoom"
      @disagree-button-click="hideConfirm"
    />
  </v-card>
</template>

<script>
import { mapActions } from 'vuex'
import DatePicker from '@/components/dialog/DatePicker.vue'
import Confirm from '@/components/dialog/Confirm.vue'
import TimeCard from '@/components/TimeCard.vue'
export default {
  components: {
    DatePicker,
    Confirm,
    TimeCard,
  },

  data: () => ({
    datePickerDisplay: false,
    inputMessage: '',
    confirmDialog: false,
  }),

  computed: {
    room: {
      get() {
        return Object.assign({}, this.$store.getters['room/room'])
      },
    },

    agreement() {
      return this.$store.state.agreement
    },

    agreement6HoursLater() {
      return this.$store.getters['agreement/agreement6HoursLater']
    },

    inputEnabled() {
      if (this.room.closed === 'na') {
        return true
      } else {
        return false
      }
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

    firstButton() {
      return this.room.state !== 'conclusion' && this.room.state !== 'cancelled'
    },

    secondButton() {
      return (
        this.room.state === 'negotiating' && this.room.state !== 'cancelled'
      )
    },

    firstButtonText() {
      return this.room.state === this.$cookies.get('user')
        ? '同意を解除する'
        : 'この時間で同意する'
    },

    dotsButton() {
      return this.room.state !== 'conclusion'
    },
  },

  methods: {
    ...mapActions('room', ['updateState', 'cancellRoom']),

    displayConfirm() {
      this.confirmDialog = true
      this.$store.commit('dialog/confirm/displayAsLeaveRoom')
    },

    hideConfirm() {
      this.confirmDialog = false
    },

    hideDatePicker() {
      this.datePickerDisplay = false
    },

    openDatePicker() {
      this.datePickerDisplay = true
    },

    sendMessage() {
      this.$store.dispatch('room/sendMessage', {
        message: this.inputMessage,
        roomId: this.$route.params.id,
      })
      this.inputMessage = ''
    },

    updateTime(payload) {
      this.$store.dispatch('room/updateTime', {
        startTime: payload.startTime,
        finishTime: payload.finishTime,
        roomId: this.$route.params.id,
      })
      this.datePickerDisplay = false
    },
  },
}
</script>