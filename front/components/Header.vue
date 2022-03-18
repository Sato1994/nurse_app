<template>
  <v-card>
    <v-app-bar dense app color="white" flat>
      <v-menu bottom left>
        <template v-slot:activator="{ on, attrs }">
          <v-btn icon v-bind="attrs" v-on="on">
            <v-app-bar-nav-icon></v-app-bar-nav-icon>
          </v-btn>
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

      <v-app-bar-title>NurseHop</v-app-bar-title>

      <v-spacer></v-spacer>

      <v-btn v-if="$store.state.info.info.myid" @click="toMyPage" icon>
        <v-icon>mdi-home</v-icon>
      </v-btn>

      <v-btn @click="loginAsGuestUser" icon>
        <v-icon>mdi-doctor</v-icon>
      </v-btn>

      <v-btn @click="loginAsGuestHost" icon>
        <v-icon>mdi-hospital-building</v-icon>
      </v-btn>

      <template #extension>
        <v-tabs v-model="tabs" fixed-tabs>
          <v-tabs-slider></v-tabs-slider>
          <v-tab nuxt to="/" class="primary--text">
            <v-icon>mdi-magnify</v-icon>
          </v-tab>

          <v-tab nuxt to="/agreements" class="primary--text">
            <v-icon>mdi-text-box-check-outline</v-icon>
          </v-tab>

          <v-tab nuxt to="/rooms" class="primary--text">
            <v-icon>mdi-email-outline</v-icon>
          </v-tab>
        </v-tabs>
      </template>
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
  </v-card>
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

  data() {
    return {
      tabs: null,
      unAuthItems: [{ title: 'ログイン' }, { title: '新規登録' }],
      authItems: [{ title: 'ログアウト' }, { title: 'アカウント削除' }],
    }
  },

  methods: {
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

    toMyPage() {
      this.$router.push(
        `/${this.$cookies.get('user')}/${this.$store.state.info.info.myid}`
      )
    },

    clickAuthMenu(i) {
      switch (i) {
        case 0:
          this.$cookies.removeAll()
          this.$router.push('/')
          this.$store.dispatch('info/logout')
          break

        case 1:
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

    loginAsGuestUser() {
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
    },

    loginAsGuestHost() {
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
    },
  },
}
</script>