<template>
  <v-row justify="center">
    <v-dialog v-model="isDisplay" persistent max-width="600px">
      <v-card>
        <v-card-title>
          <span class="text-h5">{{ title }}</span>
        </v-card-title>

        <v-card-text>
          <v-container>
            <v-row>
              <v-col cols="12">
                <small>開始日時</small>
                <v-card-actions>
                  <v-select
                    v-model="anotherStartTime.year"
                    :items="yearList"
                    label="年"
                    dense
                  ></v-select>
                  <v-select
                    v-model="anotherStartTime.month"
                    :items="monthList"
                    label="月"
                    dense
                  ></v-select>
                  <v-select
                    v-model="anotherStartTime.day"
                    :items="dayList"
                    label="日"
                    dense
                  ></v-select>
                  <v-select
                    v-model="anotherStartTime.hour"
                    :items="hourList"
                    label="時"
                    dense
                  ></v-select>
                  <v-select
                    v-model="anotherStartTime.minute"
                    :items="minuteList"
                    label="分"
                    dense
                  ></v-select>
                </v-card-actions>
              </v-col>
              <v-col cols="12">
                <small>終了日時</small>
                <v-card-actions>
                  <v-select
                    v-model="anotherFinishTime.year"
                    :items="yearList"
                    label="年"
                    dense
                  ></v-select>
                  <v-select
                    v-model="anotherFinishTime.month"
                    :items="monthList"
                    label="月"
                    dense
                  ></v-select>
                  <v-select
                    v-model="anotherFinishTime.day"
                    :items="dayList"
                    label="日"
                    dense
                  ></v-select>
                  <v-select
                    v-model="anotherFinishTime.hour"
                    :items="hourList"
                    label="時"
                    dense
                  ></v-select>
                  <v-select
                    v-model="anotherFinishTime.minute"
                    :items="minuteList"
                    label="分"
                    dense
                  ></v-select>
                </v-card-actions>
              </v-col>
            </v-row>
          </v-container>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="warning darken-1" text @click="isDisplay = false">
            閉じる
          </v-btn>
          <v-btn color="warning darken-1" text @click="register"> 決定 </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-row>
</template>

<script>
export default {
  props: {
    title: {
      type: String,
      required: true,
    },

    startTime: {
      type: Object,
      default: () => {},
    },

    finishTime: {
      type: Object,
      default: () => {},
    },
  },

  data: () => ({
    isDisplay: false,
    // 今日の日付をとってきて今日から１年後くらいまでを自動でセットしたい
    yearList: [
      2021, 2022, 2023, 2024, 2025, 2026, 2027, 2028, 2029, 2030, 2031,
    ],

    monthList: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],

    dayList: [
      1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21,
      22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32,
    ],

    hourList: [
      0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
      21, 22, 23,
    ],

    minuteList: [0, 15, 30, 45],
  }),

  computed: {
    stringStartTime() {
      return `${this.anotherStartTime.year}-${this.anotherStartTime.month}-${this.anotherStartTime.day}T${this.anotherStartTime.hour}:${this.anotherStartTime.minute}:00`
    },

    stringFinishTime() {
      return `${this.anotherFinishTime.year}-${this.anotherFinishTime.month}-${this.anotherFinishTime.day}T${this.anotherFinishTime.hour}:${this.anotherFinishTime.minute}:00`
    },

    anotherStartTime() {
      return this.startTime
    },

    anotherFinishTime() {
      return this.finishTime
    },
  },

  methods: {
    register() {
      this.$emit(
        'register-button-click',
        this.stringStartTime,
        this.stringFinishTime
      )
      this.isDisplay = false
    },
  },
}
</script>