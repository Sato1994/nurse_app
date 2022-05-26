<template>
  <v-row justify="center">
    <v-dialog max-width="600px" :value="searchDisplay" @click:outside="close">
      <v-card>
        <v-card-title>
          <span class="text-h5">絞り込み検索</span>
        </v-card-title>
        <v-card-text>
          <v-container>
            <v-row>
              <v-col cols="12">
                <v-text-field
                  v-if="$cookies.get('user') != 'host'"
                  v-model="name"
                  label="病院名"
                  color="#B0C4B1"
                ></v-text-field>
              </v-col>
              <v-col v-if="$cookies.get('user') === 'host'" cols="6">
                <v-select
                  v-model="lowerYear"
                  label="経験年数下限"
                  :items="yearItems"
                  color="#B0C4B1"
                ></v-select>
                <p>年以上</p>
              </v-col>

              <v-col cols="12">
                <v-text-field
                  v-model="address"
                  label="住所"
                  required
                  color="#B0C4B1"
                ></v-text-field>
              </v-col>

              <v-col cols="12">
                <v-switch
                  v-model="wanted"
                  label="リクエスト募集中のお相手のみ表示"
                  color="#B0C4B1"
                ></v-switch>
              </v-col>
            </v-row>
          </v-container>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="#B0C4B1" text @click="close"> 閉じる </v-btn>
          <v-btn color="#EF6461" text @click="search"> 検索 </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-row>
</template>

<script>
export default {
  props: {
    searchDisplay: {
      type: Boolean,
      default: false,
    },
  },

  data: () => ({
    name: '',
    address: '',
    lowerYear: null,
    wanted: '',
  }),

  computed: {
    yearItems() {
      return [...Array(10).keys()].map((i) => ++i)
    },
  },

  methods: {
    search() {
      this.$emit(
        'search-button-click',
        this.name,
        this.address,
        this.lowerYear,
        this.wanted
      )
      this.close()
    },

    close() {
      this.$emit('close-button-click')
    },
  },
}
</script>