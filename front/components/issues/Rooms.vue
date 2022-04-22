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
          color="warning"
          :lockButton="false"
          @click.native="$router.push(`/rooms/${room.id}`)"
        >
          <template #description>
            <v-card-subtitle
              v-if="room.state !== 'conclusion' || room.state !== 'cancelled'"
            >
              契約前
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
}
</script>