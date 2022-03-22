<template>
  <v-container>
    <v-toolbar class="mb-2" flat rounded dense color="indigo" dark>
      <v-toolbar-title>送ったリクエスト</v-toolbar-title>
    </v-toolbar>

    <v-row>
      <v-col
        v-for="(request, i) in requests"
        :key="i"
        cols="12"
        sm="6"
        md="6"
        lg="4"
      >
        <TimeCard
          color="indigo darken-3"
          buttonText="取り消し"
          dotsButtonText="やあ"
          :partnerLink="`/${
            $cookies.get('user') === 'user' ? 'host' : 'user'
          }/${request.partnerMyid}`"
          :partner="request.partner"
          :startTime="request.startTime"
          :finishTime="request.finishTime"
          :firstButton="true"
          :secondButton="false"
          :dotsButton="true"
          @first-button-click="cancellRequest(request.id)"
        />
      </v-col>
    </v-row>
    <Confirm
      :dialog="dialog"
      :confirm-title="confirmTitle"
      :confirm-description="confirmDescription"
      :agree-button-text="agreeButtonText"
      @agree-button-click="cancellRequest"
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
      confirmTitle: 'リクエストの取り消し',
      confirmDescription: `このリクエストを取り消しますか？`,
      agreeButtonText: '取り消す',
      requestId: null,
    }
  },

  computed: {
    ...mapGetters({
      requests: 'requests/requestsOnCalendar',
    }),
  },

  methods: {
    openDialog(requestId) {
      this.dialog = true
      this.requestId = requestId
    },

    cancellRequest() {
      console.log('requestの削除機能をつくる予定だよ。', this.timeId)
    },

    hideDialog() {
      this.dialog = false
      this.confirmTitle = 'リクエストの取り消し'
      this.confirmDescription = `このリクエストを取り消しますか？`
      this.agreeButtonText = '取り消す'
    },
  },
}
</script>