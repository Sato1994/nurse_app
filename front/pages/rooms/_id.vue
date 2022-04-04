<template>
  <v-card>
    <TimeCard
      :partnerLink="partnerLink"
      :partner="partner"
      :startTime="datePickerStartTime"
      :finishTime="datePickerFinishTime"
      :firstButton="firstButton"
      :secondButton="secondButton"
      :firstButtonText="firstButtonText"
      :dotsButton="dotsButton"
      secondButtonText="時間を変更する"
      dotsButtonText="トークルームを削除する"
      color="warning"
      @first-button-click="updateState"
      @second-button-click="openDatePicker"
      @dots-button-click="displayConfirm"
    >
      <template #description>
        <v-card-subtitle
          v-if="closed === ($cookies.get('user') === 'user' ? 'host' : 'user')"
          >お相手がトークルームから退出しました</v-card-subtitle
        >
        <v-card-subtitle v-if="state === $cookies.get('user')"
          >上記の時間で同意しています。お相手の同意をお待ちください。</v-card-subtitle
        >
        <v-card-subtitle
          v-if="state === ($cookies.get('user') === 'user' ? 'host' : 'user')"
        >
          お相手が上記の時間で同意しました。双方の同意で契約完了します。</v-card-subtitle
        >
        <v-card-subtitle v-if="state === 'conclusion'">
          契約済みです。契約の変更は契約一覧から申請してください。</v-card-subtitle
        >
        <v-card-subtitle v-if="state === 'cancelled'">
          やむを得ない理由により交渉がキャンセルされました。</v-card-subtitle
        >
      </template>
    </TimeCard>

    <v-container fluid>
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
          v-for="message in mixedMessages"
          :key="message.created_at"
          :color="message.color"
          small
        >
          <div>
            <div class="font-weight-normal">
              <strong>{{ message.name }}</strong> @{{
                new Date(message.created_at).getMonth() + 1
              }}/{{ new Date(message.created_at).getDate() }}&nbsp;{{
                new Date(message.created_at).getHours()
              }}:{{ new Date(message.created_at).getMinutes() }}
            </div>
            <div>{{ message.message }}</div>
          </div>
        </v-timeline-item>
      </v-timeline>
    </v-card-text>
    <DatePicker
      title="時間の登録"
      :datePickerDisplay="datePickerDisplay"
      :startTime="datePickerStartTime"
      :finishTime="datePickerFinishTime"
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
import DatePicker from '@/components/dialog/DatePicker.vue'
import Confirm from '@/components/dialog/Confirm.vue'
import TimeCard from '@/components/TimeCard.vue'
export default {
  components: {
    DatePicker,
    Confirm,
    TimeCard,
  },

  asyncData({ $cookies, $axios, route }) {
    return $axios
      .get(`/api/rooms/${route.params.id}`, {
        headers: $cookies.get('authInfo'),
      })
      .then((response) => {
        const startTime = new Date(response.data.start_time)
        const finishTime = new Date(response.data.finish_time)
        let messages = response.data.user_messages
        messages = messages.concat(response.data.host_messages)
        return {
          id: response.data.id,
          partner: response.data.partner,
          state: response.data.state,
          closed: response.data.closed,
          color: response.data.color,
          datePickerStartTime: {
            year: startTime.getFullYear(),
            month: startTime.getMonth() + 1,
            day: startTime.getDate(),
            hour: startTime.getHours(),
            minute: startTime.getMinutes(),
          },
          datePickerFinishTime: {
            year: finishTime.getFullYear(),
            month: finishTime.getMonth() + 1,
            day: finishTime.getDate(),
            hour: finishTime.getHours(),
            minute: finishTime.getMinutes(),
          },
          messages,
        }
      })
  },

  data: () => ({
    datePickerDisplay: false,
    inputMessage: '',
    confirmDialog: false,
  }),

  head() {
    return {
      title: 'メッセージ - ' + this.partner.name,
    }
  },

  computed: {
    mixedMessages() {
      const messages = this.messages.slice().sort((a, b) => {
        return new Date(b.created_at) - new Date(a.created_at)
      })
      return messages
    },

    partnerLink() {
      return `/${this.$cookies.get('user') === 'user' ? 'host' : 'user'}/${
        this.partner.myid
      }`
    },
    firstButton() {
      return this.state !== 'conclusion' && this.state !== 'cancelled'
    },
    secondButton() {
      return this.state === 'negotiating' && this.state !== 'cancelled'
    },
    firstButtonText() {
      return this.state === this.$cookies.get('user')
        ? '同意を解除する'
        : 'この時間で同意する'
    },
    dotsButton() {
      return this.state !== 'conclusion'
    },
  },

  methods: {
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
      this.$axios
        .post(
          `/api/${this.$cookies.get('user')}_messages/${this.$route.params.id}`,
          { message: this.inputMessage },
          { headers: this.$cookies.get('authInfo') }
        )
        .then((response) => {
          this.messages.push(response.data)
          this.inputMessage = ''
        })
    },

    updateTime(payload) {
      this.datePickerDisplay = false
      this.$store
        .dispatch('rooms/updateTime', {
          startTime: payload.startTime,
          finishTime: payload.finishTime,
          roomId: this.$route.params.id,
        })
        .then(() => {
          this.datePickerStartTime = payload.startTime
          this.datePickerFinishTime = payload.finishTime
        })
    },

    updateState() {
      // stateが相手の同意ずみの場合はまずagreementをcreateして、成功したらstateを変更するためのリクエストを出す。
      // stateがその他の場合はstateを変更するリクエストを出す。
      switch (this.state) {
        case this.$cookies.get('user') === 'user' ? 'host' : 'user':
          this.$axios
            .post(
              `/api/agreements/${
                this.$cookies.get('user') === 'user' ? 'host' : 'user'
              }/${this.partner.id}`,
              {
                room_id: this.id,
                start_time: this.datePickerStartTime,
                finish_time: this.datePickerFinishTime,
              },
              {
                headers: this.$cookies.get('authInfo'),
              }
            )
            .then(() => {
              this.$axios
                .patch(
                  `/api/rooms/${this.$route.params.id}/update_room_state`,
                  {},
                  {
                    headers: this.$cookies.get('authInfo'),
                  }
                )
                .then((response) => {
                  this.state = response.data.state
                })
            })
          break
        default:
          this.$axios
            .patch(
              `/api/rooms/${this.$route.params.id}/update_room_state`,
              {},
              {
                headers: this.$cookies.get('authInfo'),
              }
            )
            .then((response) => {
              this.state = response.data.state
            })
      }
    },

    cancellRoom() {
      this.$axios
        .patch(
          '/api/rooms/cancell_room',
          { id: this.id },
          { headers: this.$cookies.get('authInfo') }
        )
        .then((response) => {
          this.$store.dispatch(
            'snackbar/setMessage',
            'トークルームを削除しました。'
          )
          this.$store.dispatch('rooms/updateClosed', {
            id: this.id,
            closed: response.data.closed,
          })
          this.$store.dispatch('rooms/updateState', {
            id: this.id,
            state: response.data.state,
          })
          this.$router.push(
            `/${this.$cookies.get('user')}/${this.$store.state.info.info.myid}`
          )
        })
    },
  },
}
</script>