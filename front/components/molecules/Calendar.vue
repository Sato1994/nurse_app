<template>
  <v-row class="fill-height">
    <v-col>
      <v-sheet height="64">
        <v-toolbar flat>
          <v-btn outlined class="mr-4" color="grey darken-2" @click="setToday">
            今日
          </v-btn>
          <v-btn
            fab
            text
            small
            color="grey darken-2"
            @click="$refs.calendar.prev()"
          >
            <v-icon small> mdi-chevron-left </v-icon>
          </v-btn>
          <v-btn
            fab
            text
            small
            color="grey darken-2"
            @click="$refs.calendar.next()"
          >
            <v-icon small> mdi-chevron-right </v-icon>
          </v-btn>
          <v-toolbar-title v-if="$refs.calendar">
            {{ $refs.calendar.title }}
          </v-toolbar-title>
          <v-spacer></v-spacer>

          <v-menu bottom right>
            <template #activator="{ on, attrs }">
              <v-btn outlined color="grey darken-2" v-bind="attrs" v-on="on">
                <span>{{ typeToLabel[type] }}</span>
                <v-icon right> mdi-menu-down </v-icon>
              </v-btn>
            </template>
            <v-list>
              <v-list-item @click="type = 'week'">
                <v-list-item-title>週表示</v-list-item-title>
              </v-list-item>
              <v-list-item @click="type = 'month'">
                <v-list-item-title>月表示</v-list-item-title>
              </v-list-item>
            </v-list>
          </v-menu>
        </v-toolbar>
      </v-sheet>
      <v-sheet height="600">
        <v-calendar
          ref="calendar"
          v-model="focus"
          color="primary"
          :events="events"
          :type="type"
          @click:event="showEvent"
          @click:more="viewWeek"
          @click:date="viewWeek"
        ></v-calendar>

        <v-menu
          v-model="selectedOpen"
          :close-on-content-click="false"
          :activator="selectedElement"
          offset-x
        >
          <v-card class="mx-auto" max-width="">
            <v-card-text>
              <v-sheet color="green lighten-5">
                <div v-if="selectedEvent.name === '募集中'">
                  リクエストを待っています
                </div>
              </v-sheet>
              <v-sheet color="warning lighten-5">
                <div v-if="selectedEvent.name === 'リクエスト中'">
                  リクエストを送っています
                </div>
              </v-sheet>
              <v-sheet color="blue lighten-5">
                <div v-if="selectedEvent.name === 'オファーがあります'">
                  オファーが届いています
                </div>
              </v-sheet>
              <v-sheet color="red lighten-5">
                <div v-if="selectedEvent.name === '契約済み'">
                  契約があります
                </div>
              </v-sheet>

              <p class="text-h4 text--primary">
                {{ selectedEvent.dislayStart }}～{{
                  selectedEvent.displayFinish
                }}
              </p>
              <nuxt-link
                :to="`/${$cookies.get('user') === 'user' ? 'host' : 'user'}/${
                  selectedEvent.partnerMyid
                }`"
                >{{ selectedEvent.partnerName }}</nuxt-link
              >
              <div class="text--primary">
                well meaning and kindly.<br />
                "a benevolent smile"
              </div>
            </v-card-text>
            <v-card-actions>
              <v-btn
                v-if="
                  selectedEvent.name === '募集中' &&
                  $route.params.id != $store.state.info.info.myid
                "
                text
                color="warning darken-1"
                @click="
                  request(
                    selectedEvent.startTime,
                    selectedEvent.finishTime,
                    selectedEvent.id
                  )
                "
              >
                リクエストを送る
              </v-btn>

              <v-btn
                v-if="
                  selectedEvent.name === 'オファーがあります' &&
                  $route.params.id === $store.state.info.info.myid
                "
                text
                color="warning darken-1"
                @click="
                  createRoom(
                    selectedEvent.id,
                    selectedEvent.partnerId,
                    selectedEvent.startTime,
                    selectedEvent.finishTime
                  )
                "
              >
                オファーを受けとる
              </v-btn>
            </v-card-actions>
          </v-card>
        </v-menu>
        <DatePicker
          ref="datePicker"
          title="リクエストを送る"
          @register-button-click="createRequest"
        />
      </v-sheet>
    </v-col>
  </v-row>
</template>

<script>
import DatePicker from '@/components/dialog/DatePicker.vue'
export default {
  components: {
    DatePicker,
  },

  props: {
    events: {
      type: Array,
      default: () => [],
    },
  },

  data: () => ({
    focus: '',
    type: 'month',
    typeToLabel: {
      month: '月表示',
      week: '週表示',
    },
    selectedEvent: {},
    selectedElement: null,
    selectedOpen: false,
  }),

  mounted() {
    this.$refs.calendar.checkChange()
  },

  methods: {
    createRoom(requestId, partnerId, startTime, finishTime) {
      this.$axios
        .post(
          `/api/rooms/${
            this.$cookies.get('user') === 'user' ? 'host' : 'user'
          }/${partnerId}`,
          {
            start_time: startTime,
            finish_time: finishTime,
            request_id: requestId,
          },
          { headers: this.$cookies.get('authInfo') }
        )
        .then((response) => {
          this.$store.dispatch(
            'snackbar/setMessage',
            'トークルームが作成されました。'
          )
          this.$store.dispatch('offers/removeOffer', requestId)
          this.$store.dispatch('rooms/addRoom', response.data)
          this.$router.push(`/rooms/${response.data.id}`)
        })
    },

    request(startTime, finishTime, timeId) {
      this.$refs.datePicker.isDisplay = true
      this.$refs.datePicker.startTime = startTime
      this.$refs.datePicker.finishTime = finishTime
      this.$refs.datePicker.timeId = timeId
    },

    createRequest(startTime, finishTime, timeId) {
      this.$axios
        .post(
          `/api/${this.$cookies.get('user')}_requests/${timeId}`,
          {
            start_time: startTime,
            finish_time: finishTime,
          },
          { headers: this.$cookies.get('authInfo') }
        )
        .then((response) => {
          this.$store.dispatch(
            'snackbar/setMessage',
            'リクエストを送信しました。'
          )
          this.$store.dispatch('requests/addRequest', response.data)
          this.$router.push(
            `/${this.$cookies.get('user')}/${this.$store.state.info.info.myid}`
          )
        })
    },

    viewWeek({ date }) {
      this.focus = date
      this.type = 'week'
    },

    setToday() {
      this.focus = ''
    },

    showEvent({ nativeEvent, event }) {
      const open = () => {
        this.selectedEvent = event
        this.selectedElement = nativeEvent.target
        requestAnimationFrame(() =>
          requestAnimationFrame(() => (this.selectedOpen = true))
        )
      }
      if (this.selectedOpen) {
        this.selectedOpen = false
        requestAnimationFrame(() => requestAnimationFrame(() => open()))
      } else {
        open()
      }
      nativeEvent.stopPropagation()
    },
  },
}
</script>