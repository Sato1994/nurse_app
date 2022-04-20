<template>
  <v-container>
    <v-toolbar class="mb-2" flat rounded dense color="red" dark>
      <v-toolbar-title>契約中</v-toolbar-title>
    </v-toolbar>

    <v-row>
      <v-col
        v-for="(agreement, i) in inProgress"
        :key="i"
        cols="12"
        sm="6"
        md="6"
        lg="6"
      >
        <TimeCard
          :partnerLink="`/rooms/${agreement.roomId}`"
          :cardIsHover="true"
          :partnerName="agreement.partner.name"
          :startTime="agreement.startTime"
          :finishTime="agreement.finishTime"
          :color="timeCardColor(agreement)"
          @click.native="$router.push(`/rooms/${agreement.roomId}`)"
        >
          <template #description>
            <v-card-subtitle v-if="agreement.state === 'requesting'">
              契約変更中。{{
                $store.getters['agreement/formattingTo6HoursLater'](agreement)
              }}までに再確定してください
            </v-card-subtitle>
            <v-card-subtitle
              v-if="
                agreement.state === 'before' || agreement.state === 'during'
              "
            >
              契約中
            </v-card-subtitle>
          </template>
        </TimeCard>
      </v-col>
    </v-row>
    <v-toolbar class="my-2" flat rounded dense color="red" dark>
      <v-toolbar-title>勤務済</v-toolbar-title>
    </v-toolbar>
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
    ...mapGetters('issues/agreements', ['inProgress']),
  },

  methods: {
    timeCardColor(agreement) {
      if (agreement.state === 'requesting') {
        return 'teal'
      } else if (agreement.state === 'before' || agreement.state === 'during') {
        return 'red'
      } else {
        return 'warning'
      }
    },
  },
}
</script>