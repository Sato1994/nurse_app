<template>
  <v-row justify="center">
    <v-dialog v-model="isDisplay" persistent max-width="600px">
      <v-card>
        <v-card-title>
          <span class="text-h5">新規登録</span>
        </v-card-title>
        <v-card-text>
          <v-container>
            <v-row>
              <v-col cols="12" sm="6" md="6">
                <v-text-field
                  v-model="myInfo.name"
                  :counter="10"
                  label="名前（フルネーム）"
                  required
                ></v-text-field>
              </v-col>
              <v-col cols="12" sm="6" md="6">
                <v-text-field
                  v-model="myInfo.myid"
                  label="サイト内ID"
                  required
                ></v-text-field>
              </v-col>
              <v-col v-if="$cookies.get('user') === 'host'" cols="12">
                <v-text-field
                  v-model="myInfo.address"
                  label="住所"
                  required
                ></v-text-field>
              </v-col>
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
              <v-col cols="12">
                <v-text-field
                  v-model="myInfo.password_confirmation"
                  label="パスワード確認用"
                  required
                ></v-text-field>
              </v-col>
            </v-row>
          </v-container>
          <small>全て入力必須です</small>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="warning darken-1" text @click="isDisplay = false">
            閉じる
          </v-btn>
          <v-btn color="warning darken-1" text @click="signUp"> 登録 </v-btn>
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
    signUp() {
      this.$axios
        .post(`/api/${this.$cookies.get('user')}`, this.myInfo)
        .then((response) => {
          this.isDisplay = false
          this.$router.push(
            `/${this.$cookies.get('user')}/${response.data.data.myid}`
          )
          // this.$store.dispatch('myInfo/saveMyInfo', response.data.data)
          const authInfo = {
            'access-token': response.headers['access-token'],
            client: response.headers.client,
            uid: response.headers.uid,
          }
          this.$cookies.set('authInfo', authInfo)

          this.$axios
            .get(
              `http://localhost:3000/api/${this.$cookies.get('user')}s/${
                response.data.data.myid
              }`,
              { headers: this.$cookies.get('authInfo') }
            )
            .then((response) => {
              console.log('/users/myidのやつ', response.data)
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
              this.$store.dispatch('offers/saveOffers', response.data.offers)
              this.$store.dispatch(
                'agreements/saveAgreements',
                response.data.agreements
              )
              this.$store.dispatch('rooms/saveRooms', response.data.rooms)

              this.$store.dispatch(
                'agreements/saveAgreements',
                response.data.agreements
              )
            })
        })
        .catch((error) => {
          console.log('登録失敗', error)
        })
    },
  },
}
</script>