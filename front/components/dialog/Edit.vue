<template>
  <v-row justify="center">
    <v-dialog v-model="isDisplay" persistent max-width="600px">
      <v-card>
        <v-card-title>
          <span class="text-h5">プロフィール編集</span>
        </v-card-title>
        <v-card-text>
          <v-container>
            <v-row>
              <v-col cols="12">
                <v-text-field
                  v-model="copiedInfo.name"
                  :counter="10"
                  :label="nameLabel"
                  color="warning"
                  required
                ></v-text-field>
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
                  disabled
                ></v-text-field>
              </v-col>

              <v-col cols="12">
                <v-textarea
                  v-model="copiedInfo.profile"
                  label="プロフィール"
                  required
                  color="warning"
                ></v-textarea>
              </v-col>
              <v-col
                v-if="$cookies.get('user') === 'user'"
                cols="12"
                sm="6"
                md="6"
              >
                <v-text-field
                  v-model="copiedInfo.age"
                  label="年齢"
                  type="number"
                  color="warning"
                  required
                ></v-text-field>
              </v-col>
              <v-col
                v-if="$cookies.get('user') === 'user'"
                cols="12"
                sm="6"
                md="6"
              >
                <v-text-field
                  v-model="copiedInfo.year"
                  label="経験年数"
                  type="number"
                  color="warning"
                  required
                ></v-text-field>
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
          <v-btn color="warning darken-1" text @click="editUser"> 保存 </v-btn>
        </v-card-actions>
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
          this.$router.push(
            `/${this.$cookies.get('user')}/${response.data.data.myid}`
          )
          this.$emit('edit-button-click', this.copiedInfo)
          this.isDisplay = false
          console.log('editのresponse', response.data)
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
          console.log(response.data)
          this.copiedInfo.address = response.data.data.fullAddress
        })
        .catch((error) => {
          console.log(error)
        })
    },
  },
}
</script>
