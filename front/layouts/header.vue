<template>
  <v-card>
    <v-app-bar dense app color="white" flat>
      <v-menu bottom left>
        <template #activator="{ on, attrs }">
          <v-btn icon v-bind="attrs" v-on="on">
            <v-icon size="30">{{ authIcon }}</v-icon>
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
            <v-list-item-title @click="clickAuthMenu">{{
              item.title
            }}</v-list-item-title>
          </v-list-item>
        </v-list>
      </v-menu>

      <v-tooltip bottom>
        <template #activator="{ on, attrs }">
          <v-btn icon v-bind="attrs" v-on="on" @click="loginAsGuestUser">
            <v-icon size="30">mdi-doctor</v-icon>
          </v-btn>
        </template>
        <span>ゲスト看護師 ログイン</span>
      </v-tooltip>
      <v-tooltip bottom>
        <template #activator="{ on, attrs }">
          <v-btn icon v-bind="attrs" v-on="on" @click="loginAsGuestHost">
            <v-icon size="30">mdi-hospital-building</v-icon>
          </v-btn>
        </template>
        <span>ゲスト病院 ログイン</span>
      </v-tooltip>

      <div>
        <v-img width="45" src="/image/nurse_hop_logo.png"></v-img>
      </div>
      <div class="bellIcon">
        <Notice />
      </div>
      <template #extension>
        <v-tabs v-model="tabs" fixed-tabs>
          <v-tabs-slider></v-tabs-slider>

          <v-tab
            v-if="$store.state.info.info.myid"
            class="primary--text"
            nuxt
            :to="myPageURL"
          >
            <v-icon>mdi-home-outline</v-icon>
          </v-tab>

          <v-tab class="primary--text" nuxt to="/search">
            <v-icon>mdi-magnify</v-icon>
          </v-tab>

          <v-tab class="primary--text" nuxt to="/issues">
            <v-icon>mdi-text-box-check-outline</v-icon>
          </v-tab>

          <v-tab class="primary--text" nuxt to="/rooms">
            <v-icon>mdi-handshake-outline</v-icon>
          </v-tab>
        </v-tabs>
      </template>
      <SignUp
        :signUpDisplay="signUpDisplay"
        @close-sign-up-click="closeSignUp"
      />
      <SignIn
        :signInDisplay="signInDisplay"
        @close-sign-in-click="closeSignIn"
      />
      <SelectType
        :selectTypeDisplay="selectTypeDisplay"
        @close-select-type-click="closeSelectType"
        @select-click="actionSelectedType"
      />
    </v-app-bar>
  </v-card>
</template>

<script>
import { mapActions } from 'vuex'
import SignUp from '@/components/dialog/SignUp.vue'
import SignIn from '@/components/dialog/SignIn.vue'
import SelectType from '@/components/dialog/SelectType.vue'
import Notice from '@/components/props/Notice.vue'
export default {
  components: {
    SignUp,
    SignIn,
    SelectType,
    Notice,
  },

  data() {
    return {
      tabs: null,
      unAuthItems: [{ title: 'ログイン' }, { title: '新規登録' }],
      authItems: [{ title: 'ログアウト' }],
      selectTypeDisplay: false,
      signInDisplay: false,
      signUpDisplay: false,
      sign: null,
    }
  },
  computed: {
    myPageURL() {
      return `/${this.$cookies.get('user')}/${this.$store.state.info.info.myid}`
    },

    authIcon() {
      return this.$store.state.info.info.myid ? 'mdi-logout' : 'mdi-login'
    },
  },

  methods: {
    ...mapActions('info', ['loginAsGuestUser']),
    ...mapActions('info', ['loginAsGuestHost']),

    clickUnAuthMenu(i) {
      switch (i) {
        case 0:
          this.sign = 'in'
          this.selectTypeDisplay = true

          break
        case 1:
          this.sign = 'up'
          this.selectTypeDisplay = true
          break
      }
    },

    clickAuthMenu() {
      this.$router.push('/')
      this.$cookies.removeAll()
      this.$store.dispatch('info/resetAllStores')
      this.$store.dispatch('snackbar/setMessage', 'Good Bye!')
    },

    closeSelectType() {
      this.selectTypeDisplay = false
    },

    closeSignIn() {
      this.signInDisplay = false
    },

    closeSignUp() {
      this.signUpDisplay = false
    },

    actionSelectedType() {
      this.closeSelectType()
      if (this.sign === 'in') {
        this.signInDisplay = true
      } else if (this.sign === 'up') {
        this.signUpDisplay = true
      }
    },
  },
}
</script>


<style scoped>
.bellIcon {
  position: fixed;
  top: 13px;
  right: 33px;
}
</style>