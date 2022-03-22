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
          :firstButton="true"
          :secondButton="true"
          :dotsButton="true"
          @first-button-click="editAgreement(agreement.id, agreement.roomId)"
          @second-button-click="
            openDialog(agreement.id, agreement.roomId, agreement.partnerPhone)
          "
        />
      </v-col>
    </v-row>
    <v-toolbar class="my-2" flat rounded dense color="red" dark>
      <v-toolbar-title>勤務済</v-toolbar-title>
    </v-toolbar>

    <Confirm
      :dialog="dialog"
      :confirm-title="confirmTitle"
      :confirm-description="confirmDescription"
      :agree-button-text="agreeButtonText"
      :phone="phone"
      :commentIsDisplay="commentIsDisplay"
      @agree-button-click="cancellAgreement"
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
      commentIsDisplay: false,
      confirmTitle: '契約のキャンセル',
      confirmDescription: `一度確定した契約のキャンセルは推奨されません。\nやむを得ない理由によりキャンセルしますか？`,
      agreeButtonText: '契約をキャンセル',
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
      this.$axios
        .patch(
          '/api/agreements/cancell',
          { id: this.agreementId, comment },
          { headers: this.$cookies.get('authInfo') }
        )
        .then(() => {
          this.$store.dispatch(
            'snackbar/setMessage',
            '契約をキャンセルしました。'
          )
          this.$store.dispatch('agreements/updateState', {
            id: this.agreementId,
            state: 'cancelled',
          })
          this.$router.push(`/rooms/${this.roomId}`)
          this.dialog = false
        })
        .catch((error) => {
          if (error.response.status === 400) {
            this.commentIsDisplay = true
            this.confirmTitle = '開始時刻まで48時間を切っています。'
            this.confirmDescription = `お相手に電話して直接キャンセルを申し出てください。\nキャンセル後、簡単に理由を入力し確定を押してください。`
            this.agreeButtonText = '確定'
          }
        })
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

    openDialog(agreementId, roomId, phone) {
      this.dialog = true
      this.agreementId = agreementId
      this.roomId = roomId
      this.phone = phone
    },

    hideDialog() {
      this.dialog = false
      this.commentIsDisplay = false
      this.confirmTitle = '契約のキャンセル'
      this.confirmDescription = `一度確定した契約のキャンセルは推奨されません。\nやむを得ない理由によりキャンセルしますか？`
      this.agreeButtonText = '契約をキャンセル'
    },
  },
}
</script>