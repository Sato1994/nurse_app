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
        </v-toolbar>
      </v-sheet>
      <v-sheet height="600">
        <v-calendar
          ref="calendar"
          v-model="focus"
          color="primary"
          :events="events"
          :day-format="dayFormat"
          type="month"
          @click:event="showEvent"
          @click:date="viewWeek"
        ></v-calendar>

        <v-menu
          v-model="selectedOpen"
          :close-on-content-click="false"
          :activator="selectedElement"
          offset-x
        >
          <TimeCard
            v-if="selectedEvent.name === '募集中'"
            :startTime="selectedEvent.startTime"
            :finishTime="selectedEvent.finishTime"
            :removeTimeButton="freeTimeCardConfig.removeTimeButton"
            :createRequestButton="freeTimeCardConfig.createRequestButton"
            color="green darken-3"
            @remove-time-button-click="
              displayAsRemoveTime({
                startTime: selectedEvent.startTime,
                finishTime: selectedEvent.finishTime,
                timeId: selectedEvent.id,
              })
            "
            @create-request-button-click="
              openDatePickerAsCreateRequest({
                startTime: selectedEvent.startTime,
                finishTime: selectedEvent.finishTime,
                timeId: selectedEvent.id,
              })
            "
          />

          <TimeCard
            v-if="selectedEvent.name == '契約済み'"
            color="red darken-3"
            :partnerLink="`/rooms/${selectedEvent.roomId}`"
            :partnerName="selectedEvent.partner.name"
            :startTime="selectedEvent.startTime"
            :finishTime="selectedEvent.finishTime"
            :roomId="selectedEvent.roomId"
            :cardIsHover="true"
            :lockButton="false"
            @click.native="$router.push(`/rooms/${selectedEvent.roomId}`)"
          />

          <TimeCard
            v-if="selectedEvent.name == 'オファーがあります'"
            color="blue darken-3"
            :partnerLink="`/${
              $cookies.get('user') === 'user' ? 'host' : 'user'
            }/${selectedEvent.partnerMyid}`"
            :partnerName="selectedEvent.partner.name"
            :startTime="selectedEvent.startTime"
            :finishTime="selectedEvent.finishTime"
            :createRoomButton="true"
            :removeOfferButton="true"
            @create-room-button-click="createRoom(selectedEvent.id)"
            @remove-offer-button-click="displayAsRemoveOffer(selectedEvent.id)"
          />
          <TimeCard
            v-if="selectedEvent.name == 'リクエスト中'"
            color="lime darken-3"
            :partnerLink="`/${
              $cookies.get('user') === 'user' ? 'host' : 'user'
            }/${selectedEvent.partnerMyid}`"
            :partnerName="selectedEvent.partner.name"
            :startTime="selectedEvent.startTime"
            :finishTime="selectedEvent.finishTime"
            :removeRequestButton="true"
            @remove-request-button-click="
              displayAsRemoveRequest(selectedEvent.id)
            "
          />
        </v-menu>
        <DatePicker
          :title="datePickerTitle"
          :datePickerDisplay="datePickerDisplay"
          :startTime="datePickerStartTime"
          :finishTime="datePickerFinishTime"
          :timeId="timeId"
          @register-button-click="ActionDatePickerAgree"
          @close-button-click="hideDatePicker"
        />
        <Confirm
          :confirmDisplay="confirmDisplay"
          @agree-button-click="actionAgreeConfirm"
          @disagree-button-click="hideConfirm"
        />
      </v-sheet>
    </v-col>
  </v-row>
</template>

<script>
import { mapState, mapActions } from 'vuex'
import DatePicker from '@/components/dialog/DatePicker.vue'
import TimeCard from '@/components/props/TimeCard.vue'
import Confirm from '@/components/dialog/Confirm.vue'
const today = new Date()

export default {
  components: {
    DatePicker,
    TimeCard,
    Confirm,
  },

  props: {
    events: {
      type: Array,
      default: () => [],
    },
    wanted: {
      type: Boolean,
      default: true,
    },
  },

  data: () => ({
    focus: '',
    selectedEvent: {},
    selectedElement: null,
    selectedOpen: false,
    confirmDisplay: false,
    datePickerDisplay: false,
    datePickerStartTime: {
      year: '',
      month: '',
      day: '',
      hour: '',
      minute: 0,
    },
    datePickerFinishTime: {
      year: today.getFullYear(),
      month: today.getMonth() + 1,
      day: today.getDate(),
      hour: today.getHours(),
      minute: 0,
    },
    timeId: null,
  }),

  computed: {
    ...mapState('info', ['info']),

    freeTimeCardConfig() {
      let config = ''
      // ログインしていて且つ自分のページならば
      if (
        this.$route.path === `/${this.$cookies.get('user')}/${this.info.myid}`
      ) {
        config = {
          removeTimeButton: true,
          createRequestButton: false,
        }
      } else {
        config = {
          removeTimeButton: false,
          createRequestButton: true,
        }
      }
      return config
    },

    datePickerTitle() {
      if (
        this.$route.path === `/${this.$cookies.get('user')}/${this.info.myid}`
      ) {
        return '募集時間を登録'
      } else {
        return 'リクエストを送る'
      }
    },
  },

  mounted() {
    this.$refs.calendar.checkChange()
  },

  methods: {
    ...mapActions('issues/rooms', ['createRoom']),
    ...mapActions('issues/times', ['createTime']),

    // それぞれのConfirmでagreeButtonを押したときの挙動
    actionAgreeConfirm(comment) {
      switch (this.selectedEvent.name) {
        case '募集中':
          this.$store.dispatch('issues/times/removeTime', this.selectedEvent.id)
          this.confirmDisplay = false
          break
        case '契約済み':
          this.$store
            .dispatch('issues/agreements/cancellAgreement', {
              agreementId: this.selectedEvent.id,
              roomId: this.selectedEvent.roomId,
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
          break
        case 'オファーがあります':
          this.$store.dispatch(
            'issues/offers/removeOffer',
            this.selectedEvent.id
          )
          this.confirmDisplay = false
          break
        case 'リクエスト中':
          this.$store.dispatch(
            'issues/requests/removeRequest',
            this.selectedEvent.id
          )
          this.confirmDisplay = false
          break
        default:
          break
      }
    },

    ActionDatePickerAgree(payload) {
      // time登録
      if (payload.timeId === null) {
        this.datePickerDisplay = false
        this.createTime({
          startTime: payload.startTime,
          finishTime: payload.finishTime,
        })

        // リクエスト送信
      } else if (payload.timeId !== null) {
        this.datePickerDisplay = false
        this.$store.dispatch('issues/requests/createRequest', {
          startTime: payload.startTime,
          finishTime: payload.finishTime,
          timeId: payload.timeId,
        })
      }
    },

    openDatePickerAsCreateRequest(payload) {
      this.datePickerDisplay = true
      this.datePickerStartTime = payload.startTime
      this.datePickerFinishTime = payload.finishTime
      this.timeId = payload.timeId
    },

    displayAsRemoveTime(payload) {
      this.confirmDisplay = true
      this.$store.commit('dialog/confirm/displayAsRemoveTime')
      this.timeId = payload.timeId
    },

    displayAsRemoveRequest(requestId) {
      this.confirmDisplay = true
      this.$store.commit('dialog/confirm/displayAsRemoveRequest')
      this.requestId = requestId
    },

    displayAsRemoveOffer(offerId) {
      this.confirmDisplay = true
      this.$store.commit('dialog/confirm/displayAsRemoveOffer')
      this.offerId = offerId
    },

    hideConfirm() {
      this.$store.commit('dialog/confirm/hideConfirm')
      this.confirmDisplay = false
    },

    hideDatePicker() {
      this.datePickerDisplay = false
    },

    viewWeek({ date }) {
      this.focus = date
      if (
        this.$route.path === `/${this.$cookies.get('user')}/${this.info.myid}`
      ) {
        const selectedDate = new Date(date)

        const newValue = {
          year: selectedDate.getFullYear(),
          month: selectedDate.getMonth() + 1,
          day: selectedDate.getDate(),
          hour: selectedDate.getHours(),
          minute: 0,
        }

        this.datePickerStartTime = this.datePickerFinishTime = newValue
        this.datePickerDisplay = true
      }
    },

    setToday() {
      this.focus = ''
    },

    showEvent({ nativeEvent, event }) {
      const open = () => {
        if (
          this.$route.path !==
            `/${this.$store.state.info.me}/${this.$store.state.info.info.myid}` &&
          this.wanted === false
        ) {
          this.$store.dispatch(
            'snackbar/setMessage',
            'お相手は現在リクエストを募集していません。'
          )
        } else {
          this.selectedEvent = event
          this.selectedElement = nativeEvent.target
          requestAnimationFrame(() =>
            requestAnimationFrame(() => (this.selectedOpen = true))
          )
        }
      }
      if (this.selectedOpen) {
        this.selectedOpen = false
        requestAnimationFrame(() => requestAnimationFrame(() => open()))
      } else {
        open()
      }
      nativeEvent.stopPropagation()
    },

    dayFormat(date) {
      return new Date(date.date).getDate()
    },
  },
}
</script>