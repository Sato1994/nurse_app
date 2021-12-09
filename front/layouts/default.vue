<template>
  <v-app id="inspire">
    <Header />
    <v-main class="grey lighten-3">
      <v-container>
        <v-row>
          <SideMenu />
          <v-col>
            <v-sheet min-height="70vh" rounded="lg">
              <Nuxt />
            </v-sheet>
          </v-col>
        </v-row>
      </v-container>
    </v-main>
  </v-app>
</template>

<script>
import Header from '@/components/Header.vue'
import SideMenu from '@/components/SideMenu.vue'
export default {
  components: {
    Header,
    SideMenu,
  },

  created() {
    // cookieにログインの痕跡があれば有効かチェック
    if (this.$cookies.get('user') && this.$cookies.get('authInfo')) {
      this.$axios
        .get(
          `http://localhost:3000/api/${this.$cookies.get(
            'user'
          )}/validate_token`,
          {
            headers: this.$cookies.get('authInfo'),
          }
        )
        .then((response) => {
          // マイページへ遷移
          this.$router.push(
            `/${this.$cookies.get('user')}/${response.data.data.myid}`
          )
          // myInfoをstoreにセット
          this.$store.dispatch('myInfo/saveMyInfo', response.data.data)
          // 自分の付加情報をstoreにセット
          this.$axios
            .get(
              `http://localhost:3000/api/${this.$cookies.get('user')}s/${
                response.data.data.myid
              }`,
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
        .catch(() => {
          this.$cookies.removeAll()
        })
    }
  },
}
</script>
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 <!--<template>
  <v-app dark>
    <v-main class="grey lighten-3">
      <modal name="user-modal" height="auto" :scrollable="true">
        <SignUpAsUser />
      </modal>
      <modal name="host-modal" height="auto" :scrollable="true">
        <SignUpAsHost />
      </modal>
      <modal name="sign-in-modal" height="auto" :scrollable="true">
        <SignIn />
      </modal>
      <modal name="select-user-type-modal" height="auto" :scrollable="true">
        <SelectUserType />
      </modal>
      <Header />
      <v-container>
        <v-row>
          <SideMenu />
          <v-col>
            <v-sheet min-height="70vh" rounded="lg">
              <v-container>
                <Nuxt />
              </v-container>
            </v-sheet>
          </v-col>
        </v-row>
      </v-container>
    </v-main>
  </v-app>
</template>

<script> 
import Header from '@/layouts/Header.vue'
import SideMenu from '@/layouts/SideMenu.vue'
import SignUpAsUser from '@/components/pages/user/SignUp.vue'
import SignUpAsHost from '@/components/pages/host/SignUp.vue'
import SignIn from '@/components/pages/modal/SignIn.vue'
import SelectUserType from '@/components/pages/modal/SelectUserType.vue'

export default {
  components: {
    Header,
    SideMenu,
    SignUpAsUser,
    SignUpAsHost,
    SignIn,
    SelectUserType,
  },

  data: () => ({}),

  // リロードの旅に認証tokenを検証しエラーなら再ログインが必要にする
  created() {
    this.$axios
      .get(
        `http://localhost:3000/api/${this.$cookies.get('user')}/validate_token`,
        {
          headers: this.$cookies.get('authInfo'),
        }
      )
      .then((response) => {
        this.$store.dispatch('myInfo/saveMyInfo', response.data.data)
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
            this.$store.dispatch('times/saveTimes', response.data.target_times)
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
        console.log('defaultでえらー', error)
        this.$cookies.removeAll()
      })
  },
}
</script>
-->