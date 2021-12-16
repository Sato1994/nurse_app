<template>
  <v-card>
    <v-toolbar color="warning" dark>
      <v-toolbar-title>リクエスト</v-toolbar-title>

      <v-spacer></v-spacer>
    </v-toolbar>

    <v-list dense subheader two-line>
      <v-subheader inset>看護師からのオファー一覧</v-subheader>

      <v-list-item
        v-for="(offer, i) in formedMyOffers"
        :key="i"
        @click="
          createRoom(
            offer.id,
            offer.partner.id,
            offer.start_time,
            offer.finish_time
          )
        "
      >
        <v-list-item-avatar>
          <v-icon>mdi-hospital</v-icon>
        </v-list-item-avatar>

        <v-list-item-content>
          <v-list-item-title v-text="offer.partner.name"></v-list-item-title>

          <v-list-item-subtitle
            v-text="offer.formedOffer"
          ></v-list-item-subtitle>
        </v-list-item-content>
      </v-list-item>

      <v-divider inset></v-divider>

      <v-subheader inset>看護師へのリクエスト一覧</v-subheader>

      <v-list-item
        v-for="(request, i) in formedMyRequests"
        :key="`second-${i}`"
      >
        <v-list-item-avatar>
          <v-icon> mdi-hospital</v-icon>
        </v-list-item-avatar>

        <v-list-item-content>
          <v-list-item-title v-text="request.partner.name"></v-list-item-title>

          <v-list-item-subtitle
            v-text="request.formedRequest"
          ></v-list-item-subtitle>
        </v-list-item-content>
      </v-list-item>
    </v-list>
  </v-card>
</template>


<script>
export default {
  computed: {
    formedMyRequests() {
      const requests = this.$store.getters['requests/requests'].map((obj) => {
        const s = new Date(obj.start_time)
        const f = new Date(obj.finish_time)
        const newObject = {
          id: obj.id,
          partner: obj.partner,
          formedRequest: `${s.getFullYear()}年${
            s.getMonth() + 1
          }月${s.getDate()}日${s.getHours()}時${s.getMinutes()}分から${f.getFullYear()}年${
            f.getMonth() + 1
          }月${f.getDate()}日${f.getHours()}時${f.getMinutes()}分`,
        }
        return newObject
      })
      return requests
    },
    formedMyOffers() {
      const offers = this.$store.getters['offers/offers'].map((obj) => {
        const s = new Date(obj.start_time)
        const f = new Date(obj.finish_time)
        const newObject = {
          id: obj.id,
          recruitmentTime: obj.recruitmentTime,
          partner: obj.partner,
          start_time: obj.start_time,
          finish_time: obj.finish_time,
          formedOffer: `${s.getFullYear()}年${
            s.getMonth() + 1
          }月${s.getDate()}日${s.getHours()}時${s.getMinutes()}分から${f.getFullYear()}年${
            f.getMonth() + 1
          }月${f.getDate()}日${f.getHours()}時${f.getMinutes()}分`,
        }
        return newObject
      })
      return offers
    },
  },
  methods: {
    createRoom(requestId, userID, startTime, finishTime) {
      this.$axios
        .post(
          `/api/rooms/user/${userID}`,
          {
            start_time: startTime,
            finish_time: finishTime,
            request_id: requestId,
          },
          { headers: this.$cookies.get('authInfo') }
        )
        .then((response) => {
          console.log(response.data)
          this.$store.dispatch('offers/removeOffer', requestId)
          this.$store.dispatch('rooms/addRoom', response.data)
        })
        .catch((error) => {
          console.log(error)
        })
    },
  },
}
</script>
