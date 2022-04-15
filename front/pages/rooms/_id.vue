<template>
  <v-container>
    <v-card class="mx-auto">
      <v-img
        height="250"
        src="https://cdn.vuetifyjs.com/images/cards/cooking.png"
      ></v-img>

      <v-container fluid>
        <v-textarea
          v-model="inputComment"
          append-icon="mdi-send-outline"
          filled
          rows="4"
          label="勤務お疲れさまでした。この病院の評価を投稿しましょう！"
          auto-grow
          :counter="300"
          @click:append="createRate"
        ></v-textarea>
        <v-row align="center" class="mx-0">
          <v-rating
            v-model="inputStar"
            color="amber"
            dense
            size="30"
          ></v-rating>
        </v-row>
      </v-container>
      <Message />
    </v-card>
  </v-container>
</template>

<script>
import Message from '@/components/Message.vue'
export default {
  components: {
    Message,
  },

  data: () => ({
    inputStar: 0,
    inputComment: '',
  }),

  async fetch({ store, route }) {
    await store.dispatch('room/getRoom', { roomId: route.params.id })
  },

  computed: {
    agreement: {
      get() {
        return Object.assign({}, this.$store.getters['agreement/agreement'])
      },
    },
  },

  methods: {
    createRate() {
      this.$axios.post(
        '/api/rates',
        {
          agreement_id: this.agreement.id,
          comment: this.inputComment,
        },
        {
          headers: this.$cookies.get('authInfo'),
        }
      )
    },
  },
}
</script>