<template>
  <v-container>
    <v-toolbar class="mb-2" flat rounded dense color="lime" dark>
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
          color="lime darken-3"
          firstButtonText="取り消し"
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
          @first-button-click="displayConfirmAsRemoveRequest(request.id)"
        />
      </v-col>
    </v-row>
    <Confirm
      :confirmDisplay="confirmDisplay"
      @agree-button-click="removeRequest"
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
      requestId: null,
    }
  },

  computed: {
    ...mapGetters({
      requests: 'requests/requestsOnCalendar',
    }),
  },

  methods: {
    removeRequest() {
      this.$store.dispatch('requests/removeRequest', this.requestId)
      this.confirmDisplay = false
    },

    hideConfirm() {
      this.$store.commit('display/hideConfirm')
      this.confirmDisplay = false
    },

    displayConfirmAsRemoveRequest(requestId) {
      this.confirmDisplay = true
      this.$store.commit('display/displayConfirmAsRemoveRequest')
      this.requestId = requestId
    },
  },
}
</script>