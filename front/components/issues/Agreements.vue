<template>
  <v-container>
    <v-row>
      <v-col
        v-for="(agreement, i) in inProgress"
        :key="i"
        cols="12"
        sm="12"
        md="12"
        lg="6"
      >
        <TimeCard
          :partnerLink="`/rooms/${agreement.roomId}`"
          :cardIsHover="true"
          :partnerName="agreement.partner.name"
          :startTime="agreement.startTime"
          :finishTime="agreement.finishTime"
          :color="timeCardColor(agreement.state)"
          :lockButton="false"
          @click.native="$router.push(`/rooms/${agreement.roomId}`)"
        >
          <template #description>
            <v-card-subtitle v-if="agreement.state === 'requesting'">
              {{
                $store.getters['agreement/formattingTo6HoursLater'](agreement)
              }}までに再確定してください
            </v-card-subtitle>
            <v-card-subtitle v-if="agreement.state === 'before'">
              契約中
            </v-card-subtitle>
            <v-card-subtitle v-if="agreement.state === 'during'">
              現在勤務時間です
            </v-card-subtitle>
          </template>
        </TimeCard>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { mapGetters } from 'vuex'
import TimeCard from '@/components/props/TimeCard.vue'
export default {
  components: {
    TimeCard,
  },

  computed: {
    ...mapGetters('issues/agreements', ['inProgress']),
  },

  methods: {
    timeCardColor(state) {
      switch (state) {
        case 'before':
        case 'during':
          return 'red'
        case 'requesting':
          return 'teal'
        default:
          return 'black'
      }
    },
  },
}
</script>