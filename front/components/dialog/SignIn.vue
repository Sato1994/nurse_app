<template>
  <v-row justify="center">
    <v-dialog v-model="isDisplay" persistent max-width="600px">
      <v-card>
        <v-card-title>
          <span class="text-h5">ログイン</span>
        </v-card-title>
        <v-card-text>
          <v-container>
            <v-row>
              <v-col cols="12">
                <v-text-field
                  v-model="info.email"
                  label="メールアドレス"
                  required
                ></v-text-field>
              </v-col>
              <v-col cols="12">
                <v-text-field
                  v-model="info.password"
                  label="パスワード"
                  required
                ></v-text-field>
              </v-col>
            </v-row>
          </v-container>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="warning darken-1" text @click="isDisplay = false">
            閉じる
          </v-btn>
          <v-btn color="warning darken-1" text @click="signIn">
            ログイン
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-row>
</template>

<script>
export default {
  data: () => ({
    isDisplay: false,
    info: {},
  }),

  methods: {
    signIn() {
      // ログイン
      this.$axios
        .post(`/api/${this.$cookies.get('user')}/sign_in`, this.info)
        .then((response) => {
          this.isDisplay = false
          this.$cookies.set('myid', response.data.data.myid)
          const authInfo = {
            'access-token': response.headers['access-token'],
            client: response.headers.client,
            uid: response.headers.uid,
          }
          this.$cookies.set('authInfo', authInfo)
          // ログイン者情報の取得
          this.$axios
            .get(
              `/api/${this.$cookies.get('user')}s/${response.data.data.myid}`,
              { headers: this.$cookies.get('authInfo') }
            )
            .then((response) => {
              this.$store.dispatch('info/saveInfo', response.data.info)
              this.$store.dispatch('skills/saveSkills', response.data.skills)
              this.$store.dispatch('times/saveTimes', response.data.times)
              this.$store.dispatch(
                'requests/saveRequests',
                response.data.requests
              )
              this.$store.dispatch(
                'agreements/saveAgreements',
                response.data.agreements
              )
              this.$store.dispatch('offers/saveOffers', response.data.offers)
              this.$store.dispatch('rooms/saveRooms', response.data.rooms)
              this.$router.push(
                `/${this.$cookies.get('user')}/${response.data.info.myid}`
              )
            })
            .catch(() => {
              this.$cookies.removeAll()
            })
        })
    },
  },
}
</script>