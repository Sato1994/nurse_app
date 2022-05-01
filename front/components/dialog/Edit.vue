<template>
  <v-row justify="center">
    <v-dialog
      v-model="$store.state.dialog.edit.editIsDisplay"
      persistent
      max-width="600px"
    >
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
                      v-model="info.name"
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
                    v-model="address"
                    label="住所"
                    required
                    color="warning"
                    :disabled="$cookies.get('user') === 'user' ? true : false"
                  ></v-text-field>
                </v-col>

                <v-col cols="12">
                  <ValidationProvider rules="max:300" name="プロフィール">
                    <v-textarea
                      v-model="info.profile"
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
                      v-model="info.age"
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
                      v-model="info.year"
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
                    v-model="info.sex"
                    :items="sex"
                    label="性別"
                    color="warning"
                    required
                  ></v-select>
                </v-col>
                <v-col cols="12">
                  <v-switch
                    v-model="info.wanted"
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
                  アカウント削除
                </v-btn>
              </v-col>
            </v-row>
            <v-spacer></v-spacer>
            <v-btn color="warning darken-1" text @click="hideEdit">
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
import { mapMutations } from 'vuex'
export default {
  data: () => ({
    postalCode: '',
    sex: [
      { text: '女性', value: true },
      { text: '男性', value: false },
    ],
    setImageUrl: null,
    deletable: false,
    address: '',
  }),

  computed: {
    info: {
      get() {
        return Object.assign({}, this.$store.getters['info/info'])
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
        return this.$store.getters['info/info'].image.url
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
  },

  mounted() {
    this.address = this.info.address
  },

  methods: {
    ...mapMutations('dialog/edit', ['hideEdit']),

    switchDeletable() {
      this.deletable = !this.deletable
    },

    deleteAccount() {
      this.$axios
        .delete(`/api/${this.$cookies.get('user')}`, {
          headers: this.$cookies.get('authInfo'),
        })
        .then(() => {
          this.hideEdit()
          this.$cookies.removeAll()
          this.$router.push('/')
          this.$store.dispatch('info/logout')
          this.$store.dispatch('snackbar/setMessage', 'さよなら')
        })
    },

    async getAddress() {
      try {
        const { data } = await this.$axios.get(
          `https://api.zipaddress.net/?zipcode=${this.postalCode}`
        )
        this.address = data.data.fullAddress
      } catch {
        this.$store.dispatch(
          'snackbar/setMessage',
          '住所の検索の取得に失敗しました。'
        )
      }
    },

    // イメージがセットされているならされているurlを代入
    setImage(image) {
      this.info.image = image
      if (image) {
        this.setImageUrl = URL.createObjectURL(image)
      } else {
        this.setImageUrl = null
      }
    },

    async editUser() {
      try {
        this.hideEdit()
        const formData = new FormData()
        const headers = {
          'content-type': 'multipart/form-data',
          'access-token': this.$cookies.get('authInfo')['access-token'],
          client: this.$cookies.get('authInfo').client,
          uid: this.$cookies.get('authInfo').uid,
        }
        // 入力欄が埋まってるものだけformDataに
        for (const key in this.info) {
          if (this.info[key] != null) formData.append(key, this.info[key])
        }
        formData.set('address', this.address)

        const { data } = await this.$axios.put(
          `/api/${this.$cookies.get('user')}`,
          formData,
          {
            headers,
          }
        )

        this.$store.dispatch(
          'snackbar/setMessage',
          'プロフィールを変更しました。'
        )
        this.$store.commit('info/saveInfo', data.data)
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