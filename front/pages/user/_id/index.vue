<template>
  <v-card class="mx-auto">
    <v-img
      v-if="!target.address"
      height="250"
      src="https://cdn.vuetifyjs.com/images/cards/cooking.png"
    ></v-img>
    <!-- 節約中 v-else に変えてね -->
    <template v-if="true">
      <GmapMap
        map-type-id="roadmap"
        :center="maplocation"
        :zoom="15"
        :style="{ width: '100%', height: '250px' }"
        :options="mapOptions"
      >
        <GmapMarker
          :title="target.address"
          :position="maplocation"
          :clickable="false"
          :draggable="false"
        />
      </GmapMap>
    </template>

    <v-card-title
      >{{ target.name }}
      <v-chip small class="ma-2" text-color="white" :color="wantedChipColor">{{
        target.wanted === true ? '募集中' : '募集していません'
      }}</v-chip>
    </v-card-title>

    <v-card-subtitle>
      {{ target.age ? `年齢${target.age}歳` : '年齢を登録していません。' }}
    </v-card-subtitle>

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
        {{ target.sex === true ? '女性' : '男性' }}
      </div>

      <div class="my-4 text-subtitle-2">
        {{
          target.year ? `経験${target.year}年` : '経験年数を登録していません。'
        }}
      </div>

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
        $cookies.get('user') === 'user' &&
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
      @register-button-click="createFreeTime"
    />

    <v-divider class="mx-4"></v-divider>

    <v-card-title>NG技術</v-card-title>

    <v-card-text>
      {{ times }}
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
        $cookies.get('user') === 'user' &&
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
import { mapState } from 'vuex'
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

  async asyncData({ route, $axios }) {
    try {
      const data = await $axios.get(`/api/users/${route.params.id}`)
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
          startTime: {
            year: s.getFullYear(),
            month: s.getMonth() + 1,
            day: s.getDate(),
            hour: s.getHours(),
            minute: s.getMinutes(),
          },
          finishTime: {
            year: f.getFullYear(),
            month: f.getMonth() + 1,
            day: f.getDate(),
            hour: f.getHours(),
            minute: f.getMinutes(),
          },
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

    mapOptions: {
      streetViewControl: false,
      mapTypeControl: false,
      zoomControl: false,
    },
  }),

  head() {
    return {
      title: this.target.name,
    }
  },

  computed: {
    ...mapState('times', ['times']),

    wantedChipColor() {
      return this.target.wanted === true ? 'green' : 'red'
    },

    maplocation() {
      return {
        lng: this.target.lng,
        lat: this.target.lat,
      }
    },
  },

  created() {
    if (
      this.$cookies.get('user') === 'user' &&
      this.$route.params.id === this.$store.state.info.info.myid
    ) {
      const requests = this.$store.getters['requests/requestsOnCalendar']
      const offers = this.$store.getters['offers/offersOnCalendar']
      const agreements = this.$store.getters['agreements/agreementsOnCalendar']
      this.events = this.events.concat(requests)
      this.events = this.events.concat(offers)
      this.events = this.events.concat(agreements)
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
      this.$set(this.target, 'age', copiedInfo.age)
      this.$set(this.target, 'year', copiedInfo.year)
      this.$set(this.target, 'sex', copiedInfo.sex)
      this.$set(this.target, 'wanted', copiedInfo.wanted)
    },

    jumpTargetTimes(freeTimeId) {
      this.$router.push({
        path: `/user/${this.target.myid}/times`,
        query: { t: freeTimeId },
      })
    },

    createFreeTime(startTime, finishTime) {
      this.$axios
        .post(
          '/api/free_times',
          {
            start_time: startTime,
            finish_time: finishTime,
          },
          { headers: this.$cookies.get('authInfo') }
        )
        .then((response) => {
          const s = new Date(response.data.start_time)
          const f = new Date(response.data.finish_time)
          const newObj = {
            id: response.data.id,
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
            startTime: {
              year: s.getFullYear(),
              month: s.getMonth() + 1,
              day: s.getDate(),
              hour: s.getHours(),
              minute: s.getMinutes(),
            },
            finishTime: {
              year: f.getFullYear(),
              month: f.getMonth() + 1,
              day: f.getDate(),
              hour: f.getHours(),
              minute: f.getMinutes(),
            },
          }
          this.events.push(newObj)
        })
    },
  },
}
</script>