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
              :firstButton="true"
              :secondButton="true"
              :dotsButton="true"
              buttonText="時間を変更"
              secondButtonText="取り消し"
              color="green darken-3"
              dotsButtonText="やあ"
              @first-button-click="editTime(selectedEvent.id)"
              @second-button-click="
                displayConfirmAsRemoveTime(selectedEvent.id)
              "
            />
            <TimeCard
              v-if="selectedEvent.name == '契約済み'"
              color="red darken-3"
              buttonText="時間を変更"
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
                displayConfirmAsCancellAgreement(
                  selectedEvent.id,
                  selectedEvent.roomId,
                  selectedEvent.partnerPhone
                )
              "
            />
            <TimeCard
              v-if="selectedEvent.name == 'オファーがあります'"
              color="blue darken-3"
              buttonText="受け取る"
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
              @second-button-click="
                displayConfirmAsRemoveOffer(selectedEvent.id)
              "
            />
            <TimeCard
              v-if="selectedEvent.name == 'リクエスト中'"
              color="lime darken-3"
              buttonText="取り消し"
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
              @first-button-click="
                displayConfirmAsRemoveRequest(selectedEvent.id)
              "
            />
          </v-card>
        </v-menu>
        <DatePicker
          ref="datePicker"
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

  methods: {
    // それぞれのConfirmでagreeButtonを押したときの挙動
    actionAgreeConfirm(comment) {
      switch (this.selectedEvent.name) {
        case '募集中':
          this.$store.dispatch('times/removeTime', this.selectedEvent.id)
          this.confirmDisplay = false
          break
        case '契約済み':
          this.$store
            .dispatch('agreements/cancellAgreement', {
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
                this.$store.commit('display/displayConfirmWithComment')
              }
            })
          break
        case 'オファーがあります':
          this.$store.dispatch('offers/removeOffer', this.selectedEvent.id)
          this.confirmDisplay = false
          break
        case 'リクエスト中':
          this.$store.dispatch('requests/removeRequest', this.selectedEvent.id)
          this.confirmDisplay = false
          break
        default:
          break
      }
    },

    hideConfirm() {
      this.$store.commit('display/hideConfirm')
      this.confirmDisplay = false
    },

    createRoom(requestId) {
      this.$store.dispatch('rooms/createRoom', requestId)
    },

    editTime(timeId) {
      console.log('timeの編集機能を作成予定だよ', timeId)
    },

    displayConfirmAsRemoveTime(timeId) {
      this.confirmDisplay = true
      this.$store.commit('display/displayConfirmAsRemoveTime')
      this.timeId = timeId
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

    displayConfirmAsCancellAgreement(agreementId, roomId, phone) {
      this.confirmDisplay = true
      this.$store.commit('display/displayConfirmAsCancellAgreement')
      this.agreementId = agreementId
      this.roomId = roomId
      this.phone = phone
    },

    displayConfirmAsRemoveOffer(offerId) {
      this.confirmDisplay = true
      this.$store.commit('display/displayConfirmAsRemoveOffer')
      this.offerId = offerId
    },

    displayConfirmAsRemoveRequest(requestId) {
      this.confirmDisplay = true
      this.$store.commit('display/displayConfirmAsRemoveRequest')
      this.requestId = requestId
    },

    // request(startTime, finishTime, timeId) {
    //   this.$refs.datePicker.isDisplay = true
    //   this.$refs.datePicker.startTime = startTime
    //   this.$refs.datePicker.finishTime = finishTime
    //   this.$refs.datePicker.timeId = timeId
    // },

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