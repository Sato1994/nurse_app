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
          firstButtonText="受け取る"
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
          @second-button-click="displayAsRemoveOffer(offer.id)"
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
      offers: 'offers/offersOnCalendar',
    }),
  },

  methods: {
    ...mapActions('rooms', ['createRoom']),

    removeOffer() {
      this.$store.dispatch('offers/removeOffer', this.offerId)
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