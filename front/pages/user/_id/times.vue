<template>
  <v-card
    class="mx-auto"
    max-width=""
    outlined
  >
  オファーをしましょう！！！
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
      この時間でオファー！
      </v-btn>
<v-card
    class="mx-auto"
    max-width=""
    tile
  >
    <v-list dense>
      <v-subheader>Timeの登録一覧</v-subheader>
      <v-list-item-group
        v-for="(time, index) in formedTargetTimes"
          :key="index"
          color="primary"
      >
        <v-list-item
          
        >
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
    icon: 'mdi-clock',
    target: [],

    targetTimes: []
  }),

  computed: {
    stringStartTime() {
     return `${this.startTime.year}-${this.startTime.month}-${this.startTime.day}T${this.startTime.hour}:${this.startTime.minute}:00`
    },
    stringFinishTime() {
      return `${this.finishTime.year}-${this.finishTime.month}-${this.finishTime.day}T${this.finishTime.hour}:${this.finishTime.minute}:00`
    },
    formedTargetTimes() {
      const targetTimes = this.targetTimes.map(obj=> {
        const s = new Date(obj.start_time)
        const f = new Date(obj.finish_time)
        const newObject = {id: obj.id, formedTime: `${s.getFullYear()}年${s.getMonth() +1}月${s.getDate()}日${s.getHours()}時${s.getMinutes()}分から${f.getFullYear()}年${f.getMonth() +1}月${f.getDate()}日${f.getHours()}時${f.getMinutes()}分`}
        return newObject
      })
      return targetTimes
    }
  },
  
  created() {
    const myid = this.$route.params.id
    this.$axios.get(`http://localhost:3000/api/users/${myid}`).then((response) => {
      this.target = response.data.user
      // this.targetSkills = response.data.target_skills;
      this.targetTimes = response.data.target_times
    });
  },
 
  methods: {
    register() {
      this.$axios.post(`/api/host_requests/${this.target.id}`, {start_time: this.stringStartTime, finish_time: this.stringFinishTime},
      {headers: this.$cookies.get('authInfo')})
      .then((response) => {
        console.log('host_request成功', response.data)
        this.$router.push(`/host/${this.$store.state.myInfo.myInfo.myid}`)
      })
      .catch((error) => {
        console.log('host_request失敗', error)
      })
    }
  }

  
};

</script>
