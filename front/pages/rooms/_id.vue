<!--
<template>
  <v-app id="inspire">
    <v-subheader> {{ partner.name }}さま </v-subheader>
    <v-subheader
      v-if="closed == ($cookies.get('user') == 'user' ? 'host' : 'user')"
    >
      お相手がトークルームから退出しました
    </v-subheader>
    <v-subheader v-if="state == 'conclusion'"
      >{{ startTime.year }}年{{ startTime.month }}月{{ startTime.day }}日{{
        startTime.hour
      }}時{{ startTime.minute }}分から {{ finishTime.year }}年{{
        finishTime.month
      }}月{{ finishTime.day }}日{{ finishTime.hour }}時{{
        finishTime.minute
      }}分で契約済みです。契約の変更は契約一覧から申請してください。</v-subheader
    >
    <v-subheader v-if="state == $cookies.get('user')"
      >{{ startTime.year }}年{{ startTime.month }}月{{ startTime.day }}日{{
        startTime.hour
      }}時{{ startTime.minute }}分から {{ finishTime.year }}年{{
        finishTime.month
      }}月{{ finishTime.day }}日{{ finishTime.hour }}時{{
        finishTime.minute
      }}分で同意しています。お相手の同意をお待ちください。</v-subheader
    >
    <v-subheader
      v-if="state == ($cookies.get('user') == 'user' ? 'host' : 'user')"
      >お相手が{{ startTime.year }}年{{ startTime.month }}月{{
        startTime.day
      }}日{{ startTime.hour }}時{{ startTime.minute }}分から
      {{ finishTime.year }}年{{ finishTime.month }}月{{ finishTime.day }}日{{
        finishTime.hour
      }}時{{
        finishTime.minute
      }}分で同意しました。双方の同意で契約完了します。</v-subheader
    >
    <v-subheader v-if="state == 'cancelled'"
      >やむを得ない理由により交渉がキャンセルされました。</v-subheader
    >
    <v-main v-if="state == 'negotiating'" three-line>
      <div class="text-overline mb-4">いつから</div>
      <v-card-actions>
        <v-select
          v-model="startTime.year"
          :items="yearList"
          label="年"
          dense
        ></v-select>
        <v-select
          v-model="startTime.month"
          :items="monthList"
          label="月"
          dense
        ></v-select>
        <v-select
          v-model="startTime.day"
          :items="dayList"
          label="日"
          dense
        ></v-select>
        <v-select
          v-model="startTime.hour"
          :items="hourList"
          label="時"
          dense
        ></v-select>
        <v-select
          v-model="startTime.minute"
          :items="minuteList"
          label="分"
          dense
        ></v-select>
      </v-card-actions>
      <div class="text-overline mb-4">いつまで</div>
      <v-card-actions>
        <v-select
          v-model="finishTime.year"
          :items="yearList"
          label="年"
          dense
        ></v-select>
        <v-select
          v-model="finishTime.month"
          :items="monthList"
          label="月"
          dense
        ></v-select>
        <v-select
          v-model="finishTime.day"
          :items="dayList"
          label="日"
          dense
        ></v-select>
        <v-select
          v-model="finishTime.hour"
          :items="hourList"
          label="時"
          dense
        ></v-select>
        <v-select
          v-model="finishTime.minute"
          :items="minuteList"
          label="分"
          dense
        ></v-select>
      </v-card-actions>
    </v-main>
    <v-main v-if="state != 'cancelled'">
      <v-btn
        v-if="state == 'negotiating'"
        outlined
        rounded
        text
        color="red"
        @click="updateTime"
      >
        時間を変更する
      </v-btn>
      <v-btn
        v-if="state != 'conclusion'"
        outlined
        rounded
        text
        color="red"
        @click="updateState"
      >
        {{
          state == $cookies.get('user')
            ? '同意を解除する'
            : 'この時間で同意する'
        }}
      </v-btn>
    </v-main>
    <v-main v-if="state != 'conclusion'">
      <v-btn outlined rounded text color="red" @click="cancellRoom">
        トークルームを削除する
      </v-btn>
    </v-main>
    <v-main>

      <v-container class="py-8 px-6" fluid>
        <v-row>
          <v-col cols="12">
            <v-card>
              <v-list two-line>
                <template>
                  <v-list-item
                    v-for="(message, index) in mixedMessages"
                    :key="index"
                  >
                    <v-list-item-avatar color="grey darken-1">
                    </v-list-item-avatar>
                    <v-list-item-content>
                      <v-list-item-title
                        >{{ message.name
                        }}{{ message.created_at }}</v-list-item-title
                      >
                      <v-list-item-subtitle>
                        {{ message.message }}
                      </v-list-item-subtitle>
                      <v-divider></v-divider>
                    </v-list-item-content>
                  </v-list-item>
                </template>
              </v-list>
              <v-textarea ref="form" v-model="inputMessage" color="teal">
                <template #label>
                  <div>本文入力 <small>ここです</small></div>
                </template>
              </v-textarea>
              <v-btn @click="sendMessage"> 送信 </v-btn>
            </v-card>
          </v-col>
        </v-row>
      </v-container>
    </v-main>
  </v-app>
</template>
-->

<template>
  <v-card>
    <v-toolbar color="warning" dark>
      <v-toolbar-title>メッセージ</v-toolbar-title>

      <v-spacer></v-spacer>
      <v-subheader>{{ partner.name }}</v-subheader>
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
          @click="updateTime"
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
export default {
  components: {
    InputMessage,
  },
  data: () => ({
    drawer: null,
    messages: [],
    partner: {},
    id: '',
    state: '',
    closed: '',
    startTime: {},
    finishTime: {},
    yearList: [
      2021, 2022, 2023, 2024, 2025, 2026, 2027, 2028, 2029, 2030, 2031,
    ],
    monthList: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
    dayList: [
      1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21,
      22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32,
    ],
    hourList: [
      0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
      21, 22, 23,
    ],
    minuteList: [0, 15, 30, 45],
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
    updateTime() {
      this.$axios
        .patch(
          `/api/rooms/${this.$route.params.id}`,
          {
            start_time: this.formedStartTime,
            finish_time: this.formedFinishTime,
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