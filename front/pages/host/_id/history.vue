<template>
  <v-card>
    <v-card-title class="justify-center">{{ name }} </v-card-title>
    <v-divider class="mx-4"></v-divider>

    <v-container>
      <v-card>
        <div v-if="agreements !== null">
          <v-card-title>
            過去の契約
            <v-spacer></v-spacer>
            <v-text-field
              v-model="search"
              append-icon="mdi-magnify"
              label="検索"
              single-line
              hide-details
              dense
            ></v-text-field>
          </v-card-title>

          <v-data-table
            v-if="agreements !== null"
            :headers="headers"
            :items="agreements"
            :search="search"
            :footer-props="{
              'items-per-page-text': '',

              'disable-items-per-page': true,
            }"
            class="table"
            :items-per-page="5"
            no-data-text="データがありません。"
            @click:row="clickTable"
          >
            <template #[`item.state`]="{ item }">
              <v-chip :color="getStateColor(item.state)" dark small>
                {{ item.state }}
              </v-chip>
            </template>
          </v-data-table>
        </div>
      </v-card>
    </v-container>

    <v-container fluid>
      <v-row>
        <v-col align="center" justify="center" cols="6" sm="4" md="4" lg="4">
          <v-card rounded>
            <v-responsive aspect-ratio="1">
              <v-card-text> 契約回数 </v-card-text>
              <v-card-text class="text-h1">
                {{ agreementsCount }}
              </v-card-text>
            </v-responsive>
          </v-card>
        </v-col>

        <v-col align="center" justify="center" cols="6" sm="4" md="4" lg="4">
          <v-card rounded>
            <v-responsive aspect-ratio="1">
              <v-card-text> カミングスーーン </v-card-text>
              <v-card-text class="text-h1"> </v-card-text>
            </v-responsive>
          </v-card>
        </v-col>
      </v-row>
    </v-container>

    <v-card-text>
      <v-btn
        :to="`/${routeConfig.me}/${routeConfig.myid}`"
        nuxt
        class="mt-3 grey--text"
        rounded
        small
        depressed
        block
      >
        プロフィール
      </v-btn>
    </v-card-text>
  </v-card>
</template>

<script>
export default {
  async asyncData({ route, $axios, $cookies }) {
    const me = route.path.substr(1, 4)
    const myid = route.path.replace('/history', '').replace(`/${me}/`, '')

    const { data } = await $axios.get(
      `/api/hosts/${myid}/history`,

      { headers: $cookies.get('authInfo') }
    )
    return {
      name: data.name,
      agreementsList: data.agreements_list,
      agreementsCount: data.agreements_count,
    }
  },

  data: () => ({
    search: '',
    headers: [
      {
        text: 'お相手',
        align: 'start',
        value: 'name',
      },
      { text: '日付', value: 'date' },
      { text: '結果', value: 'state' },
    ],
  }),

  computed: {
    agreements() {
      if (this.agreementsList) {
        return this.agreementsList.map((obj) => {
          let s = new Date(obj.start_time)
          let state = ''

          switch (obj.state) {
            case 'finished':
              state = '終了'
              break
            case 'cancelled':
              state = 'キャンセル'
              break
          }

          if (process.server) {
            s = new Date(s.setHours(s.getHours() + 9))
          }

          const newObj = {
            name: obj.partner.name,
            date: `${s.getMonth() + 1}/${s.getDate()}`,
            state,
            roomId: obj.room.id,
          }
          return newObj
        })
      } else {
        return null
      }
    },

    routeConfig() {
      const me = this.$route.path.substr(1, 4)
      const myid = this.$route.path
        .replace('/history', '')
        .replace(`/${me}/`, '')
      return {
        me,
        myid,
      }
    },
  },

  methods: {
    getStateColor(state) {
      switch (state) {
        case '終了':
          return '#B0C4B1'
        case 'キャンセル':
          return '#DEDBD2'
      }
    },
    clickTable(selected) {
      this.$router.push(`/rooms/${selected.roomId}`)
    },
  },
}
</script>

<style  scoped>
.table >>> tbody tr :hover {
  cursor: pointer;
}
</style>