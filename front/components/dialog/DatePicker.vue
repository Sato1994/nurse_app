<template>
  <v-row justify="center">
    <v-dialog v-model="datePickerIsDisplay" persistent max-width="600px">
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
                    v-model="s_year"
                    :items="yearList"
                    label="年"
                    dense
                  ></v-select>
                  <v-select
                    v-model="s_month"
                    :items="monthList"
                    label="月"
                    dense
                  ></v-select>
                  <v-select
                    v-model="s_day"
                    :items="startDayList"
                    label="日"
                    dense
                  ></v-select>
                  <v-select
                    v-model="s_hour"
                    :items="hourList"
                    label="時"
                    dense
                  ></v-select>
                  <v-select
                    v-model="s_minute"
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
                    v-model="f_year"
                    :items="yearList"
                    label="年"
                    dense
                  ></v-select>
                  <v-select
                    v-model="f_month"
                    :items="monthList"
                    label="月"
                    dense
                  ></v-select>
                  <v-select
                    v-model="f_day"
                    :items="FinishDayList"
                    label="日"
                    dense
                  ></v-select>
                  <v-select
                    v-model="f_hour"
                    :items="hourList"
                    label="時"
                    dense
                  ></v-select>
                  <v-select
                    v-model="f_minute"
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
          <v-btn color="warning darken-1" text @click="hideDatePicker">
            閉じる
          </v-btn>
          <v-btn color="warning darken-1" text @click="register"> 決定 </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-row>
</template>

<script>
const today = new Date()

export default {
  props: {
    datePickerDisplay: {
      type: Boolean,
      default: false,
    },

    timeId: {
      type: Number,
      default: null,
    },

    title: {
      type: String,
      required: true,
    },

    startTime: {
      type: Object,
      default: () => ({
        year: today.getFullYear(),
        month: today.getMonth() + 1,
        day: today.getDate(),
        hour: today.getHours(),
        minute: 0,
      }),
    },

    finishTime: {
      type: Object,
      default: () => ({
        year: today.getFullYear(),
        month: today.getMonth() + 1,
        day: today.getDate(),
        hour: today.getHours(),
        minute: 0,
      }),
    },
  },

  data: () => ({
    datePickerIsDisplay: false,

    yearList: Array.from(new Array(2)).map(
      (_, i) => i + new Date(today).getFullYear()
    ),
    monthList: [...Array(12).keys()].map((i) => ++i),
    hourList: [...Array(24).keys()],
    minuteList: [0, 15, 30, 45],

    s_year: '',
    s_month: '',
    s_day: '',
    s_hour: '',
    s_minute: '',

    f_year: '',
    f_month: '',
    f_day: '',
    f_hour: '',
    f_minute: '',
  }),

  computed: {
    startDayList() {
      const date = new Date(this.s_year, this.s_month, 0)
      const dayListLast = date.getDate()
      return [...Array(dayListLast).keys()].map((i) => ++i)
    },

    FinishDayList() {
      const date = new Date(this.f_year, this.f_month, 0)
      const dayListLast = date.getDate()
      return [...Array(dayListLast).keys()].map((i) => ++i)
    },
  },

  watch: {
    datePickerDisplay(newValue) {
      this.datePickerIsDisplay = newValue
    },

    // createdで定義したs_yearをリアクティブにする必要がある
    startTime(newValue) {
      this.s_year = newValue.year
      this.s_month = newValue.month
      this.s_day = newValue.day
      this.s_hour = newValue.hour
      this.s_minute = newValue.minute
    },

    finishTime(newValue) {
      this.f_year = newValue.year
      this.f_month = newValue.month
      this.f_day = newValue.day
      this.f_hour = newValue.hour
      this.f_minute = newValue.minute
    },
  },

  // computedでオブジェクトにしてしまうと変更を検知されないのでこの書き方で仕方なしか
  mounted() {
    this.s_year = this.startTime.year
    this.s_month = this.startTime.month
    this.s_day = this.startTime.day
    this.s_hour = this.startTime.hour
    this.s_minute = this.startTime.minute

    this.f_year = this.finishTime.year
    this.f_month = this.finishTime.month
    this.f_day = this.finishTime.day
    this.f_hour = this.finishTime.day
    this.f_minute = this.finishTime.minute
  },

  methods: {
    hideDatePicker() {
      this.$emit('close-button-click')
    },

    register() {
      this.$emit('register-button-click', {
        startTime: {
          year: this.s_year,
          month: this.s_month,
          day: this.s_day,
          hour: this.s_hour,
          minute: this.s_minute,
        },
        finishTime: {
          year: this.f_year,
          month: this.f_month,
          day: this.f_day,
          hour: this.f_hour,
          minute: this.f_minute,
        },
        timeId: this.timeId,
      })
    },
  },
}
</script>