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
  </v-container>
</template>

<script>
import { mapGetters } from 'vuex'
import TimeCard from '@/components/TimeCard.vue'

export default {
  components: {
    TimeCard,
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
      this.$emit('click-open-dialog', timeId)
    },
  },
}
</script>