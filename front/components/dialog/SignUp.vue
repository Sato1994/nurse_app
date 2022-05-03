<template>
  <v-row justify="center">
    <v-dialog :value="signUpDisplay" @click:outside="close" max-width="600px">
      <v-card>
        <ValidationObserver v-slot="{ invalid }">
          <v-card-title>
            <span class="text-h5">新規登録</span>
          </v-card-title>
          <v-card-text>
            <v-container>
              <v-row>
                <v-col cols="12" sm="6" md="6">
                  <ValidationProvider
                    v-slot="{ errors }"
                    :rules="nameLengthRule"
                    name="名前"
                  >
                    <v-text-field
                      v-model="info.name"
                      label="名前（フルネーム）"
                      required
                    ></v-text-field>
                    <span class="red--text">{{ errors[0] }}</span>
                  </ValidationProvider>
                </v-col>
                <v-col cols="12" sm="6" md="6">
                  <ValidationProvider
                    v-slot="{ errors }"
                    rules="required|alpha_num|max:15"
                    name="ID"
                  >
                    <v-text-field
                      v-model="info.myid"
                      label="サイト内ID"
                      required
                    ></v-text-field>
                    <span class="red--text">{{ errors[0] }}</span>
                  </ValidationProvider>
                </v-col>
                <v-col v-if="$cookies.get('user') === 'host'" cols="12">
                  <ValidationProvider
                    v-slot="{ errors }"
                    rules="required|numeric"
                    name="電話番号"
                  >
                    <v-text-field
                      v-model="info.phone"
                      label="電話番号"
                    ></v-text-field>
                    <span class="red--text">{{ errors[0] }}</span>
                  </ValidationProvider>
                </v-col>
                <v-col cols="12">
                  <ValidationProvider
                    v-slot="{ errors }"
                    rules="required|email"
                    name="メールアドレス"
                  >
                    <v-text-field
                      v-model="info.email"
                      label="メールアドレス"
                      required
                    ></v-text-field>

                    <span class="red--text">{{ errors[0] }}</span>
                  </ValidationProvider>
                </v-col>
                <v-col cols="12">
                  <ValidationProvider
                    v-slot="{ errors }"
                    rules="required|min:6"
                    vid="confirmation"
                    name="パスワード"
                  >
                    <v-text-field
                      v-model="info.password"
                      label="パスワード"
                      required
                    ></v-text-field>
                    <span class="red--text">{{ errors[0] }}</span>
                  </ValidationProvider>
                </v-col>
                <v-col cols="12">
                  <ValidationProvider
                    v-slot="{ errors }"
                    rules="required|confirmed:confirmation"
                    name="パスワード"
                  >
                    <v-text-field
                      v-model="info.password_confirmation"
                      label="パスワード確認用"
                      required
                    ></v-text-field>
                    <span class="red--text">{{ errors[0] }}</span>
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
              @click="signUp(info)"
            >
              登録
            </v-btn>
          </v-card-actions>
        </ValidationObserver>
      </v-card>
    </v-dialog>
  </v-row>
</template>

<script>
export default {
  data: () => ({
    info: {},
  }),

  props: {
    signUpDisplay: {
      type: Boolean,
      default: false,
    },
  },

  computed: {
    nameLengthRule() {
      return this.$cookies.get('user') === 'user'
        ? 'required|max:20'
        : 'required|max:40'
    },
  },

  methods: {
    signUp(payload) {
      this.$emit('close-sign-up-click')
      this.$store.dispatch('info/signUp', payload)
    },

    close() {
      this.$cookies.removeAll()
      this.info = {}
      this.$emit('close-sign-up-click')
    },
  },
}
</script>