<template>
  <v-card>
    <v-app-bar dense app color="white" flat>
      <v-menu bottom left>
        <template #activator="{ on, attrs }">
          <v-btn icon v-bind="attrs" v-on="on">
            <v-app-bar-nav-icon></v-app-bar-nav-icon>
          </v-btn>
        </template>

        <v-list v-if="!$store.state.info.info.myid" dense>
          <v-list-item v-for="(item, i) in unAuthItems" :key="i" link>
            <v-list-item-title @click="clickUnAuthMenu(i)">{{
              item.title
            }}</v-list-item-title>
          </v-list-item>
        </v-list>

        <v-list v-if="$store.state.info.info.myid" dense>
          <v-list-item v-for="(item, i) in authItems" :key="i" link>
            <v-list-item-title @click="clickAuthMenu(i)">{{
              item.title
            }}</v-list-item-title>
          </v-list-item>
        </v-list>
      </v-menu>

      <v-app-bar-title>NurseHop</v-app-bar-title>

      <v-spacer></v-spacer>
      <v-tooltip bottom>
        <template #activator="{ on, attrs }">
          <v-btn icon v-bind="attrs" v-on="on" @click="loginAsGuestUser">
            <v-icon>mdi-doctor</v-icon>
          </v-btn>
        </template>
        <span>ゲスト看護師 ログイン</span>
      </v-tooltip>
      <v-tooltip bottom>
        <template #activator="{ on, attrs }">
          <v-btn icon v-bind="attrs" v-on="on" @click="loginAsGuestHost">
            <v-icon>mdi-hospital-building</v-icon>
          </v-btn>
        </template>
        <span>ゲスト病院 ログイン</span>
      </v-tooltip>

      <template #extension>
        <v-tabs v-model="tabs" fixed-tabs>
          <v-tabs-slider></v-tabs-slider>

          <v-menu
            v-if="$store.state.info.info.myid"
            open-on-hover
            offset-x
            right
            transition="scale-transition"
          >
            <template #activator="{ on, attrs }">
              <v-tab
                class="primary--text"
                nuxt
                :to="myPageURL"
                v-bind="attrs"
                v-on="on"
              >
                <v-icon>mdi-home-outline</v-icon>
              </v-tab>
            </template>
            <v-list>
              <v-list-item v-for="(item, index) in homeItems" :key="index" link>
                <v-list-item-title @click="$router.push(item.url)">{{
                  item.title
                }}</v-list-item-title>
              </v-list-item>
            </v-list>
          </v-menu>

          <v-menu open-on-hover offset-x right transition="scale-transition">
            <template #activator="{ on, attrs }">
              <v-tab class="primary--text" nuxt to="/" v-bind="attrs" v-on="on">
                <v-icon>mdi-magnify</v-icon>
              </v-tab>
            </template>
            <v-list>
              <v-list-item v-for="(item, index) in topItems" :key="index" link>
                <v-list-item-title @click="$router.push(item.url)">{{
                  item.title
                }}</v-list-item-title>
              </v-list-item>
            </v-list>
          </v-menu>

          <v-menu open-on-hover offset-x left transition="scale-transition">
            <template #activator="{ on, attrs }">
              <v-tab
                class="primary--text"
                nuxt
                to="/agreements"
                v-bind="attrs"
                v-on="on"
              >
                <v-icon>mdi-text-box-check-outline</v-icon>
              </v-tab>
            </template>
            <v-list>
              <v-list-item
                v-for="(item, index) in agreementItems"
                :key="index"
                link
              >
                <v-list-item-title @click="$router.push(item.url)">{{
                  item.title
                }}</v-list-item-title>
              </v-list-item>
            </v-list>
          </v-menu>
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
      homeItems: [
        { title: 'Click Me', url: 'someting' },
        { title: 'Click Me', url: 'someting' },
        { title: 'Click Me', url: 'someting' },
        { title: 'Click Me 2', url: 'someting' },
      ],
      topItems: [
        { title: 'Click Me', url: 'someting' },
        { title: 'Click Me', url: 'someting' },
        { title: 'Click Me', url: 'someting' },
        { title: 'Click Me 2', url: 'someting' },
      ],
      agreementItems: [
        { title: 'Click Me', url: 'someting' },
        { title: 'Click Me', url: 'someting' },
        { title: 'Click Me', url: 'someting' },
        { title: 'Click Me 2', url: 'someting' },
      ],
    }
  },
  computed: {
    myPageURL() {
      return `/${this.$cookies.get('user')}/${this.$store.state.info.info.myid}`
    },
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

    clickAuthMenu(i) {
      switch (i) {
        case 0:
          this.$cookies.removeAll()
          this.$router.push('/')
          this.$store.dispatch('info/logout')
          this.$store.dispatch('snackbar/setMessage', 'Good Bye!')
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
              this.$store.dispatch('snackbar/setMessage', 'さよなら')
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
              this.$store.dispatch('snackbar/setMessage', 'ログインしました。')
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

    loginAsGuestHost() {
      this.$axios
        .post('/api/host/sign_in', {
          email: 'takayuki@guest.host',
          password: 'takayukipass',
        })
        .then((response) => {
          this.$store.dispatch('snackbar/setMessage', 'ログインしました。')
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