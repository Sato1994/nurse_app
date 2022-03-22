<template>
  <v-container>
    <Agreements @click-open-dialog="openDialog" />

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
import Confirm from '@/components/dialog/Confirm.vue'
import Agreements from '@/components/issues/Agreements.vue'
export default {
  components: {
    Confirm,
    Agreements,
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

  head: {
    title: '契約一覧',
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
