<template>
  <v-container>
    <Times @click-open-dialog="openDialog" />

    <Confirm
      :dialog="dialog"
      :confirm-title="confirmTitle"
      :confirm-description="confirmDescription"
      :agree-button-text="agreeButtonText"
      @agree-button-click="cancellTime"
      @disagree-button-click="hideDialog"
    />
  </v-container>
</template>


<script>
import Confirm from '@/components/dialog/Confirm.vue'
import Times from '@/components/issues/Times.vue'
export default {
  components: {
    Confirm,
    Times,
  },

  data() {
    return {
      dialog: false,
      confirmTitle: '募集時間の取り消し',
      confirmDescription: `この時間の募集を取り消しますか？`,
      agreeButtonText: '取り消す',
      timeId: null,
    }
  },

  head: {
    title: '募集時間一覧',
  },

  methods: {
    cancellTime() {
      console.log('timeの削除機能をつくる予定だよ。', this.timeId)
    },

    openDialog(timeId) {
      this.dialog = true
      this.timeId = timeId
    },

    hideDialog() {
      this.dialog = false
      this.confirmTitle = '募集時間の取り消し'
      this.confirmDescription = `この時間の募集を取り消しますか？`
      this.agreeButtonText = '取り消す'
    },
  },
}
</script>
