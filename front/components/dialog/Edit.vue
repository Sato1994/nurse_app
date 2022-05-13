<template>
  <v-row justify="center">
    <v-dialog :value="editDisplay" max-width="600px" @click:outside="closeEdit">
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
                <v-col cols="6">
                  <v-file-input
                    accept="image/*"
                    prepend-icon="mdi-image"
                    placeholder="画像を選択"
                    @change="setImage"
                  >
                  </v-file-input>
                </v-col>
                <v-col cols="6">
                  <div class="ml-4">
                    <v-avatar size="80">
                      <v-img :src="imgUrl"></v-img>
                    </v-avatar>
                  </div>
                  <input style="display: none" type="file" />
                </v-col>
                <v-col cols="12" sm="6" md="6">
                  <v-text-field
                    v-model="postalCode"
                    label="郵便番号を入力"
                    color="warning"
                    required
                  ></v-text-field>
                </v-col>

                <v-col cols="12" sm="6" md="6">
                  <v-btn
                    color="warning"
                    :disabled="!postalCode"
                    @click="getAddress"
                  >
                    住所を検索</v-btn
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

                <v-col v-if="address2Display" cols="12">
                  <v-text-field
                    v-model="address2"
                    label="住所続き"
                    required
                    color="warning"
                  ></v-text-field>
                </v-col>

                <input
                  v-model="copiedInfo.lat"
                  type="number"
                  style="display: none"
                />
                <input
                  v-model="copiedInfo.lng"
                  type="number"
                  style="display: none"
                />

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
          </v-card-text>
          <v-card-actions>
            <v-row>
              <v-col class="d-flex justify-space-around py-3">
                <v-btn color="warning darken-1" text @click="switchDeletable">
                  <v-icon>{{ lockIcon }}</v-icon>
                </v-btn>
              </v-col>
              <v-col class="d-flex justify-space-around py-3">
                <v-btn
                  color="red"
                  :disabled="!deletable"
                  text
                  @click="deleteAccount"
                >
                  退会する
                </v-btn>
              </v-col>
            </v-row>
            <v-spacer></v-spacer>
            <v-btn color="warning darken-1" text @click="closeEdit">
              閉じる
            </v-btn>
            <v-btn
              color="warning darken-1"
              text
              :disabled="invalid"
              @click="pushEditButton"
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
  props: {
    editDisplay: {
      type: Boolean,
      default: false,
    },

    info: {
      type: Object,
      default: null,
    },
  },

  data: () => ({
    postalCode: null,
    sex: [
      { text: '女性', value: true },
      { text: '男性', value: false },
    ],
    setImageUrl: null,
    deletable: false,
    address2: null,
    gotAddress: false,
  }),

  computed: {
    copiedInfo: {
      get() {
        return Object.assign({}, this.info)
      },
    },

    nameLabel() {
      return this.$cookies.get('user') === 'user'
        ? '名前（フルネーム）'
        : '病院名'
    },

    // 画像をセットしたらそのurlで表示
    imgUrl() {
      if (this.setImageUrl) {
        return this.setImageUrl
      } else {
        return this.info.image.url
      }
    },

    nameLengthRule() {
      return this.$cookies.get('user') === 'user'
        ? 'required|max:20'
        : 'required|max:40'
    },

    lockIcon() {
      if (this.deletable === true) {
        return 'mdi-lock-open-outline'
      } else {
        return 'mdi-lock-outline'
      }
    },

    address2Display() {
      if (this.gotAddress === true && this.$cookies.get('user') === 'host') {
        return true
      } else {
        return false
      }
    },
  },

  methods: {
    closeEdit() {
      this.deletable = false
      this.address2 = null
      this.gotAddress = false
      this.postalCode = null
      this.$emit('click-close-button')
    },

    switchDeletable() {
      this.deletable = !this.deletable
    },

    deleteAccount() {
      this.$axios
        .delete(`/api/${this.$cookies.get('user')}`, {
          headers: this.$cookies.get('authInfo'),
        })
        .then(() => {
          this.closeEdit()
          this.$cookies.removeAll()
          this.$router.push('/')
          this.$store.dispatch('info/resetAllStores')
          this.$store.dispatch('snackbar/setMessage', 'さよなら')
        })
    },

    pushEditButton() {
      // 第二addressがあればより詳細なlat lng取得
      if (!this.address2) {
        this.editUser()
      } else {
        this.getLatLng()
      }
    },

    async getLatLng() {
      try {
        const { data, status } = await this.$store.dispatch('info/getAddress', {
          searchSource: `${this.copiedInfo.address}${this.address2}`,
        })
        if (status === 'OK') {
          this.copiedInfo.lat = data.lat
          this.copiedInfo.lng = data.lng

          this.editUser()
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
        if (status === 'OK') this.copiedInfo.address = data.address
        this.gotAddress = true
        this.copiedInfo.lat = data.lat
        this.copiedInfo.lng = data.lng
      } catch {}
    },

    // イメージがセットされているならされているurlを代入
    setImage(image) {
      this.copiedInfo.image = image
      if (image) {
        this.setImageUrl = URL.createObjectURL(image)
      } else {
        this.setImageUrl = null
      }
    },

    async editUser() {
      try {
        const formData = new FormData()
        const headers = {
          'content-type': 'multipart/form-data',
          'access-token': this.$cookies.get('authInfo')['access-token'],
          client: this.$cookies.get('authInfo').client,
          uid: this.$cookies.get('authInfo').uid,
        }
        // 入力欄が埋まってるものだけformDataに
        for (const key in this.copiedInfo) {
          if (this.copiedInfo[key] != null)
            formData.append(key, this.copiedInfo[key])
        }

        if (this.address2)
          formData.set('address', `${this.copiedInfo.address}${this.address2}`)

        const { data } = await this.$axios.put(
          `/api/${this.$cookies.get('user')}`,
          formData,
          {
            headers,
          }
        )

        this.closeEdit()

        this.$store.dispatch(
          'snackbar/setMessage',
          'プロフィールを変更しました。'
        )
        this.$store.commit('info/saveInfo', data.info)
      } catch {
        this.$store.dispatch(
          'snackbar/setMessage',
          'プロフィールの更新に失敗しました。'
        )
      }
    },
  },
}
</script>