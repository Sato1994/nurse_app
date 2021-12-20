<template>
  <v-row justify="center">
    <v-dialog v-model="isDisplay" persistent max-width="600px">
      <v-card>
        <v-card-title>
          <span class="text-h5">絞り込み検索</span>
        </v-card-title>
        <v-card-text>
          <v-container>
            <v-row>
              <v-col cols="12">
                <v-text-field
                  v-if="$cookies.get('user') === 'user'"
                  v-model="name"
                  label="病院名"
                  color="warning"
                ></v-text-field>
              </v-col>
              <v-col cols="6">
                <v-select
                  v-if="$cookies.get('user') === 'host'"
                  v-model="lowerYear"
                  label="経験年数下限"
                  :items="yearItems"
                  color="warning"
                ></v-select>
                <p>年以上</p>
              </v-col>

              <v-col cols="12">
                <v-text-field
                  v-model="address"
                  label="住所"
                  required
                  color="warning"
                ></v-text-field>
              </v-col>

              <!-- <v-col cols="12">
                <v-switch
                  v-model="wanted"
                  label="リクエスト募集中のお相手のみ表示"
                  color="warning"
                ></v-switch>
              </v-col> -->
            </v-row>
          </v-container>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="warning darken-1" text @click="isDisplay = false">
            閉じる
          </v-btn>
          <v-btn color="warning darken-1" text @click="search"> 検索 </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-row>
</template>

<script>
export default {
  data: () => ({
    isDisplay: false,
    name: '',
    address: '',
    lowerYear: 0,
  }),

  methods: {
    search() {
      this.$emit('search-button-click', this.name, this.address, this.lowerYear)
      this.isDisplay = false
    },
  },

  computed: {
    yearItems() {
      return [...Array(11).keys()]
    },
  },
}
</script>