<template>
  <v-card flat>
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
            @click="cancellAgreement(agreement.id, agreement.roomId)"
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
export default {
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
    cancellAgreement(agreementId, roomId) {
      this.$axios
        .patch(
          '/api/agreements/cancell',
          { id: agreementId },
          { headers: this.$cookies.get('authInfo') }
        )
        .then((response) => {
          console.log(response)
          this.$store.dispatch('agreements/updateState', {
            id: agreementId,
            state: 'cancelled',
          })
          this.$router.push(`/rooms/${roomId}`)
        })
        .catch((error) => {
          console.log(error)
        })
    },
  },
}
</script>

