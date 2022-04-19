<template>
  <v-container>
    <v-toolbar class="mb-2" flat rounded dense color="green" dark>
      <v-toolbar-title>募集中の時間</v-toolbar-title>
    </v-toolbar>

    <v-row>
      <v-col v-for="(time, i) in times" :key="i" cols="12" sm="6" md="6" lg="6">
        <TimeCard
          color="green darken-3"
          firstButtonText="時間を変更"
          secondButtonText="取り消し"
          dotsButtonText="やあ"
          :startTime="time.startTime"
          :finishTime="time.finishTime"
          :firstButton="true"
          :secondButton="true"
          :dotsButton="true"
          @first-button-click="editTime(time.id)"
          @second-button-click="displayAsRemoveTime(time.id)"
        />
      </v-col>
    </v-row>
    <Confirm
      :confirmDisplay="confirmDisplay"
      @agree-button-click="removeTime"
      @disagree-button-click="hideConfirm"
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
      // 表示の切り替えだけはstoreの一か所を見るわけにはいかない
      confirmDisplay: false,
      timeId: null,
    }
  },

  computed: {
    ...mapGetters({
      times: 'issues/times/timesOnCalendar',
    }),
  },

  methods: {
    removeTime() {
      this.$store.dispatch('issues/times/removeTime', this.timeId)
      this.confirmDisplay = false
    },

    hideConfirm() {
      this.$store.commit('dialog/confirm/hideConfirm')
      this.confirmDisplay = false
    },

    editTime(timeId) {
      console.log('timeの編集機能を作成予定だよ', timeId)
    },

    displayAsRemoveTime(timeId) {
      this.confirmDisplay = true
      this.$store.commit('dialog/confirm/displayAsRemoveTime')
      this.timeId = timeId
    },
  },
}
</script>