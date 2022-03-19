<template>
  <v-row justify="center">
    <v-dialog v-model="isDisplay" persistent max-width="600px">
      <v-card>
        <ValidationObserver v-slot="{ invalid }">
          <v-card-title>
            <span class="text-h5">プロフィール編集</span>
          </v-card-title>
          <v-card-text>
            <v-container>
              <v-row>
                <v-col cols="12">
                  <ValidationProvider
                    v-slot="{ errors }"
                    :rules="nameLengthRule"
                    name="名前"
                  >
                    <v-text-field
                      v-model="copiedInfo.name"
                      :label="nameLabel"
                      color="warning"
                      required
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
                  <v-text-field
                    v-model="copiedInfo.address"
                    label="住所"
                    required
                    color="warning"
                    :disabled="$cookies.get('user') === 'user' ? true : false"
                  ></v-text-field>
                </v-col>

                <v-col cols="12">
                  <ValidationProvider rules="max:300" name="プロフィール">
                    <v-textarea
                      v-model="copiedInfo.profile"
                      label="プロフィール"
                      :counter="300"
                      required
                      color="warning"
                    ></v-textarea>
                  </ValidationProvider>
                </v-col>
                <v-col
                  v-if="$cookies.get('user') === 'user'"
                  cols="12"
                  sm="6"
                  md="6"
                >
                  <ValidationProvider
                    v-slot="{ errors }"
                    rules="between:20,60"
                    name="年齢"
                  >
                    <v-text-field
                      v-model="copiedInfo.age"
                      label="年齢"
                      type="number"
                      color="warning"
                      required
                    ></v-text-field>
                    <span class="red--text">{{ errors[0] }}</span>
                  </ValidationProvider>
                </v-col>
                <v-col
                  v-if="$cookies.get('user') === 'user'"
                  cols="12"
                  sm="6"
                  md="6"
                >
                  <ValidationProvider
                    v-slot="{ errors }"
                    rules="between:0,39"
                    name="経験年数"
                  >
                    <v-text-field
                      v-model="copiedInfo.year"
                      label="経験年数"
                      type="number"
                      color="warning"
                      required
                    ></v-text-field>
                    <span class="red--text">{{ errors[0] }}</span>
                  </ValidationProvider>
                </v-col>
                <v-col v-if="$cookies.get('user') === 'user'" cols="12">
                  <v-select
                    v-model="copiedInfo.sex"
                    :items="sex"
                    label="性別"
                    color="warning"
                    required
                  ></v-select>
                </v-col>
                <v-col cols="12">
                  <v-switch
                    v-model="copiedInfo.wanted"
                    label="お相手からのリクエストを受け付けますか？"
                    color="warning"
                  ></v-switch>
                </v-col>
              </v-row>
            </v-container>
            <small>全て入力必須です</small>
          </v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn color="warning darken-1" text @click="isDisplay = false">
              閉じる
            </v-btn>
            <v-btn
              color="warning darken-1"
              text
              :disabled="invalid"
              @click="editUser"
            >
              保存
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
    isDisplay: false,
    postalCode: '',
    sex: [
      { text: '女性', value: true },
      { text: '男性', value: false },
    ],
    copiedInfo: [],
  }),

  computed: {
    nameLabel() {
      return this.$cookies.get('user') === 'user'
        ? '名前（フルネーム）'
        : '病院名'
    },

    nameLengthRule() {
      return this.$cookies.get('user') === 'user'
        ? 'required|max:20'
        : 'required|max:40'
    },
  },

  created() {
    this.copiedInfo = Object.assign({}, this.$store.getters['info/info'])
  },

  methods: {
    editUser() {
      this.$axios
        .put(`/api/${this.$cookies.get('user')}`, this.copiedInfo, {
          headers: this.$cookies.get('authInfo'),
        })
        .then((response) => {
          this.$store.dispatch(
            'snackbar/setMessage',
            'プロフィールを変更しました。'
          )
          this.$router.push(
            `/${this.$cookies.get('user')}/${response.data.data.myid}`
          )
          this.$emit('edit-button-click', this.copiedInfo)
          this.isDisplay = false
          this.$store.dispatch('info/saveInfo', response.data.data)
        })
        .catch((error) => {
          console.log('登録失敗', error)
        })
    },

    getAddress() {
      this.$axios
        .get(`https://api.zipaddress.net/?zipcode=${this.postalCode}`)
        .then((response) => {
          this.copiedInfo.address = response.data.data.fullAddress
        })
        .catch(() => {
          this.$store.dispatch(
            'snackbar/setMessage',
            '住所の検索の取得に失敗しました。'
          )
        })
    },
  },
}
</script>
