<template>
  <v-card class="mx-auto" max-width="" outlined>
    <DatePicker btn-text="オファーを送る" @register-button-click="register" />
    <v-card class="mx-auto" max-width="" tile>
      <v-list dense>
        <v-subheader>病院の募集時間の一覧</v-subheader>
        <v-list-item-group
          v-for="(time, index) in formedTargetTimes"
          :key="index"
          color="primary"
        >
          <v-list-item>
            <v-list-item-icon>
              <v-icon v-text="icon"></v-icon>
            </v-list-item-icon>

            <v-list-item-content>
              <v-list-item-title v-text="time.formedTime"></v-list-item-title>
            </v-list-item-content>
          </v-list-item>
        </v-list-item-group>
      </v-list>
    </v-card>
  </v-card>
</template>

<script>
import DatePicker from '@/components/dialog/DatePicker.vue'
export default {
  components: {
    DatePicker,
  },

  data: () => ({
    // 今日の日付をとってきて今日から１年後くらいまでを自動でセットしたい
    icon: 'mdi-clock',
    targetTimes: [],
  }),

  computed: {
    formedTargetTimes() {
      const targetTimes = this.targetTimes.map((obj) => {
        const s = new Date(obj.start_time)
        const f = new Date(obj.finish_time)
        const newObject = {
          id: obj.id,
          formedTime: `${s.getFullYear()}年${
            s.getMonth() + 1
          }月${s.getDate()}日${s.getHours()}時${s.getMinutes()}分から${f.getFullYear()}年${
            f.getMonth() + 1
          }月${f.getDate()}日${f.getHours()}時${f.getMinutes()}分`,
        }
        return newObject
      })
      return targetTimes
    },
  },

  created() {
    const myid = this.$route.params.id
    this.$axios
      .get(`http://localhost:3000/api/hosts/${myid}`)
      .then((response) => {
        this.targetTimes = response.data.times
      })
  },

  methods: {
    register(startTime, finishTime) {
      this.$axios
        .post(
          `/api/user_requests/${this.$route.query.t}`,
          {
            start_time: startTime,
            finish_time: finishTime,
          },
          { headers: this.$cookies.get('authInfo') }
        )
        .then((response) => {
          console.log('user_request成功', response.data)
          this.$store.dispatch('requests/addRequest', response.data)
          this.$router.push(`/user/${this.$store.state.info.info.myid}`)
        })
        .catch((error) => {
          console.log('user_request失敗', error)
        })
    },
  },
}
</script>
