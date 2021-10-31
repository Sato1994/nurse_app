<template>
<container>
<v-list dense>
      <v-subheader>ログイン者のrequest一覧</v-subheader>
      <v-list-item-group
        v-for="request in formedMyRequests"
          :key="request.formedRequest"
          color="primary">
        <v-list-item>
          <v-list-item-content>
            <v-list-item-title v-text="request.formedRequest"></v-list-item-title>
            <v-list-item-title v-text="request.host.name"></v-list-item-title>
          </v-list-item-content>
        </v-list-item>
      </v-list-item-group>
    </v-list>

    <v-list dense>
      <v-subheader>ログイン者のoffers一覧</v-subheader>
      <v-list-item-group
        v-for="offer in formedMyOffers"
          :key="offer.formedOffer"
          color="primary"
          >
        <v-list-item @click="createRoom(offer.host.id, offer.formedOffer)">
          <v-list-item-content>
            <v-list-item-title v-text="offer.formedOffer"></v-list-item-title>
            <v-list-item-title v-text="offer.host.name"></v-list-item-title>
          </v-list-item-content>
        </v-list-item>
      </v-list-item-group>
    </v-list>
    </container>
</template>


<script>
export default {
  // data: () => ({
  //   myRequests: '',

  // }),
  // create() {
  //   this.myRequests = this.$store.getters['myInfo/getMyRequests']
  // },
  computed: {
    formedMyRequests() {
      const requests = this.$store.getters['myInfo/getMyRequests'].map(obj=> {
        const s = new Date(obj.start_time)
        const f = new Date(obj.finish_time)
        const newObject = {id: obj.id, user: obj.user, host: obj.host, formedRequest: `${s.getFullYear()}年${s.getMonth() +1}月${s.getDate()}日${s.getHours()}時${s.getMinutes()}分から${f.getFullYear()}年${f.getMonth() +1}月${f.getDate()}日${f.getHours()}時${f.getMinutes()}分`}
        return newObject
      })
      return requests
    },
    formedMyOffers() {
      const offers = this.$store.getters['myInfo/getMyOffers'].map(obj=> {
        const s = new Date(obj.start_time)
        const f = new Date(obj.finish_time)
        const newObject = {id: obj.id, user: obj.user, host: obj.host, formedOffer: `${s.getFullYear()}年${s.getMonth() +1}月${s.getDate()}日${s.getHours()}時${s.getMinutes()}分から${f.getFullYear()}年${f.getMonth() +1}月${f.getDate()}日${f.getHours()}時${f.getMinutes()}分`}
        return newObject
      })
      return offers
    },
  },
  methods: {
    createRoom(hostID,formedOffer) {
      this.$axios.post(`/api/rooms/host/${hostID}`,{},{ headers: this.$cookies.get('authInfo') })
      .then((response) => {
        console.log(response.data)
        // Room画面に移動しformedOfferの範囲で交渉してみよう！的なガイドをいれる
        // offerを消す
      })
      .catch((error) => {
        console.log(error)
      })
    }
  }
};

</script>
