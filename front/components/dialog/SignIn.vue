<template>
  <v-row justify="center">
    <v-dialog
      v-model="$store.state.dialog.signIn.signInIsDisplay"
      persistent
      max-width="600px"
    >
      <v-card>
        <ValidationObserver v-slot="{ invalid }">
          <v-card-title>
            <span class="text-h5">ログイン</span>
          </v-card-title>
          <v-card-text>
            <v-container>
              <v-row>
                <v-col cols="12">
                  <ValidationProvider name="メールアドレス" rules="required">
                    <v-text-field
                      v-model="info.email"
                      label="メールアドレス"
                      required
                    ></v-text-field>
                  </ValidationProvider>
                </v-col>
                <v-col cols="12">
                  <ValidationProvider name="パスワード" rules="required">
                    <v-text-field
                      v-model="info.password"
                      label="パスワード"
                      required
                    ></v-text-field>
                  </ValidationProvider>
                </v-col>
              </v-row>
            </v-container>
          </v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn color="warning darken-1" text @click="hideSignIn">
              閉じる
            </v-btn>
            <v-btn
              color="warning darken-1"
              text
              :disabled="invalid"
              @click="signIn(info)"
            >
              ログイン
            </v-btn>
          </v-card-actions>
        </ValidationObserver>
      </v-card>
    </v-dialog>
  </v-row>
</template>

<script>
import { mapActions } from 'vuex'
export default {
  data: () => ({
    info: {},
  }),

  methods: {
    ...mapActions('dialog/signIn', ['signIn']),

    hideSignIn() {
      this.$store.commit('dialog/signIn/hideSignIn')
      this.$cookies.removeAll()
      this.info = {}
    },
  },
}
</script>