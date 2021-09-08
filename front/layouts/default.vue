<template>
  <v-app dark>
    <v-main>
      <template>
        <v-app id="inspire">
        <v-app-bar
          app
          color="white"
          flat
        >
          <v-container class="py-0 fill-height">
            <v-menu
              v-model="menu"
              bottom
              right
              transition="scale-transition"
              origin="top left"
            >
              <template v-slot:activator="{ on }">
                <v-avatar
                    v-on="on"
                    class="mr-10"
                    color="grey darken-1"
                    size="40"
                ></v-avatar>
              </template>
              <v-card width="300">
                <v-list dark>
                  <v-list-item @click="openAuthModal">
                    <v-list-item-avatar>
                      <v-img src="https://cdn.vuetifyjs.com/images/john.png"></v-img>
                    </v-list-item-avatar>
                    <v-list-item-content>
                      <v-list-item-title>ログイン</v-list-item-title>
                    </v-list-item-content>
                    <v-list-item-action>
                      <v-btn
                        icon
                        @click="menu = false"
                      >
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
                    <v-list-item-title>看護師として登録する</v-list-item-title>
                  </v-list-item>
                </v-list>
              </v-card>
            </v-menu>
            <v-btn
              v-for="link in links"
              :key="link"
              text
            >
              {{ link }}
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
                    <v-list color="transparent">
                      <v-list-item
                        v-for="n in 5"
                        :key="n"
                        link
                      >
                        <v-list-item-content>
                          <v-list-item-title>
                            List Item {{ n }}
                          </v-list-item-title>
                        </v-list-item-content>
                      </v-list-item>

                      <v-divider class="my-2"></v-divider>

                      <v-list-item
                        link
                        color="grey lighten-4"
                      >
                        <v-list-item-content>
                          <v-list-item-title>
                            Refresh
                          </v-list-item-title>
                        </v-list-item-content>
                      </v-list-item>
                    </v-list>
                  </v-sheet>
                </v-col>
                <v-col>
                  <v-sheet
                    min-height="70vh"
                    rounded="lg"
                  >
                    <v-container>
                    <modal name="user-modal" height="auto">
                      <SignUp />
                    </modal>

                    <modal name="auth-modal" height="auto">
                      <SignIn />
                    </modal>

                      <Nuxt />
                    </v-container>
                  </v-sheet>
                </v-col>
              </v-row>
            </v-container>
          </v-main>
        </v-app>
      </template>
    </v-main>
  </v-app>
</template>

<script>
import SignUp from '@/components/pages/user/SignUp.vue'
import SignIn from '@/components/pages/user/SignIn.vue'
  export default {
    components: {
      SignUp,
      SignIn,
    },

    data: () => ({
      links: [
        'Dashboard',
        'Messages',
        'Profile',
        'Updates',
      ], 
      menu: false,
    }),
    
    methods: {
      openUserModal() {
        this.$modal.show('user-modal')
      },
      openAuthModal() {
        this.$modal.show('auth-modal')
      }
    }


  }
</script>