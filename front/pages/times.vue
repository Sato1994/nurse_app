<template>








  <v-card
    class="mx-auto"
    max-width=""
    outlined
  >
    <v-list-item three-line>
      <v-list-item-content>
        <div class="text-overline mb-4">
          いつから
        </div>
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
        

        <div class="text-overline mb-4">
          いつまで
        </div>
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
      </v-list-item-content>

     
    </v-list-item>

    <v-btn
        outlined
        rounded
        text
        color="red"
        @click="register"
      >
      登録
      </v-btn>

      {{stringStartTime}}
      {{stringFinishTime}}

   
  </v-card>
</template>

<script>
export default {

  data: () => ({
    // 今日の日付をとってきて今日から１年後くらいまでを自動でセットしたい
    yearList: ['2021', '2022', '2023', '2024'],
    monthList: ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'],
    dayList: ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12','13','14','15'],
    hourList: ['00','01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12','13','14','15','16','17','18','19','20','21','22','23'],
    minuteList: ['00','15', '30', '45'],

    startTime: {},
    finishTime: {},
    myFreeTimes: [],
  }),
  created() {
    this.$axios.get('')
  }
  computed: {
    stringStartTime() {
     return `${this.startTime.year}-${this.startTime.month}-${this.startTime.day}T${this.startTime.hour}:${this.startTime.minute}:00`
    },
    stringFinishTime() {
      return `${this.finishTime.year}-${this.finishTime.month}-${this.finishTime.day}T${this.finishTime.hour}:${this.finishTime.minute}:00`
    }
  },
  methods: {
    register() {
      this.$axios.post('/api/free_times', {start_time: this.stringStartTime, finish_time: this.stringFinishTime},
      {headers: this.$cookies.get('authInfo')})
      .then((response) => {
        console.log('とりあえず成功', response.data)
      })
      .catch((error) => {
        console.log('とりあえず失敗', error)
      })
    }
  }

  
};

</script>
