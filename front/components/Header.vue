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

      <v-spacer> </v-spacer>
      <Notice />
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
              <v-tab
                class="primary--text"
                nuxt
                to="/search"
                v-bind="attrs"
                v-on="on"
              >
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
                to="/issues"
                v-bind="attrs"
                v-on="on"
              >
                <v-icon>mdi-text-box-check-outline</v-icon>
              </v-tab>
            </template>
            <v-list>
              <v-list-item
                v-for="(item, index) in issuesItems"
                :key="index"
                link
              >
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
                to="/rooms"
                v-bind="attrs"
                v-on="on"
              >
                <v-icon>mdi-email-outline</v-icon>
              </v-tab>
            </template>
            <v-list>
              <v-list-item
                v-for="(item, index) in roomsItems"
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
      <SignUp />
      <SignIn />
      <SelectUserType />
      <Edit />
    </v-app-bar>
  </v-card>
</template>

<script>
import { mapActions, mapMutations } from 'vuex'
import SignUp from '@/components/dialog/SignUp.vue'
import SignIn from '@/components/dialog/SignIn.vue'
import SelectUserType from '@/components/dialog/SelectUserType.vue'
import Notice from '@/components/dialog/Notice.vue'
import Edit from '@/components/dialog/Edit.vue'
export default {
  components: {
    SignUp,
    SignIn,
    SelectUserType,
    Notice,
    Edit,
  },

  data() {
    return {
      tabs: null,
      unAuthItems: [{ title: 'ログイン' }, { title: '新規登録' }],
      authItems: [{ title: 'アカウント設定' }, { title: 'ログアウト' }],
      homeItems: [
        { title: 'Click Me', url: 'someting' },
        { title: 'Click Me', url: 'someting' },
        { title: 'Click Me', url: 'someting' },
        { title: 'Click Me 2', url: 'someting' },
      ],
      topItems: [
        { title: '距離順', url: '/search/distance' },
        { title: '評価順', url: '/search/rate' },
      ],
      issuesItems: [
        { title: 'すべて', url: '/issues' },
        { title: '募集時間', url: '/issues/times' },
        { title: '届いたリクエスト', url: '/issues/offers' },
        { title: '送ったリクエスト', url: '/issues/requests' },
      ],
      roomsItems: [
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

  async mounted() {
    if (this.$store.state.info.info.myid) {
      await this.$axios
        .get(`/api/${this.$cookies.get('user')}_notices`, {
          headers: this.$cookies.get('authInfo'),
        })
        .then((response) => {
          this.$store.commit('notices/saveFormedNotices', response.data)
        })
    }
  },

  methods: {
    ...mapActions('info', ['loginAsGuestUser']),
    ...mapActions('info', ['loginAsGuestHost']),
    ...mapMutations('dialog/edit', ['displayEdit']),

    clickUnAuthMenu(i) {
      switch (i) {
        case 0:
          this.$cookies.set('sign', 'in')
          this.$store.commit('dialog/selectUserType/displaySelectUserType')

          break
        case 1:
          this.$cookies.set('sign', 'up')
          this.$store.commit('dialog/selectUserType/displaySelectUserType')
          break
      }
    },

    clickAuthMenu(i) {
      switch (i) {
        case 0:
          this.$router.push(
            `/${this.$cookies.get('user')}/${this.$store.state.info.info.myid}`
          )
          this.displayEdit()
          break

        case 1:
          this.$cookies.removeAll()
          this.$router.push('/')
          this.$store.dispatch('info/logout')
          this.$store.dispatch('snackbar/setMessage', 'Good Bye!')
          break
      }
    },
  },
}
</script>