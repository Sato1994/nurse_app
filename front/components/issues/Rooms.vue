<template>
  <v-container>
    <v-row>
      <v-col
        v-for="(room, i) in rooms"
        :key="i"
        cols="12"
        sm="12"
        md="12"
        lg="6"
      >
        <TimeCard
          :partnerLink="`/rooms/${room.id}`"
          :cardIsHover="true"
          :partnerName="room.partner.name"
          :startTime="room.startTime"
          :finishTime="room.finishTime"
          :color="color(room.state)"
          :lockButton="false"
          @click.native="$router.push(`/rooms/${room.id}`)"
        >
          <template #description>
            <v-card-subtitle
              v-if="
                room.state === 'negotiating' ||
                room.state === 'user' ||
                room.state === 'host'
              "
            >
              契約前
            </v-card-subtitle>
            <v-card-subtitle v-if="room.state === 'cancelled'">
              キャンセル
            </v-card-subtitle>
          </template>

          >
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
    ...mapGetters('issues/rooms', ['rooms']),
  },
  methods: {
    color(state) {
      switch (state) {
        case 'negotiating':
        case 'user':
        case 'host':
          return 'warning'
        case 'cancelled':
          return 'grey'
        default:
          return 'black'
      }
    },
  },
}
</script>