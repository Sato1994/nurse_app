<template>
  <v-card>
    <v-card-title>山田孝之 </v-card-title>
    <v-divider class="mx-4"></v-divider>

    <v-card>
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
        @click:row="clickTable"
        :headers="headers"
        :items="agreements"
        :search="search"
        dense
        class="table"
      >
        <template #[`item.star`]="{ item }">
          <v-rating
            v-if="Number.isInteger(item.star)"
            :value="item.star"
            color="amber"
            dense
            half-increments
            readonly
            size="14"
          ></v-rating>
          <span v-if="item.star === '未'"> 未 </span>
          <span v-if="item.star === '-'"> - </span>
        </template>

        <template #[`item.state`]="{ item }">
          <v-chip :color="getStateColor(item.state)" dark small>
            {{ item.state }}
          </v-chip>
        </template>
      </v-data-table>
    </v-card>

    <v-card-text>
      {{ agreements_list }}
      <v-btn
        v-if="$route.query.me"
        :to="`/${$route.query.me}/${$route.query.myid}`"
        nuxt
        class="mt-3"
        rounded
        small
        depressed
        block
      >
        プロフ
      </v-btn>
    </v-card-text>
  </v-card>
</template>

<script>
export default {
  async asyncData({ route, $axios, $cookies }) {
    const { data } = await $axios.get(
      `/api/users/${route.query.myid}/history`,

      { headers: $cookies.get('authInfo') }
    )
    return {
      agreements_list: data.agreements_list,
    }
  },

  data: () => ({
    search: '',
    headers: [
      {
        text: '名前',
        align: 'start',
        sortable: false,
        value: 'name',
      },
      { text: '日付', value: 'date' },
      { text: '結果', value: 'state' },
      { text: '評価', value: 'star' },
    ],
  }),

  computed: {
    agreements() {
      return this.agreements_list.map((obj) => {
        let s = new Date(obj.start_time)
        let star = '-'
        let state = ''

        switch (true) {
          case typeof obj.rate !== 'undefined':
            star = obj.rate.star
            break
          case obj.state === 'finished':
            star = '未'
            break
        }

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
          star,

          roomId: obj.room.id,
        }
        return newObj
      })
    },
  },

  methods: {
    getStateColor(state) {
      switch (state) {
        case '終了':
          return 'green'
        case 'キャンセル':
          return 'red'
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