<template>
  <v-container>
    <v-toolbar class="mb-2" flat rounded dense color="green" dark>
      <v-toolbar-title>募集中の時間</v-toolbar-title>
    </v-toolbar>

    <v-row>
      <v-col v-for="(time, i) in times" :key="i" cols="12" sm="6" md="6" lg="4">
        <TimeCard
          color="green darken-3"
          buttonText="時間を変更"
          secondButtonText="取り消し"
          dotsButtonText="やあ"
          :startTime="time.startTime"
          :finishTime="time.finishTime"
          :firstButton="true"
          :secondButton="true"
          :dotsButton="true"
          @first-button-click="editTime(time.id)"
          @second-button-click="openDialog(time.id)"
        />
      </v-col>
    </v-row>
    <Confirm
      :dialog="dialog"
      :confirm-title="confirmTitle"
      :confirm-description="confirmDescription"
      :agree-button-text="agreeButtonText"
      @agree-button-click="cancellTime"
      @disagree-button-click="hideDialog"
    />
  </v-container>
</template>

<script>
import { mapGetters } from 'vuex'
import Confirm from '@/components/dialog/Confirm.vue'
import TimeCard from '@/components/TimeCard.vue'

export default {
  components: {
    Confirm,
    TimeCard,
  },

  data() {
    return {
      dialog: false,
      confirmTitle: '募集時間の取り消し',
      confirmDescription: `この時間の募集を取り消しますか？`,
      agreeButtonText: '取り消す',
      timeId: null,
    }
  },

  computed: {
    ...mapGetters({
      times: 'times/timesOnCalendar',
    }),
  },

  methods: {
    editTime(timeId) {
      console.log('timeの編集機能を作成予定だよ', timeId)
    },

    openDialog(timeId) {
      this.dialog = true
      this.timeId = timeId
    },

    cancellTime() {
      console.log('timeの削除機能をつくる予定だよ。', this.timeId)
    },

    hideDialog() {
      this.dialog = false
      this.confirmTitle = '募集時間の取り消し'
      this.confirmDescription = `この時間の募集を取り消しますか？`
      this.agreeButtonText = '取り消す'
    },
  },
}
</script>