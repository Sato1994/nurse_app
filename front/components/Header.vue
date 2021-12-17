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
      <v-list v-if="!$store.state.myInfo.myInfo.myid" dense>
        <v-list-item v-for="(item, i) in unAuthItems" :key="i">
          <v-list-item-title @click="clickUnAuthMenu(i)">{{
            item.title
          }}</v-list-item-title>
        </v-list-item>
      </v-list>

      <v-list v-if="$store.state.myInfo.myInfo.myid" dense>
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
              this.$store.state.myInfo.myInfo.myid
            }/negotiations`
          )
          break
        case 2:
          this.$router.push('/rooms')
          break
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
            `/${this.$cookies.get('user')}/${
              this.$store.state.myInfo.myInfo.myid
            }`
          )
          break
        case 1:
          this.$cookies.removeAll()
          this.$router.push('/')
          this.$store.dispatch('myInfo/logout')
          break
        case 2:
          this.$axios
            .delete(`/api/${this.$cookies.get('user')}`, {
              headers: this.$cookies.get('authInfo'),
            })
            .then(() => {
              this.$cookies.removeAll()
              this.$router.push('/')
              this.$store.dispatch('myInfo/logout')
            })
          break
      }
    },
  },
}
</script>