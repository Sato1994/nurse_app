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
                      color="#B0C4B1"
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
                      color="#B0C4B1"
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
                      color="#B0C4B1"
                    ></v-text-field>
                    <span class="red--text">{{ errors[0] }}</span>
                  </ValidationProvider>
                </v-col>

                <v-col cols="12" sm="6" md="6">
                  <v-text-field
                    v-model="postalCode"
                    label="郵便番号を入力"
                    color="#B0C4B1"
                    required
                  ></v-text-field>
                </v-col>

                <v-col cols="12" sm="6" md="6">
                  <v-btn
                    color="#B0C4B1"
                    :disabled="!postalCode"
                    @click="getAddress"
                  >
                    住所を検索</v-btn
                  >
                </v-col>

                <v-col cols="12">
                  <ValidationProvider
                    v-slot="{ errors }"
                    rules="required"
                    name="住所"
                  >
                    <v-text-field
                      v-model="info.address"
                      label="住所"
                      required
                      color="#B0C4B1"
                      disabled
                    ></v-text-field>
                    <span class="red--text">{{ errors[0] }}</span>
                  </ValidationProvider>
                </v-col>
                <input v-model="info.lat" type="number" style="display: none" />
                <input v-model="info.lng" type="number" style="display: none" />

                <v-col v-if="address2Display" cols="12">
                  <v-text-field
                    v-model="address2"
                    label="住所続き"
                    required
                    color="#B0C4B1"
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
                      color="#B0C4B1"
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
                      color="#B0C4B1"
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
                      color="#B0C4B1"
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
            <v-btn color="#B0C4B1" text @click="close"> 閉じる </v-btn>
            <v-btn
              color="#EF6461"
              text
              :disabled="invalid"
              @click="pushSignUpButton"
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
    address2: null,
    postalCode: null,
    gotAddress: false,
  }),

  computed: {
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
    signUp() {
      let address = ''
      if (this.address2) {
        address = `${this.info.address}${this.address2}`
      } else {
        address = this.info.address
      }

      const payload = {
        name: this.info.name,
        myid: this.info.myid,
        address,
        phone: this.info.phone,
        email: this.info.email,
        lat: this.info.lat,
        lng: this.info.lng,
        password: this.info.password,
        password_confirmation: this.info.password_confirmation,
      }

      this.$emit('close-sign-up-click')
      this.$store.dispatch('info/signUp', payload)
    },

    close() {
      this.$cookies.removeAll()
      this.info = {}
      this.address2 = null
      this.postalCode = null
      this.$emit('close-sign-up-click')
    },

    pushSignUpButton() {
      if (!this.address2) {
        this.signUp()
      } else {
        // 第二addressがあればより詳細なlat lng取得
        this.getLatLng()
      }
    },

    async getLatLng() {
      try {
        const { data, status } = await this.$store.dispatch('info/getAddress', {
          searchSource: `${this.info.address}${this.address2}`,
        })
        if (status === 'OK') {
          this.info.lat = data.lat
          this.info.lng = data.lng

          this.signUp()
        } else if (data.status === 'ZERO_RESULTS') {
          this.$store.dispatch('snackbar/setMessage', '住所を見直してください')
        }
      } catch {
        this.$store.dispatch('snackbar/setMessage', '住所検索に失敗しました')
      }
    },

    async getAddress() {
      try {
        const { data, status } = await this.$store.dispatch('info/getAddress', {
          searchSource: this.postalCode,
        })
        if (status === 'OK') this.info.address = data.address
        this.gotAddress = true
        this.info.lat = data.lat
        this.info.lng = data.lng
      } catch {}
    },
  },
}
</script>