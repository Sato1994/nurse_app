<template>
  <v-row justify="center">
    <v-dialog :value="signInDisplay" max-width="600px" @click:outside="close">
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
            <v-btn color="warning darken-1" text @click="close"> 閉じる </v-btn>
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
export default {
  props: {
    signInDisplay: {
      type: Boolean,
      default: false,
    },
  },

  data: () => ({
    info: {},
  }),

  methods: {
    signIn(payload) {
      this.$emit('close-sign-in-click')
      this.$store.dispatch('info/signIn', payload)
    },

    close() {
      this.$cookies.removeAll()
      this.info = {}
      this.$emit('close-sign-in-click')
    },
  },
}
</script>