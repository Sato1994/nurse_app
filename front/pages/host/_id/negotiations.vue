<template>
  <container>
    <v-list dense>
      <v-subheader>ログイン者のrequest一覧</v-subheader>
      <v-list-item-group
        v-for="(request, index) in formedMyRequests"
        :key="index"
        color="primary"
      >
        <v-list-item>
          <v-list-item-content>
            <v-list-item-title
              v-text="request.formedRequest"
            ></v-list-item-title>
            <v-list-item-title v-text="request.user.name"></v-list-item-title>
          </v-list-item-content>
        </v-list-item>
      </v-list-item-group>
    </v-list>

    <v-list dense>
      <v-subheader>ログイン者のoffers一覧</v-subheader>
      <v-list-item-group
        v-for="(offer, index) in formedMyOffers"
        :key="index"
        color="primary"
      >
        <v-list-item
          @click="
            createRoom(
              offer.id,
              offer.user.id,
              offer.start_time,
              offer.finish_time
            )
          "
        >
          <v-list-item-content>
            <v-list-item-title v-text="offer.formedOffer"></v-list-item-title>
            <v-list-item-title v-text="offer.user.name"></v-list-item-title>
          </v-list-item-content>
        </v-list-item>
      </v-list-item-group>
    </v-list>
  </container>
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
          user: obj.user,
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
          user: obj.user,
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
          // Room画面に移動しformedOfferの範囲で交渉してみよう！的なガイドをいれる
          // offerを消す
        })
        .catch((error) => {
          console.log(error)
        })
    },
  },
}
</script>
