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
        lg="4"
      >
        <TimeCard
          firstButtonText="時間を変更"
          secondButtonText="キャンセル"
          dotsButtonText="やあ"
          :partnerLink="`/${
            $cookies.get('user') === 'user' ? 'host' : 'user'
          }/${agreement.partnerMyid}`"
          :partnerName="agreement.partner.name"
          :startTime="agreement.startTime"
          :finishTime="agreement.finishTime"
          :roomId="agreement.roomId"
          :firstButton="true"
          :secondButton="true"
          :dotsButton="true"
          :color="timeCardColor(agreement)"
          @first-button-click="editAgreement(agreement.id, agreement.roomId)"
          @second-button-click="
            displayAsCancellAgreement(
              agreement.id,
              agreement.roomId,
              agreement.partnerPhone
            )
          "
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
      inProgress: 'issues/agreements/inProgress',
    }),
  },

  methods: {
    cancellAgreement(comment) {
      this.$store
        .dispatch('issues/agreements/cancellAgreement', {
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
            this.$store.commit('dialog/confirm/displayWithComment')
          }
        })
    },

    timeCardColor(agreement) {
      if (agreement.state === 'requesting') {
        return 'teal'
      } else if (agreement.state === 'before' || agreement.state === 'during') {
        return 'red'
      } else {
        return 'warning'
      }
    },

    hideConfirm() {
      this.confirmDisplay = false
      this.$store.commit('dialog/confirm/hideConfirm')
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

    displayAsCancellAgreement(agreementId, roomId, phone) {
      this.confirmDisplay = true
      this.$store.commit('dialog/confirm/displayAsCancellAgreement')
      this.agreementId = agreementId
      this.roomId = roomId
      this.phone = phone
    },
  },
}
</script>