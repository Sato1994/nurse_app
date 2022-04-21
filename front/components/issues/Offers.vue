<template>
  <v-container>
    <v-row class="pt-5">
      <v-col
        v-for="(offer, i) in offers"
        :key="i"
        cols="12"
        sm="12"
        md="12"
        lg="6"
      >
        <TimeCard
          color="blue darken-3"
          :partnerLink="`/${
            $cookies.get('user') === 'user' ? 'host' : 'user'
          }/${offer.partnerMyid}`"
          :partnerName="offer.partner.name"
          :startTime="offer.startTime"
          :finishTime="offer.finishTime"
          :createRoomButton="true"
          :removeOfferButton="true"
          @create-room-button-click="createRoom(offer.id)"
          @remove-offer-button-click="displayAsRemoveOffer(offer.id)"
        />
      </v-col>
    </v-row>
    <Confirm
      :confirmDisplay="confirmDisplay"
      @agree-button-click="removeOffer"
      @disagree-button-click="hideConfirm()"
    />
  </v-container>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import Confirm from '@/components/dialog/Confirm.vue'
import TimeCard from '@/components/TimeCard.vue'

export default {
  components: {
    Confirm,
    TimeCard,
  },

  data() {
    return {
      confirmDisplay: false,
      offerId: null,
    }
  },

  computed: {
    ...mapGetters({
      offers: 'issues/offers/offersOnCalendar',
    }),
  },

  methods: {
    ...mapActions('rooms', ['createRoom']),

    removeOffer() {
      this.$store.dispatch('issues/offers/removeOffer', this.offerId)
      this.confirmDisplay = false
    },

    hideConfirm() {
      this.$store.commit('dialog/confirm/hideConfirm')
      this.confirmDisplay = false
    },

    displayAsRemoveOffer(offerId) {
      this.confirmDisplay = true
      this.$store.commit('dialog/confirm/displayAsRemoveOffer')
      this.offerId = offerId
    },
  },
}
</script>