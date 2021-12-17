<template>
  <v-card class="mx-auto" max-width="" outlined>
    <DatePicker btn-text="募集期間を登録" @register-button-click="register" />
    <v-card class="mx-auto" max-width="" tile>
      <v-list dense>
        <v-subheader>Timeの登録一覧</v-subheader>
        <v-list-item-group
          v-for="(time, index) in formedMyTimes"
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
    icon: 'mdi-clock',
  }),

  computed: {
    formedMyTimes() {
      const myTimes = this.$store.getters['times/times'].map((obj) => {
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
      return myTimes
    },
  },

  methods: {
    register(startTime, finishTime) {
      this.$axios
        .post(
          `/api/${
            this.$cookies.get('user') === 'user'
              ? 'free_times'
              : 'recruitment_times'
          }`,
          {
            start_time: startTime,
            finish_time: finishTime,
          },
          { headers: this.$cookies.get('authInfo') }
        )
        .then((response) => {
          console.log('とりあえず成功', response.data)
        })
        .catch((error) => {
          console.log('とりあえず失敗', error)
        })
    },
  },
}
</script>
