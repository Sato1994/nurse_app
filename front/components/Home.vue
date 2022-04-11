<template>
  <v-card class="mx-auto">
    <!-- 節約中だよ。v-if="!target.address"に変えてね -->
    <v-img
      v-if="target.address"
      height="250"
      src="https://cdn.vuetifyjs.com/images/cards/cooking.png"
    ></v-img>
    <!-- 節約中だよ。  v-else に変えてね -->
    <template v-if="false">
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
      >{{ target.name }}{{ $store.state.info.info.name }}
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
        $route.path ===
        `/${$cookies.get('user')}/${$store.state.info.info.myid}`
      "
    >
      <v-btn
        class="ma-2"
        color="amber lighten-4"
        small
        depressed
        @click="displayEdit"
      >
        <v-icon>mdi-cog-outline</v-icon>
      </v-btn>

      <v-btn
        class="ma-2"
        color="green lighten-4"
        small
        depressed
        @click="displayDatePicker"
      >
        <v-icon>mdi-clock-plus-outline</v-icon>
      </v-btn>
    </v-card-actions>

    <v-card-actions v-if="$route.path === `/host/${target.myid}`">
      <v-btn
        class="ma-2"
        color="amber lighten-4"
        small
        depressed
        @click="$router.push(`/host/${target.myid}/rates`)"
      >
        <v-icon>mdi-star-outline</v-icon>
      </v-btn>
    </v-card-actions>

    <v-divider class="mx-4"></v-divider>

    <Calendar :events="events" />
    <DatePicker title="募集時間を登録" @register-button-click="createTime" />

    <v-divider class="mx-4"></v-divider>

    <v-card-title>NG技術</v-card-title>

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
      v-if="$route.path === `/user/${$store.state.info.info.myid}`"
    >
      <v-btn
        class="ma-2"
        color="amber lighten-4"
        small
        depressed
        @click="displaySkillList"
      >
        <v-icon>mdi-plus-box-multiple-outline</v-icon>
      </v-btn>
    </v-card-actions>
    <Edit />
    <SkillList />
  </v-card>
</template>


<script>
import { mapMutations, mapActions, mapGetters } from 'vuex'
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

  props: {
    target: {
      type: Object,
      default: null,
    },
    targetSkills: {
      type: Array,
      default: null,
    },
    requests: {
      type: Array,
      default: null,
    },
    offers: {
      type: Array,
      default: null,
    },
    agreements: {
      type: Array,
      default: null,
    },
    times: {
      type: Array,
      default: null,
    },
    reloadTimesPath: {
      type: String,
      default: null,
    },
  },

  data: () => ({
    items: [
      { title: 'お相手のページへ移動' },
      { title: '契約時間の変更申請' },
      { title: '契約の取り消し申請' },
    ],

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
    wantedChipColor() {
      return this.target.wanted === true ? 'green' : 'red'
    },

    ...mapGetters({ timesOnCalendar: 'issues/times/timesOnCalendar' }),

    maplocation() {
      return {
        lng: this.target.lng,
        lat: this.target.lat,
      }
    },

    events() {
      let newArray = []
      newArray = newArray.concat(this.times)
      if (
        this.$route.path ===
        `/${this.$cookies.get('user')}/${this.$store.state.info.info.myid}`
      ) {
        newArray = newArray.concat(this.requests)
        newArray = newArray.concat(this.offers)
        newArray = newArray.concat(this.agreements)
      }
      return newArray
    },
  },

  // 自分のページならstoreの更新を監視
  watch: {
    timesOnCalendar(newValue) {
      this.updateTimes(newValue)
    },
  },

  async mounted() {
    // 時間切れにより無効なものがあれば削除して更新
    const today = new Date()
    const unavailableTimes = this.times.some(
      (value) =>
        new Date(
          value.startTime.year,
          value.startTime.month - 1,
          value.startTime.day,
          value.startTime.hour,
          value.startTime.minute
        ) <= today.setHours(today.getHours() + 8)
    )
    if (unavailableTimes) {
      const { data } = await this.$axios.get(this.reloadTimesPath, {
        params: {
          id: this.target.id,
        },
      })
      if (
        // 自分のページならstoreを更新
        this.$route.path ===
        `/${this.$cookies.get('user')}/${this.$store.state.info.info.myid}`
      ) {
        this.$store.commit('issues/times/saveTimes', data.times)
      } else {
        // 他人のページなら親data更新
        const newTimes = this.$store.getters['issues/times/formatting'](
          data.times
        )
        this.updateTimes(newTimes)
      }
    }
  },

  methods: {
    ...mapMutations('dialog/skillList', ['displaySkillList']),
    ...mapMutations('dialog/datePicker', ['displayDatePicker']),
    ...mapMutations('dialog/edit', ['displayEdit']),
    ...mapActions('issues/times', ['createTime']),

    updateTimes(newValue) {
      this.$emit('update-times', newValue)
    },
  },
}
</script>