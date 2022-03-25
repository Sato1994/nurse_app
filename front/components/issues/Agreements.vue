<template>
  <v-container>
    <v-toolbar class="mb-2" flat rounded dense color="red" dark>
      <v-toolbar-title>契約中</v-toolbar-title>
    </v-toolbar>

    <v-row>
      <v-col
        v-for="(agreement, i) in agreementsInProgress"
        :key="i"
        cols="12"
        sm="6"
        md="6"
        lg="4"
      >
        <TimeCard
          color="red darken-3"
          buttonText="時間を変更"
          secondButtonText="キャンセル"
          dotsButtonText="やあ"
          :partnerLink="`/${
            $cookies.get('user') === 'user' ? 'host' : 'user'
          }/${agreement.partnerMyid}`"
          :partner="agreement.partner"
          :startTime="agreement.startTime"
          :finishTime="agreement.finishTime"
          :roomId="agreement.roomId"
          :firstButton="true"
          :secondButton="true"
          :dotsButton="true"
          @first-button-click="editAgreement(agreement.id, agreement.roomId)"
          @second-button-click="
            displayConfirmAsCancellAgreement(
              agreement.id,
              agreement.roomId,
              agreement.partnerPhone
            )
          "
        />
      </v-col>
    </v-row>
    <v-toolbar class="my-2" flat rounded dense color="red" dark>
      <v-toolbar-title>勤務済</v-toolbar-title>
    </v-toolbar>

    <Confirm
      :confirmDisplay="confirmDisplay"
      :phone="phone"
      @agree-button-click="cancellAgreement"
      @disagree-button-click="hideConfirm"
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
      agreementId: null,
      roomId: null,
      phone: null,
    }
  },

  computed: {
    ...mapGetters({
      agreementsInProgress: 'agreements/agreementsInProgress',
    }),
  },

  methods: {
    cancellAgreement(comment) {
      this.$store
        .dispatch('agreements/cancellAgreement', {
          agreementId: this.agreementId,
          roomId: this.roomId,
          comment,
        })
        .then(() => {
          this.confirmDisplay = false
        })
        // 48時間以内だった場合
        .catch((error) => {
          if (error.response.status === 400) {
            this.confirmDisplay = true
            this.$store.commit('display/displayConfirmWithComment')
          }
        })
    },

    hideConfirm() {
      this.confirmDisplay = false
      this.$store.commit('display/hideConfirm')
    },

    editAgreement(agreementId, roomId) {
      this.$axios
        .patch(
          `/api/agreements/${agreementId}`,
          {},
          {
            headers: this.$cookies.get('authInfo'),
          }
        )
        .then(() => {
          this.$router.push(`/rooms/${roomId}`)
        })
    },

    displayConfirmAsCancellAgreement(agreementId, roomId, phone) {
      this.confirmDisplay = true
      this.$store.commit('display/displayConfirmAsCancellAgreement')
      this.agreementId = agreementId
      this.roomId = roomId
      this.phone = phone
    },
  },
}
</script>