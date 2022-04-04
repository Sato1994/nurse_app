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
          <v-card class="mx-auto" max-width="">
            <TimeCard
              v-if="selectedEvent.name === '募集中'"
              :startTime="selectedEvent.startTime"
              :finishTime="selectedEvent.finishTime"
              :firstButton="freeTimeCardConfig.firstButton"
              :secondButton="freeTimeCardConfig.secondButton"
              :dotsButton="true"
              :firstButtonText="freeTimeCardConfig.firstButtonText"
              :secondButtonText="freeTimeCardConfig.secondButtonText"
              color="green darken-3"
              dotsButtonText="やあ"
              @first-button-click="editTime(selectedEvent.id)"
              @second-button-click="
                actionPushSecondTimeButton({
                  startTime: selectedEvent.startTime,
                  finishTime: selectedEvent.finishTime,
                  timeId: selectedEvent.id,
                })
              "
            />

            <TimeCard
              v-if="selectedEvent.name == '契約済み'"
              color="red darken-3"
              firstButtonText="時間を変更"
              secondButtonText="キャンセル"
              dotsButtonText="やあ"
              :partnerLink="`/${
                $cookies.get('user') === 'user' ? 'host' : 'user'
              }/${selectedEvent.partnerMyid}`"
              :partner="selectedEvent.partner"
              :startTime="selectedEvent.startTime"
              :finishTime="selectedEvent.finishTime"
              :roomId="selectedEvent.roomId"
              :firstButton="true"
              :secondButton="true"
              :dotsButton="true"
              @first-button-click="
                editAgreement(selectedEvent.id, selectedEvent.roomId)
              "
              @second-button-click="
                displayAsCancellAgreement(
                  selectedEvent.id,
                  selectedEvent.roomId,
                  selectedEvent.partnerPhone
                )
              "
            />
            <TimeCard
              v-if="selectedEvent.name == 'オファーがあります'"
              color="blue darken-3"
              firstButtonText="受け取る"
              secondButtonText="拒否する"
              dotsButtonText="やあ"
              :partnerLink="`/${
                $cookies.get('user') === 'user' ? 'host' : 'user'
              }/${selectedEvent.partnerMyid}`"
              :partner="selectedEvent.partner"
              :startTime="selectedEvent.startTime"
              :finishTime="selectedEvent.finishTime"
              :firstButton="true"
              :secondButton="true"
              :dotsButton="true"
              @first-button-click="createRoom(selectedEvent.id)"
              @second-button-click="displayAsRemoveOffer(selectedEvent.id)"
            />
            <TimeCard
              v-if="selectedEvent.name == 'リクエスト中'"
              color="lime darken-3"
              firstButtonText="取り消し"
              dotsButtonText="やあ"
              :partnerLink="`/${
                $cookies.get('user') === 'user' ? 'host' : 'user'
              }/${selectedEvent.partnerMyid}`"
              :partner="selectedEvent.partner"
              :startTime="selectedEvent.startTime"
              :finishTime="selectedEvent.finishTime"
              :firstButton="true"
              :secondButton="false"
              :dotsButton="true"
              @first-button-click="displayAsRemoveRequest(selectedEvent.id)"
            />
          </v-card>
        </v-menu>
        <DatePicker
          title="リクエストを送る"
          @register-button-click="createRequest"
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
import TimeCard from '@/components/TimeCard.vue'
import Confirm from '@/components/dialog/Confirm.vue'

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
  },

  data: () => ({
    focus: '',
    selectedEvent: {},
    selectedElement: null,
    selectedOpen: false,
    confirmDisplay: false,
  }),

  mounted() {
    this.$refs.calendar.checkChange()
  },

  computed: {
    ...mapState('info', ['info']),

    freeTimeCardConfig() {
      let config = ''
      // ログインしていて且つ自分のページならば
      if (
        this.$route.path === `/${this.$cookies.get('user')}/${this.info.myid}`
      ) {
        config = {
          firstButton: true,
          secondButton: true,
          firstButtonText: '時間を変更',
          secondButtonText: '取り消し',
        }
      } else {
        config = {
          firstButton: false,
          secondButton: true,
          firstButtonText: '',
          secondButtonText: 'リクエストを送る',
        }
      }
      return config
    },
  },

  methods: {
    ...mapActions('rooms', ['createRoom']),

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

    // timeのsecondButtonが押されたときの他人のページか自分のページかでのそれぞれの挙動
    actionPushSecondTimeButton(payload) {
      if (
        this.$route.path === `/${this.$cookies.get('user')}/${this.info.myid}`
      ) {
        this.confirmDisplay = true
        this.$store.commit('dialog/confirm/displayAsRemoveTime')
        this.timeId = payload.timeId
      } else {
        this.$refs.datePicker.isDisplay = true
        this.$refs.datePicker.startTime = payload.startTime
        this.$refs.datePicker.finishTime = payload.finishTime
        this.$refs.datePicker.timeId = payload.timeId
      }
    },

    displayAsRemoveRequest(requestId) {
      this.confirmDisplay = true
      this.$store.commit('dialog/confirm/displayAsRemoveRequest')
      this.requestId = requestId
    },

    hideConfirm() {
      this.$store.commit('dialog/confirm/hideConfirm')
      this.confirmDisplay = false
    },

    editTime(timeId) {
      console.log('timeの編集機能を作成予定だよ', timeId)
    },

    editAgreement(agreementId, roomId) {
      this.$axios
        .patch(
          `/api/agreements/${agreementId}`,
          {},
          {
            headers: this.$cookies.get('authInfo'),
          }
        )
        .then(() => {
          this.$router.push(`/rooms/${roomId}`)
        })
    },

    displayAsCancellAgreement(agreementId, roomId, phone) {
      this.confirmDisplay = true
      this.$store.commit('dialog/confirm/displayAsCancellAgreement')
      this.agreementId = agreementId
      this.roomId = roomId
      this.phone = phone
    },

    displayAsRemoveOffer(offerId) {
      this.confirmDisplay = true
      this.$store.commit('dialog/confirm/displayAsRemoveOffer')
      this.offerId = offerId
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
          this.$store.dispatch('issues/requests/addRequest', response.data)
          this.$router.push(
            `/${this.$cookies.get('user')}/${this.$store.state.info.info.myid}`
          )
        })
    },

    viewWeek({ date }) {
      this.focus = date
      console.log(date)
      console.log('日付がおされたよ')
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