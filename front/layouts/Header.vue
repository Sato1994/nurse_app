<template>
  <v-app-bar app color="white" flat>
    <v-container class="py-0 fill-height">
      <v-menu bottom right transition="scale-transition" origin="top left">
        <template #activator="{ on }">
          <v-avatar
            class="mr-10"
            color="grey darken-1"
            size="40"
            v-on="on"
          ></v-avatar>
        </template>
        <v-card width="300">
          <v-list dark>
            <v-list-item @click="openSelectUserTypeModal">
              <v-list-item-avatar>
                <v-img src="https://cdn.vuetifyjs.com/images/john.png"></v-img>
              </v-list-item-avatar>
              <v-list-item-content>
                <v-list-item-title>ログイン</v-list-item-title>
              </v-list-item-content>
            </v-list-item>
          </v-list>

          <v-list>
            <v-list-item @click="openUserModal">
              <v-list-item-action>
                <v-icon>mdi-briefcase</v-icon>
              </v-list-item-action>
              <v-list-item-title>看護師として登録する</v-list-item-title>
            </v-list-item>
          </v-list>

          <v-list>
            <v-list-item @click="openHostModal">
              <v-list-item-action>
                <v-icon>mdi-briefcase</v-icon>
              </v-list-item-action>
              <v-list-item-title>病院として登録する</v-list-item-title>
            </v-list-item>
          </v-list>

          <v-list>
            <v-list-item @click="logout">
              <v-list-item-action>
                <v-icon>mdi-briefcase</v-icon>
              </v-list-item-action>
              <v-list-item-title>ログアウト</v-list-item-title>
            </v-list-item>
          </v-list>

          <v-list>
            <v-list-item @click="deactivate">
              <v-list-item-action>
                <v-icon>mdi-briefcase</v-icon>
              </v-list-item-action>
              <v-list-item-title>アカウント削除</v-list-item-title>
            </v-list-item>
          </v-list>
        </v-card>
      </v-menu>
      <v-btn :to="mypageURL" nuxt text> マイページ </v-btn>
      <v-btn to="/" nuxt text> お相手一覧 </v-btn>
      <v-btn to="/times" nuxt text> 募集時間の登録 </v-btn>
      <v-btn :to="negotiationsURL" nuxt text> リクエスト等 </v-btn>
      <v-spacer></v-spacer>
    </v-container>
  </v-app-bar>
</template>

<script>
export default {
  computed: {
    mypageURL() {
      return `/${this.$cookies.get('user')}/${
        this.$store.state.myInfo.myInfo.myid
      }`
    },

    negotiationsURL() {
      return `/${this.$cookies.get('user')}/${
        this.$store.state.myInfo.myInfo.myid
      }/negotiations`
    },
  },

  methods: {
    logout() {
      this.$cookies.removeAll()
      this.$router.push('/')
      this.$store.dispatch('myInfo/logout')
    },

    deactivate() {
      this.$axios
        .delete(`/api/${this.$cookies.get('user')}`, {
          headers: this.$cookies.get('authInfo'),
        })
        .then((response) => {
          this.$cookies.removeAll()
          this.$router.push('/')
          this.$store.dispatch('myInfo/logout')
          console.log('deactivate成功', response)
        })
        .catch((error) => {
          console.log(error)
        })
    },

    openUserModal() {
      this.$modal.show('user-modal')
    },

    openHostModal() {
      this.$modal.show('host-modal')
    },

    openSelectUserTypeModal() {
      this.$modal.show('select-user-type-modal')
    },
  },
}
</script>