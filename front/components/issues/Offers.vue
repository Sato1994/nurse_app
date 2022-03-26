<template>
  <v-container>
    <v-toolbar class="mb-2" flat rounded dense color="blue" dark>
      <v-toolbar-title>届いたリクエスト</v-toolbar-title>
    </v-toolbar>

    <v-row>
      <v-col
        v-for="(offer, i) in offers"
        :key="i"
        cols="12"
        sm="6"
        md="6"
        lg="4"
      >
        <TimeCard
          color="blue darken-3"
          buttonText="受け取る"
          secondButtonText="拒否する"
          dotsButtonText="やあ"
          :partnerLink="`/${
            $cookies.get('user') === 'user' ? 'host' : 'user'
          }/${offer.partnerMyid}`"
          :partner="offer.partner"
          :startTime="offer.startTime"
          :finishTime="offer.finishTime"
          :firstButton="true"
          :secondButton="true"
          :dotsButton="true"
          @first-button-click="createRoom(offer.id)"
          @second-button-click="displayConfirmAsRemoveOffer(offer.id)"
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
      confirmDisplay: false,
      offerId: null,
    }
  },

  computed: {
    ...mapGetters({
      offers: 'offers/offersOnCalendar',
    }),
  },

  methods: {
    removeOffer() {
      this.$store.dispatch('offers/removeOffer', this.offerId)
      this.confirmDisplay = false
    },

    hideConfirm() {
      this.$store.commit('display/hideConfirm')
      this.confirmDisplay = false
    },

    displayConfirmAsRemoveOffer(offerId) {
      this.confirmDisplay = true
      this.$store.commit('display/displayConfirmAsRemoveOffer')
      this.offerId = offerId
    },

    createRoom(offerId) {
      console.log('roomをさくせいするよ', offerId)
    },
  },
}
</script>