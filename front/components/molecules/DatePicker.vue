<template>
  <v-list-item three-line>
    <v-list-item-content>
      <div class="text-overline mb-4">いつから</div>
      <v-card-actions>
        <v-select
          v-model="startTime.year"
          :items="yearList"
          label="年"
          dense
        ></v-select>
        <v-select
          v-model="startTime.month"
          :items="monthList"
          label="月"
          dense
        ></v-select>
        <v-select
          v-model="startTime.day"
          :items="dayList"
          label="日"
          dense
        ></v-select>
        <v-select
          v-model="startTime.hour"
          :items="hourList"
          label="時"
          dense
        ></v-select>
        <v-select
          v-model="startTime.minute"
          :items="minuteList"
          label="分"
          dense
        ></v-select>
      </v-card-actions>

      <div class="text-overline mb-4">いつまで</div>
      <v-card-actions>
        <v-select
          v-model="finishTime.year"
          :items="yearList"
          label="年"
          dense
        ></v-select>
        <v-select
          v-model="finishTime.month"
          :items="monthList"
          label="月"
          dense
        ></v-select>
        <v-select
          v-model="finishTime.day"
          :items="dayList"
          label="日"
          dense
        ></v-select>
        <v-select
          v-model="finishTime.hour"
          :items="hourList"
          label="時"
          dense
        ></v-select>
        <v-select
          v-model="finishTime.minute"
          :items="minuteList"
          label="分"
          dense
        ></v-select>
      </v-card-actions>
      <v-btn outlined rounded text color="red" @click="register">
        {{ btnText }}
      </v-btn>
    </v-list-item-content>
  </v-list-item>
</template>

<script>
export default {
  props: {
    btnText: {
      type: String,
      default: '登録',
    },
  },

  data: () => ({
    // 今日の日付をとってきて今日から１年後くらいまでを自動でセットしたい
    yearList: ['2021', '2022', '2023', '2024'],
    monthList: [
      '01',
      '02',
      '03',
      '04',
      '05',
      '06',
      '07',
      '08',
      '09',
      '10',
      '11',
      '12',
    ],
    dayList: [
      '01',
      '02',
      '03',
      '04',
      '05',
      '06',
      '07',
      '08',
      '09',
      '10',
      '11',
      '12',
      '13',
      '14',
      '15',
    ],
    hourList: [
      '00',
      '01',
      '02',
      '03',
      '04',
      '05',
      '06',
      '07',
      '08',
      '09',
      '10',
      '11',
      '12',
      '13',
      '14',
      '15',
      '16',
      '17',
      '18',
      '19',
      '20',
      '21',
      '22',
      '23',
    ],
    minuteList: ['00', '15', '30', '45'],
    startTime: {},
    finishTime: {},
  }),

  computed: {
    stringStartTime() {
      return `${this.startTime.year}-${this.startTime.month}-${this.startTime.day}T${this.startTime.hour}:${this.startTime.minute}:00`
    },

    stringFinishTime() {
      return `${this.finishTime.year}-${this.finishTime.month}-${this.finishTime.day}T${this.finishTime.hour}:${this.finishTime.minute}:00`
    },
  },
  methods: {
    register() {
      this.$emit(
        'register-button-click',
        this.stringStartTime,
        this.stringFinishTime
      )
    },
  },
}
</script>