<template>
  <v-card>
    <v-app-bar dense app color="white" flat>
      <v-app-bar-nav-icon @click.stop="openSideMenu"></v-app-bar-nav-icon>

      <v-app-bar-title>NurseHop</v-app-bar-title>

      <v-spacer></v-spacer>

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
    }
  },

  methods: {
    openSideMenu() {
      this.$emit('side-menu-click')
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