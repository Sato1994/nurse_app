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
          @second-button-click="openDialog(offer.id)"
        />
      </v-col>
    </v-row>
    <Confirm
      :dialog="dialog"
      :confirm-title="confirmTitle"
      :confirm-description="confirmDescription"
      :agree-button-text="agreeButtonText"
      @agree-button-click="cancellOffer"
      @disagree-button-click="hideDialog"
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
      dialog: false,
      confirmTitle: 'リクエストの拒否',
      confirmDescription: `このリクエストを拒否しますか？`,
      agreeButtonText: '拒否する',
      requestId: null,
    }
  },

  computed: {
    ...mapGetters({
      offers: 'offers/offersOnCalendar',
    }),
  },

  methods: {
    openDialog(offerId) {
      this.dialog = true
      this.offerId = offerId
    },

    hideDialog() {
      this.dialog = false
      this.confirmTitle = 'リクエストの拒否'
      this.confirmDescription = `このリクエストを拒否しますか？`
      this.agreeButtonText = '拒否する'
    },

    cancellOffer() {
      console.log('Offer拒否削除機能だよあ', this.offerId)
    },

    createRoom(offerId) {
      console.log('roomをさくせいするよ', offerId)
    },
  },
}
</script>