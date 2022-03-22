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
  </v-container>
</template>

<script>
import { mapGetters } from 'vuex'
import TimeCard from '@/components/TimeCard.vue'
export default {
  components: {
    TimeCard,
  },

  computed: {
    ...mapGetters({
      agreementsInProgress: 'agreements/agreementsInProgress',
    }),
  },

  methods: {
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
      this.$emit('click-open-dialog', agreementId, roomId, phone)
    },
  },
}
</script>