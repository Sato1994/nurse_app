<template>
  <v-card class="mx-auto">
    <v-img
      height="250"
      src="http://www.okuzawa-eye.com/img-layout/photo_clinic_2018.jpg"
    ></v-img>

    <v-card-title
      >{{ target.name }}
      <v-chip small class="ma-2" text-color="white" :color="wantedChipColor">{{
        target.wanted === true ? '募集中' : '募集していません'
      }}</v-chip>
    </v-card-title>

    <v-card-text>
      <v-row align="center" class="mx-0">
        <v-rating
          :value="4.5"
          color="amber"
          dense
          half-increments
          readonly
          size="14"
        ></v-rating>

        <div class="grey--text ms-4">4.5 (413)</div>
      </v-row>

      <div class="my-4 text-subtitle-2">
        {{ target.address ? `${target.address}` : '住所を登録していません。' }}
      </div>

      <div>
        {{
          target.profile
            ? `${target.profile}`
            : 'プロフィールを登録していません。'
        }}
      </div>
    </v-card-text>

    <v-card-actions
      v-if="
        $cookies.get('user') === 'host' &&
        $store.state.info.info.myid === $route.params.id
      "
    >
      <v-btn
        class="ma-2"
        color="amber lighten-4"
        small
        depressed
        @click="$refs.edit.isDisplay = true"
      >
        <v-icon>mdi-cog-outline</v-icon>
      </v-btn>

      <v-btn
        class="ma-2"
        color="green lighten-4"
        small
        depressed
        @click="$refs.datePicker.isDisplay = true"
      >
        <v-icon>mdi-clock-plus-outline</v-icon>
      </v-btn>
    </v-card-actions>

    <v-divider class="mx-4"></v-divider>

    <Calendar :events="events" @request-button-click="jumpTargetTimes" />
    <DatePicker
      ref="datePicker"
      title="募集時間を追加"
      @register-button-click="createRecruitmentTime"
    />

    <v-divider class="mx-4"></v-divider>

    <v-card-title>就業に必須な技術</v-card-title>

    <v-card-text>
      <div>
        <v-chip
          v-for="(skill, i) in targetSkills"
          :key="i"
          class="ma-1"
          color="warning"
          small
        >
          {{ skill.name }}
        </v-chip>
      </div>
    </v-card-text>

    <v-card-actions
      v-if="
        $cookies.get('user') === 'host' &&
        $store.state.info.info.myid === $route.params.id
      "
    >
      <v-btn
        class="ma-2"
        color="amber lighten-4"
        small
        depressed
        @click="$refs.skillList.isDisplay = true"
      >
        <v-icon>mdi-plus-box-multiple-outline</v-icon>
      </v-btn>
    </v-card-actions>
    <Edit ref="edit" @edit-button-click="editInfo" />
    <SkillList
      ref="skillList"
      @add-button-click="addSkill"
      @remove-button-click="removeSkill"
    />
  </v-card>
</template>

<script>
import DatePicker from '@/components/dialog/DatePicker.vue'
import Edit from '@/components/dialog/Edit.vue'
import SkillList from '@/components/dialog/SkillList.vue'
import Calendar from '@/components/molecules/Calendar.vue'
export default {
  components: {
    DatePicker,
    Edit,
    SkillList,
    Calendar,
  },

  async asyncData({ route }) {
    try {
      const data = await axios.get(
        `http://web:3000/api/hosts/${route.params.id}`
      )
      const times = data.data.times.map((obj) => {
        const s = new Date(obj.start_time)
        const f = new Date(obj.finish_time)
        const newObject = {
          id: obj.id,
          start: `${s.getFullYear()}-${
            s.getMonth() + 1
          }-${s.getDate()}T${s.getHours()}:${s.getMinutes()}`,
          end: `${f.getFullYear()}-${
            f.getMonth() + 1
          }-${f.getDate()}T${f.getHours()}:${f.getMinutes()}`,
          name: '募集中',
          color: 'green',
          dislayStart: `${
            s.getMonth() + 1
          }/${s.getDate()}  ${s.getHours()}:${s.getMinutes()}`,
          displayFinish: `${
            f.getMonth() + 1
          }/${f.getDate()}  ${f.getHours()}:${f.getMinutes()}`,
        }
        return newObject
      })
      return {
        target: data.data.info,
        targetSkills: data.data.skills,
        events: times,
      }
    } catch (error) {
      console.log('asyncdataエラー', error)
    }
  },

  data: () => ({
    target: [],
    targetSkills: [],
    items: [
      { title: 'お相手のページへ移動' },
      { title: '契約時間の変更申請' },
      { title: '契約の取り消し申請' },
    ],
    events: [],
  }),

  computed: {
    formedTargetAgreements() {
      const targetAgreements = this.$store.getters[
        'agreements/agreementsInProgress'
      ].map((obj) => {
        const s = new Date(obj.start_time)
        const f = new Date(obj.finish_time)
        const newObject = {
          id: obj.id,
          room: obj.room,
          user: obj.user,
          formedAgreement: `${s.getFullYear()}年${
            s.getMonth() + 1
          }月${s.getDate()}日${s.getHours()}時${s.getMinutes()}分から${f.getFullYear()}年${
            f.getMonth() + 1
          }月${f.getDate()}日${f.getHours()}時${f.getMinutes()}分`,
        }
        return newObject
      })
      return targetAgreements
    },

    wantedChipColor() {
      return this.target.wanted === true ? 'green' : 'red'
    },
  },

  created() {
    if (
      this.$cookies.get('user') === 'host' &&
      this.$route.params.id === this.$store.state.info.info.myid
    ) {
      const requests = this.$store.getters['requests/requestsOnCalendar']
      this.events = this.events.concat(requests)
    }
  },

  methods: {
    addSkill(skill) {
      this.targetSkills.push(skill)
    },

    removeSkill(skill) {
      const target = this.targetSkills.find(
        (targetSkill) => targetSkill.id === skill.id
      )
      const index = this.targetSkills.indexOf(target)
      this.targetSkills.splice(index, 1)
    },

    editInfo(copiedInfo) {
      this.$set(this.target, 'name', copiedInfo.name)
      this.$set(this.target, 'address', copiedInfo.address)
      this.$set(this.target, 'profile', copiedInfo.profile)
      this.$set(this.target, 'wanted', copiedInfo.wanted)
    },

    jumpTargetTimes(recruitmentTimeId) {
      this.$router.push({
        path: `/host/${this.target.myid}/times`,
        query: { t: recruitmentTimeId },
      })
    },

    createRecruitmentTime(startTime, finishTime) {
      this.$axios
        .post(
          '/api/recruitment_times',
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

    selectedMenu(i, agreementId, roomId, userMyId) {
      switch (i) {
        case 0:
          this.$router.push(`/user/${userMyId}`)
          break
        case 1:
          this.$axios
            .patch(
              `/api/agreements/${agreementId}`,
              {},
              {
                headers: this.$cookies.get('authInfo'),
              }
            )
            .then((response) => {
              console.log(response)
              this.$router.push(`/rooms/${roomId}`)
            })
            .catch((error) => {
              console.log(error)
            })
          break
        case 2:
          console.log('2ですよ')
          break
        default:
          console.log('menuClickでエラー')
      }
    },
  },
}
</script>
