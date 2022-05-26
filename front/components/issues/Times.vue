<template>
  <v-container>
    <v-row class="pt-5">
      <v-col
        v-for="(time, i) in times"
        :key="i"
        cols="12"
        sm="12"
        md="12"
        lg="6"
      >
        <TimeCard
          color="#7DCE82"
          :startTime="time.startTime"
          :finishTime="time.finishTime"
          :removeTimeButton="true"
          @remove-time-button-click="displayAsRemoveTime(time.id)"
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
import TimeCard from '@/components/props/TimeCard.vue'

export default {
  components: {
    Confirm,
    TimeCard,
  },

  data() {
    return {
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

    displayAsRemoveTime(timeId) {
      this.confirmDisplay = true
      this.$store.commit('dialog/confirm/displayAsRemoveTime')
      this.timeId = timeId
    },
  },
}
</script>