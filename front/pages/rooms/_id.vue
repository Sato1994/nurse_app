<template>
  <v-card>
    <v-card color="warning" flat dark>
      <v-app-bar flat color="rgba(0, 0, 0, 0)">
        <v-btn :to="partnerLink" nuxt text class="text-h6 pl-0"
          >{{ partner.name }}
        </v-btn>
        <v-spacer></v-spacer>

        <v-menu v-if="state != 'conclusion'" bottom left>
          <template #activator="{ on, attrs }">
            <v-btn icon color="white" v-bind="attrs" v-on="on">
              <v-icon>mdi-dots-vertical</v-icon>
            </v-btn>
          </template>

          <v-list btn dense>
            <v-list-item link>
              <v-list-item-title @click="cancellRoom"
                >トークルームを削除する</v-list-item-title
              >
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

      <v-card-subtitle
        v-if="closed == ($cookies.get('user') == 'user' ? 'host' : 'user')"
        >お相手がトークルームから退出しました</v-card-subtitle
      >
      <v-card-subtitle v-if="state == $cookies.get('user')"
        >上記の時間で同意しています。お相手の同意をお待ちください。</v-card-subtitle
      >
      <v-card-subtitle
        v-if="state == ($cookies.get('user') == 'user' ? 'host' : 'user')"
      >
        お相手が上記の時間で同意しました。双方の同意で契約完了します。</v-card-subtitle
      >
      <v-card-subtitle v-if="state == 'conclusion'">
        契約済みです。契約の変更は契約一覧から申請してください。</v-card-subtitle
      >
      <v-card-subtitle v-if="state == 'cancelled'">
        やむを得ない理由により交渉がキャンセルされました。</v-card-subtitle
      >

      <v-card-actions>
        <v-btn
          v-if="state != 'conclusion' && state != 'cancelled'"
          text
          @click="updateState"
        >
          {{
            state == $cookies.get('user')
              ? '同意を解除する'
              : 'この時間で同意する'
          }}</v-btn
        >
        <v-btn
          v-if="state == 'negotiating' && state != 'cancelled'"
          text
          @click="openDatePicker"
        >
          時間を変更する
        </v-btn>
      </v-card-actions>
    </v-card>

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
      ref="datePicker"
      title="時間の登録"
      @register-button-click="updateTime"
    />
  </v-card>
</template>

<script>
import DatePicker from '@/components/dialog/DatePicker.vue'
export default {
  components: {
    DatePicker,
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
          startTime: {
            year: startTime.getFullYear(),
            month: startTime.getMonth() + 1,
            day: startTime.getDate(),
            hour: startTime.getHours(),
            minute: startTime.getMinutes(),
          },
          finishTime: {
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
    inputMessage: '',
  }),

  head() {
    return {
      title: 'メッセージ - ' + this.partner.name,
    }
  },

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
        return new Date(b.created_at) - new Date(a.created_at)
      })
      return messages
    },

    partnerLink() {
      return `/${this.$cookies.get('user') === 'user' ? 'host' : 'user'}/${
        this.partner.myid
      }`
    },
  },

  methods: {
    openDatePicker() {
      this.$refs.datePicker.isDisplay = true
      this.$refs.datePicker.startTime = this.startTime
      this.$refs.datePicker.finishTime = this.finishTime
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

    updateTime(startTime, finishTime) {
      this.$axios
        .patch(
          `/api/rooms/${this.$route.params.id}/update_room_time`,
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
                  `/api/rooms/${this.$route.params.id}/update_room_state`,
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
              `/api/rooms/${this.$route.params.id}/update_room_state`,
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
            `/${this.$cookies.get('user')}/${this.$store.state.info.info.myid}`
          )
        })
    },
  },
}
</script>