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
        sm="12"
        md="12"
        lg="6"
      >
        <TimeCard
          color="lime darken-3"
          :partnerLink="`/${
            $cookies.get('user') === 'user' ? 'host' : 'user'
          }/${request.partnerMyid}`"
          :partnerName="request.partner.name"
          :startTime="request.startTime"
          :finishTime="request.finishTime"
          :removeRequestButton="true"
          @remove-request-button-click="displayAsRemoveRequest(request.id)"
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
      requests: 'issues/requests/requestsOnCalendar',
    }),
  },

  methods: {
    removeRequest() {
      this.$store.dispatch('issues/requests/removeRequest', this.requestId)
      this.confirmDisplay = false
    },

    hideConfirm() {
      this.$store.commit('dialog/confirm/hideConfirm')
      this.confirmDisplay = false
    },

    displayAsRemoveRequest(requestId) {
      this.confirmDisplay = true
      this.$store.commit('dialog/confirm/displayAsRemoveRequest')
      this.requestId = requestId
    },
  },
}
</script>