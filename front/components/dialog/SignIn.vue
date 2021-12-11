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
                  v-model="myInfo.email"
                  label="メールアドレス"
                  required
                ></v-text-field>
              </v-col>
              <v-col cols="12">
                <v-text-field
                  v-model="myInfo.password"
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
    myInfo: {},
  }),

  methods: {
    signIn() {
      this.$axios
        // ログイン
        .post(`/api/${this.$cookies.get('user')}/sign_in`, this.myInfo)
        .then((response) => {
          this.isDisplay = false
          // マイページへ遷移
          this.$router.push(
            `/${this.$cookies.get('user')}/${response.data.data.myid}`
          )
          const authInfo = {
            'access-token': response.headers['access-token'],
            client: response.headers.client,
            uid: response.headers.uid,
          }
          // authInfoセット
          this.$cookies.set('authInfo', authInfo)

          // myInfoをstoreにセット
          this.$store.dispatch('myInfo/saveMyInfo', response.data.data)
          // 自分の付加情報をstoreにセット
          this.$axios
            .get(
              `/api/${this.$cookies.get('user')}s/${response.data.data.myid}`,
              { headers: this.$cookies.get('authInfo') }
            )
            .then((response) => {
              this.$store.dispatch(
                'skills/saveSkills',
                response.data.target_skills
              )
              this.$store.dispatch(
                'times/saveTimes',
                response.data.target_times
              )
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
            })
        })
        .catch((error) => {
          console.log('認証失敗', error)
        })
    },
  },
}
</script>