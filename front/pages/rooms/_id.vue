<template>
  <v-card>
    <v-toolbar color="warning" dark>
      <v-toolbar-title>メッセージ</v-toolbar-title>

      <v-spacer></v-spacer>
      <v-btn :to="partnerLink" nuxt color="warning">{{ partner.name }}</v-btn>
    </v-toolbar>
    <v-card>
      <v-card-text>
        <div class="text--primary">{{ startTime.year }}年</div>
        <p class="text-h4 text--primary">
          {{ startTime.month }}月{{ startTime.day }}日{{ startTime.hour }}時{{
            startTime.minute
          }}分から{{ finishTime.day }}日{{ finishTime.hour }}時{{
            finishTime.minute
          }}分
        </p>
        <p>adjective</p>
        <div
          v-if="closed == ($cookies.get('user') == 'user' ? 'host' : 'user')"
          class="text--primary"
        >
          お相手がトークルームから退出しました
        </div>

        <div v-if="state == $cookies.get('user')" class="text--primary">
          上記の時間で同意しています。お相手の同意をお待ちください。
        </div>

        <div
          v-if="state == ($cookies.get('user') == 'user' ? 'host' : 'user')"
          class="text--primary"
        >
          お相手が上記の時間で同意しました。双方の同意で契約完了します。
        </div>

        <div v-if="state == 'conclusion'">
          契約済みです。契約の変更は契約一覧から申請してください。
        </div>

        <div v-if="state == 'cancelled'">
          やむを得ない理由により交渉がキャンセルされました。
        </div>
      </v-card-text>
      <v-card-actions>
        <v-btn
          v-if="state != 'conclusion' && state != 'cancelled'"
          text
          color="warning accent-4"
          @click="updateState"
        >
          {{
            state == $cookies.get('user')
              ? '同意を解除する'
              : 'この時間で同意する'
          }}
        </v-btn>

        <v-btn
          v-if="state == 'negotiating' && state != 'cancelled'"
          text
          color="warning accent-4"
          @click="openDatePicker"
        >
          時間を変更する
        </v-btn>

        <v-btn
          v-if="state != 'conclusion'"
          text
          color="red"
          @click="cancellRoom"
        >
          トークルームを削除する
        </v-btn>
      </v-card-actions>
    </v-card>
    <DatePicker
      ref="datePicker"
      title="時間の登録"
      @register-button-click="updateTime"
    />

    <v-list two-line dense>
      <v-list-item v-for="(message, index) in mixedMessages" :key="index">
        <v-list-item-avatar color="grey darken-1"> </v-list-item-avatar>

        <v-list-item-content>
          <v-list-item-title>{{ message.name }}</v-list-item-title>

          <v-list-item-subtitle>
            {{ message.message }}
          </v-list-item-subtitle>
        </v-list-item-content>
      </v-list-item>

      <v-divider inset></v-divider>
    </v-list>
    <InputMessage ref="message" @send-button-click="sendMessage" />
    <v-btn
      fixed
      fab
      bottom
      right
      color="warning"
      style="bottom: 50px"
      @click="$refs.message.isDisplay = true"
    >
      <v-icon color="white">mdi-pencil</v-icon>
    </v-btn>
  </v-card>
</template>



<script>
import InputMessage from '@/components/dialog/InputMessage.vue'
import DatePicker from '@/components/dialog/DatePicker.vue'
export default {
  components: {
    InputMessage,
    DatePicker,
  },

  data: () => ({
    messages: [],
    partner: {},
    id: '',
    state: '',
    closed: '',
    startTime: {},
    finishTime: {},
  }),

  computed: {
    formedStartTime() {
      return `${String(this.startTime.year)}-${String(
        this.startTime.month
      )}-${String(this.startTime.day)}T${String(this.startTime.hour)}:${String(
        this.startTime.minute
      )}`
    },

    formedFinishTime() {
      return `${String(this.finishTime.year)}-${String(
        this.finishTime.month
      )}-${String(this.finishTime.day)}T${String(
        this.finishTime.hour
      )}:${String(this.finishTime.minute)}`
    },

    mixedMessages() {
      const messages = this.messages.slice().sort((a, b) => {
        return new Date(a.created_at) - new Date(b.created_at)
      })
      return messages
    },

    partnerLink() {
      return `/${this.$cookies.get('user') === 'user' ? 'host' : 'user'}/${
        this.partner.myid
      }`
    },
  },

  created() {
    this.$axios
      .get(`/api/rooms/${this.$route.params.id}`, {
        headers: this.$cookies.get('authInfo'),
      })
      .then((response) => {
        // Array.pushとArray.concatの違い https://qiita.com/pon_maeda/items/f034cccf3459c1d6505f
        this.messages = this.messages.concat(response.data.user_messages)
        this.messages = this.messages.concat(response.data.host_messages)
        this.id = response.data.id
        this.partner = response.data.partner
        this.state = response.data.state
        this.closed = response.data.closed
        const starttime = new Date(response.data.start_time)
        this.startTime.year = starttime.getFullYear()
        this.startTime.month = starttime.getMonth() + 1
        this.startTime.day = starttime.getDate()
        this.startTime.hour = starttime.getHours()
        this.startTime.minute = starttime.getMinutes()
        const finishtime = new Date(response.data.finish_time)
        this.finishTime.year = finishtime.getFullYear()
        this.finishTime.month = finishtime.getMonth() + 1
        this.finishTime.day = finishtime.getDate()
        this.finishTime.hour = finishtime.getHours()
        this.finishTime.minute = finishtime.getMinutes()
      })
  },

  methods: {
    openDatePicker() {
      this.$refs.datePicker.isDisplay = true
      this.$refs.datePicker.startTime = this.startTime
      this.$refs.datePicker.finishTime = this.finishTime
    },

    sendMessage(message) {
      this.$axios
        .post(
          `/api/${this.$cookies.get('user')}_messages/${this.$route.params.id}`,
          { message },
          { headers: this.$cookies.get('authInfo') }
        )
        .then((response) => {
          console.log(response)
          this.messages.push(response.data)
        })
        .catch((error) => {
          console.log(error)
        })
    },

    updateTime(startTime, finishTime) {
      this.$axios
        .patch(
          `/api/rooms/${this.$route.params.id}`,
          {
            start_time: startTime,
            finish_time: finishTime,
          },
          { headers: this.$cookies.get('authInfo') }
        )
        .then((response) => {
          console.log(response)
        })
        .catch((error) => {
          console.log(error)
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
                start_time: this.formedStartTime,
                finish_time: this.formedFinishTime,
              },
              {
                headers: this.$cookies.get('authInfo'),
              }
            )
            .then((response) => {
              console.log(response)
              this.$axios
                .patch(
                  `/api/rooms/${this.$route.params.id}`,
                  {},
                  {
                    headers: this.$cookies.get('authInfo'),
                  }
                )
                .then((response) => {
                  console.log(response)
                  this.state = response.data.state
                })
                .catch((error) => {
                  console.log(error)
                })
            })
            .catch((error) => {
              console.log(error)
            })
          break
        default:
          this.$axios
            .patch(
              `/api/rooms/${this.$route.params.id}`,
              {},
              {
                headers: this.$cookies.get('authInfo'),
              }
            )
            .then((response) => {
              console.log(response)
              this.state = response.data.state
            })
            .catch((error) => {
              console.log(error)
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
          this.$store.dispatch('rooms/updateClosed', {
            id: this.id,
            closed: response.data.closed,
          })
          this.$store.dispatch('rooms/updateState', {
            id: this.id,
            state: response.data.state,
          })
          this.$router.push(
            `/${this.$cookies.get('user')}/${
              this.$store.state.myInfo.myInfo.myid
            }`
          )
        })
    },
  },
}
</script>