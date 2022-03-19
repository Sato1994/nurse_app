<template>
  <v-card flat>
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
    <v-toolbar color="red" dark flat>
      <v-toolbar-title>契約</v-toolbar-title>

      <v-spacer></v-spacer>
    </v-toolbar>

    <v-list dense subheader two-line>
      <v-subheader inset>仕事の予定</v-subheader>

      <v-list-item v-for="(agreement, i) in agreementsInProgress" :key="i">
        <v-list-item-avatar>
          <v-icon>mdi-hospital</v-icon>
        </v-list-item-avatar>

        <v-list-item-content>
          <v-list-item-title v-text="agreement.partnerName"></v-list-item-title>

          <v-list-item-subtitle
            >{{ agreement.startTime.month }}月{{ agreement.startTime.day }}日{{
              agreement.startTime.hour
            }}時{{ agreement.startTime.minute }}分から{{
              agreement.finishTime.day
            }}日{{ agreement.finishTime.hour }}時{{
              agreement.finishTime.minute
            }}分</v-list-item-subtitle
          >
        </v-list-item-content>
        <v-subheader inset>{{ agreement.state }}</v-subheader>
        <v-card-actions>
          <v-btn
            text
            color="warning accent-4"
            @click="jumpPartner(agreement.partnerMyid)"
          >
            お相手
          </v-btn>
          <v-btn
            text
            color="warning accent-4"
            @click="editAgreement(agreement.id, agreement.roomId)"
          >
            時間変更
          </v-btn>
          <v-btn
            text
            color="warning accent-4"
            @click="
              openDialog(agreement.id, agreement.roomId, agreement.partnerPhone)
            "
          >
            キャンセル
          </v-btn>
        </v-card-actions>
      </v-list-item>

      <v-divider inset></v-divider>

      <v-subheader inset>何かしら</v-subheader>
    </v-list>
  </v-card>
</template>


<script>
import { mapGetters } from 'vuex'
import Confirm from '@/components/dialog/Confirm.vue'
export default {
  components: {
    Confirm,
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

  computed: {
    ...mapGetters({
      agreementsInProgress: 'agreements/agreementsInProgress',
    }),
  },

  methods: {
    jumpPartner(myid) {
      this.$router.push(
        `/${this.$cookies.get('user') === 'user' ? 'host' : 'user'}/${myid}`
      )
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
        .then((response) => {
          console.log(response)
          this.$router.push(`/rooms/${roomId}`)
        })
        .catch((error) => {
          console.log(error)
        })
    },

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

