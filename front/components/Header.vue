<template>
  <v-app-bar app color="white" flat>
    <v-menu offset-x>
      <template #activator="{ on, attrs }">
        <div class="my-2">
          <v-btn small color="warning" fab v-bind="attrs" v-on="on">
            <v-icon>mdi-account-circle</v-icon>
          </v-btn>
        </div>
      </template>
      <v-list v-if="!$store.state.info.info.myid" dense>
        <v-list-item v-for="(item, i) in unAuthItems" :key="i">
          <v-list-item-title @click="clickUnAuthMenu(i)">{{
            item.title
          }}</v-list-item-title>
        </v-list-item>
      </v-list>

      <v-list v-if="$store.state.info.info.myid" dense>
        <v-list-item v-for="(item, i) in authItems" :key="i">
          <v-list-item-title @click="clickAuthMenu(i)">{{
            item.title
          }}</v-list-item-title>
        </v-list-item>
      </v-list>
    </v-menu>

    <v-row align="center" justify="space-around">
      <v-btn
        v-for="(item, i) in linkItems"
        :key="i"
        text
        @click="clickLinkMenu(i)"
      >
        {{ item.title }}
      </v-btn>
    </v-row>

    <v-spacer></v-spacer>
    <!-- ダイアログ -->
    <SignUp ref="signUp" />
    <SignIn ref="signIn" />
    <SelectUserType
      ref="selectUserType"
      @sign-in-button-click="$refs.signIn.isDisplay = true"
      @sign-up-button-click="$refs.signUp.isDisplay = true"
    />
    <!-- -->
  </v-app-bar>
</template>

<script>
import SignUp from '@/components/dialog/SignUp.vue'
import SignIn from '@/components/dialog/SignIn.vue'
import SelectUserType from '@/components/dialog/SelectUserType.vue'
export default {
  components: {
    SignUp,
    SignIn,
    SelectUserType,
  },

  data: () => ({
    linkItems: [
      { title: 'お相手検索' },
      { title: 'リクエスト一覧' },
      { title: 'メッセージ' },
      { title: 'user' },
      { title: 'host' },
    ],

    unAuthItems: [{ title: 'ログイン' }, { title: '新規登録' }],

    authItems: [
      { title: 'マイページ' },
      { title: 'ログアウト' },
      { title: 'アカウント削除' },
    ],
  }),

  methods: {
    clickLinkMenu(i) {
      switch (i) {
        case 0:
          this.$router.push('/')
          break
        case 1:
          this.$router.push(
            `/${this.$cookies.get('user')}/${
              this.$store.state.info.info.myid
            }/agreements`
          )
          break
        case 2:
          this.$router.push('/rooms')
          break
        case 3:
          this.$axios
            .post('/api/user/sign_in', {
              email: 'yamada@guest.user',
              password: 'yamadapass',
            })
            .then((response) => {
              this.$cookies.set('user', 'user')
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
                  `/api/${this.$cookies.get('user')}s/${
                    response.data.data.myid
                  }`,
                  { headers: this.$cookies.get('authInfo') }
                )
                .then((response) => {
                  this.$store.dispatch('info/saveInfo', response.data.info)
                  this.$store.dispatch(
                    'skills/saveSkills',
                    response.data.skills
                  )
                  this.$store.dispatch('times/saveTimes', response.data.times)
                  this.$store.dispatch(
                    'requests/saveRequests',
                    response.data.requests
                  )
                  this.$store.dispatch(
                    'agreements/saveAgreements',
                    response.data.agreements
                  )
                  this.$store.dispatch(
                    'offers/saveOffers',
                    response.data.offers
                  )
                  this.$store.dispatch('rooms/saveRooms', response.data.rooms)
                  console.log('サインインでdispatchは成功')
                  this.$router.push(
                    `/${this.$cookies.get('user')}/${response.data.info.myid}`
                  )
                })
                .catch(() => {
                  this.$cookies.removeAll()
                  console.log('サインイン失敗')
                })
            })
          break
        case 4:
          this.$axios
            .post('/api/host/sign_in', {
              email: 'takayuki@guest.host',
              password: 'takayukipass',
            })
            .then((response) => {
              this.$cookies.set('user', 'host')
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
                  `/api/${this.$cookies.get('user')}s/${
                    response.data.data.myid
                  }`,
                  { headers: this.$cookies.get('authInfo') }
                )
                .then((response) => {
                  this.$store.dispatch('info/saveInfo', response.data.info)
                  this.$store.dispatch(
                    'skills/saveSkills',
                    response.data.skills
                  )
                  this.$store.dispatch('times/saveTimes', response.data.times)
                  this.$store.dispatch(
                    'requests/saveRequests',
                    response.data.requests
                  )
                  this.$store.dispatch(
                    'agreements/saveAgreements',
                    response.data.agreements
                  )
                  this.$store.dispatch(
                    'offers/saveOffers',
                    response.data.offers
                  )
                  this.$store.dispatch('rooms/saveRooms', response.data.rooms)
                  console.log('サインインでdispatchは成功')
                  this.$router.push(
                    `/${this.$cookies.get('user')}/${response.data.info.myid}`
                  )
                })
                .catch(() => {
                  this.$cookies.removeAll()
                  console.log('サインイン失敗')
                })
            })
      }
    },

    clickUnAuthMenu(i) {
      switch (i) {
        case 0:
          this.$refs.selectUserType.isSignIn = true
          this.$refs.selectUserType.isDisplay = true

          break
        case 1:
          this.$refs.selectUserType.isSignIn = false
          this.$refs.selectUserType.isDisplay = true
          break
      }
    },

    clickAuthMenu(i) {
      switch (i) {
        case 0:
          this.$router.push(
            `/${this.$cookies.get('user')}/${this.$store.state.info.info.myid}`
          )
          break
        case 1:
          this.$cookies.removeAll()
          this.$router.push('/')
          this.$store.dispatch('info/logout')
          break
        case 2:
          this.$axios
            .delete(`/api/${this.$cookies.get('user')}`, {
              headers: this.$cookies.get('authInfo'),
            })
            .then(() => {
              this.$cookies.removeAll()
              this.$router.push('/')
              this.$store.dispatch('info/logout')
            })
          break
      }
    },
  },
}
</script>