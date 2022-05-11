<template>
  <v-row justify="center">
    <v-dialog :value="signUpDisplay" max-width="600px" @click:outside="close">
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
                      :label="nameLabel"
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

                <v-col cols="12" sm="6" md="6">
                  <v-text-field
                    v-model="postalCode"
                    label="郵便番号で検索する"
                    color="warning"
                    required
                  ></v-text-field>
                </v-col>

                <v-col cols="12" sm="6" md="6">
                  <v-btn color="warning" @click="getAddress">
                    住所を検索する</v-btn
                  >
                </v-col>

                <v-col cols="12">
                  <ValidationProvider
                    v-slot="{ errors }"
                    rules="required"
                    name="住所"
                  >
                    <v-text-field
                      v-model="address1"
                      label="住所"
                      required
                      color="warning"
                      disabled
                    ></v-text-field>
                    <span class="red--text">{{ errors[0] }}</span>
                  </ValidationProvider>
                </v-col>

                <v-col v-if="address2Display" cols="12">
                  <v-text-field
                    v-model="info.address2"
                    label="住所続き"
                    required
                    color="warning"
                  ></v-text-field>
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
              @click="signUp(signUpPayload)"
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
  props: {
    signUpDisplay: {
      type: Boolean,
      default: false,
    },
  },

  data: () => ({
    info: {},
    postalCode: '',
    gotAddress: false,
    address1: null,
  }),

  computed: {
    signUpPayload() {
      let address2 = this.info.address2
      if (this.info.address2 === undefined) address2 = ''

      return {
        name: this.info.name,
        myid: this.info.myid,
        address: `${this.address1}${address2}`,
        phone: this.info.phone,
        email: this.info.email,
        password: this.info.password,
        password_confirmation: this.info.password_confirmation,
      }
    },

    nameLengthRule() {
      return this.$cookies.get('user') === 'user'
        ? 'required|max:20'
        : 'required|max:40'
    },

    address2Display() {
      if (this.gotAddress === true && this.$cookies.get('user') === 'host') {
        return true
      } else {
        return false
      }
    },

    nameLabel() {
      if (this.$cookies.get('user') === 'user') {
        return '名前（フルネーム）'
      } else {
        return '病院名'
      }
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
      this.postalCode = ''
      this.$emit('close-sign-up-click')
    },

    async getAddress() {
      try {
        const { data } = await this.$axios.get(
          `https://maps.googleapis.com/maps/api/geocode/json?address=${this.postalCode}&key=${this.$config.MAPS_API_KEY}`
        )
        if (data.status === 'OK') {
          this.address1 = `${data.results[0].address_components[3].long_name}${data.results[0].address_components[2].long_name}${data.results[0].address_components[1].long_name}`
          this.gotAddress = true
        } else if (data.status === 'ZERO_RESULTS') {
          this.$store.dispatch('snackbar/setMessage', '入力を見直してください')
        }
      } catch {
        this.$store.dispatch(
          'snackbar/setMessage',
          '住所の検索の取得に失敗しました'
        )
      }
    },
  },
}
</script>