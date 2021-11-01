<template>
  <v-app dark>
    <v-main>
        <v-app id="inspire">
          ★デバッグ用★ ★Userかhostか？{{ $cookies.get("user") }}★
          ★myInfo→{{ $store.state.myInfo.myInfo.name}}★
          ★cookies→{{ $cookies.get("authInfo") == null ? '入ってない': '入ってる' }}

          <v-app-bar app color="white" flat>
            <v-container class="py-0 fill-height">
              <v-menu
                v-model="menu"
                bottom
                right
                transition="scale-transition"
                origin="top left"
              >
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
                        <v-img
                          src="https://cdn.vuetifyjs.com/images/john.png"
                        ></v-img>
                      </v-list-item-avatar>
                      <v-list-item-content>
                        <v-list-item-title
                          >ログイン</v-list-item-title
                        >
                      </v-list-item-content>
                      <v-list-item-action>
                        <v-btn icon @click="menu = false">
                          <v-icon>mdi-close-circle</v-icon>
                        </v-btn>
                      </v-list-item-action>
                    </v-list-item>
                  </v-list>

                  <v-list>
                    <v-list-item @click="openUserModal">
                      <v-list-item-action>
                        <v-icon>mdi-briefcase</v-icon>
                      </v-list-item-action>
                      <v-list-item-title
                        >看護師として登録する</v-list-item-title
                      >
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
              <v-btn :to="mypageURL" nuxt text>
              マイページ
              </v-btn>
              <v-btn to="/" nuxt text>
              お相手一覧
              </v-btn>
              <v-btn to="/times" nuxt text>
              募集時間の登録
              </v-btn>
              <v-btn :to="negotiationsURL" nuxt text>
              リクエスト等
              </v-btn>
              <v-spacer></v-spacer>
              <v-responsive max-width="260">
                <v-text-field
                  dense
                  flat
                  hide-details
                  rounded
                  solo-inverted
                ></v-text-field>
              </v-responsive>
            </v-container>
          </v-app-bar>
          <v-main class="grey lighten-3">
            <v-container>
              <v-row>
                <v-col cols="2">
                  <v-sheet rounded="lg">
                    <v-list color="transparent" >
                      <v-list-item to="/rooms" nuxt text>
                        <v-list-item-content  >
                          <v-list-item-title>
                           メッセージ

                          </v-list-item-title>
                        </v-list-item-content>
                      </v-list-item>

                      <v-divider class="my-2"></v-divider>

                      <v-list-item link color="grey lighten-4">
                        <v-list-item-content>
                          <v-list-item-title> Refresh </v-list-item-title>
                        </v-list-item-content>
                      </v-list-item>
                    </v-list>
                  </v-sheet>
                </v-col>
                <v-col>
                  <v-sheet min-height="70vh" rounded="lg">
                    <v-container>
                      <modal name="user-modal" height="auto">
                        <SignUpAsUser />
                      </modal>

                      <modal name="host-modal" height="auto" :scrollable="true">
                        <SignUpAsHost />
                      </modal>

                      <modal name="sign-in-modal" height="auto">
                        <SignIn />
                      </modal>



                      <modal name="select-user-type-modal" height="auto">
                        <SelectUserType />
                      </modal>

                      <Nuxt />
                    </v-container>
                  </v-sheet>
                </v-col>
              </v-row>
            </v-container>
          </v-main>
        </v-app>
    </v-main>
  </v-app>
</template>

<script>
import SignUpAsUser from "@/components/pages/user/SignUp.vue";
import SignUpAsHost from "@/components/pages/host/SignUp.vue";
import SignIn from "@/components/pages/modal/SignIn.vue"
import SelectUserType from "@/components/pages/modal/SelectUserType.vue"


export default {
  components: {
    SignUpAsUser,
    SignUpAsHost,
    SignIn,
    SelectUserType
  },

  data: () => ({
    menu: false,
  }),
  computed: {
    mypageURL() {
      return `/${this.$cookies.get('user')}/${this.$store.state.myInfo.myInfo.myid}`
    },
    negotiationsURL() {
      return `/${this.$cookies.get('user')}/${this.$store.state.myInfo.myInfo.myid}/negotiations`
    },
    myRoomsURL() {
      return `/room`
    }
  },

  // リロードの旅に認証tokenを検証しエラーなら再ログインが必要にする
  created() {
    this.$axios
      .get(
        `http://localhost:3000/api/${this.$cookies.get("user")}/validate_token`,
        {
          headers: this.$cookies.get("authInfo"),
        }
      )
      .then((response) => {
        this.$store.dispatch("myInfo/saveMyInfo", response.data.data);
        this.$axios.get(`http://localhost:3000/api/${this.$cookies.get("user")}s/${response.data.data.myid}` ,{headers: this.$cookies.get('authInfo')})
          .then((response) => {
            console.log('/users/myidのやつ', response.data)
            this.$store.dispatch("myInfo/saveMySkills", response.data.target_skills)
            this.$store.dispatch("myInfo/saveMyTimes", response.data.target_times)
            this.$store.dispatch("myInfo/saveMyRequests", response.data.requests)
            this.$store.dispatch("myInfo/saveMyOffers", response.data.offers)
            this.$store.dispatch("myInfo/saveMyAgreements", response.data.agreements)
            this.$store.dispatch("myInfo/saveMyRooms", response.data.rooms)

        });
      })
      .catch((error) => {
        console.log("defaultでえらー", error);
        this.$cookies.removeAll();
      });
  },
  methods: {
    logout() {
      this.$cookies.removeAll();
      this.$router.push("/");
      this.$store.dispatch("myInfo/logout");
    },
    deactivate() {
      this.$axios.delete(`/api/${this.$cookies.get('user')}`, {headers: this.$cookies.get('authInfo')})
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
      this.$modal.show("user-modal");
    },
    openHostModal() {
      this.$modal.show("host-modal");
    },
    openSelectUserTypeModal() {
      this.$modal.show("select-user-type-modal")
    },
  },
};
</script>
