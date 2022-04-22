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
      >{{ target.name }}
      <v-chip small class="ma-2" text-color="white" :color="wantedChipColor">{{
        target.wanted === true ? '募集中' : '募集していません'
      }}</v-chip>
    </v-card-title>

    <v-card-text>
      <v-btn
        v-if="$route.path === `/host/${target.myid}`"
        text
        class="pa-0"
        @click="$router.push(`/host/${target.myid}/rates`)"
      >
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
      </v-btn>
      <slot name="profile"></slot>
    </v-card-text>

    <v-divider class="mx-4"></v-divider>

    <Calendar :events="events" :wanted="target.wanted" />

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
    <SkillList />
  </v-card>
</template>


<script>
import { mapMutations, mapGetters } from 'vuex'
import SkillList from '@/components/dialog/SkillList.vue'
import Calendar from '@/components/molecules/Calendar.vue'
export default {
  components: {
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
    reloadRequestsPath: {
      type: String,
      default: null,
    },
    reloadOffersPath: {
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

    ...mapGetters('issues/times', ['timesOnCalendar']),
    ...mapGetters('issues/requests', ['requestsOnCalendar']),
    ...mapGetters('issues/offers', ['offersOnCalendar']),
    ...mapGetters('issues/agreements', ['inProgress']),

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

    requestsOnCalendar(newValue) {
      this.updateRequests(newValue)
    },

    offersOnCalendar(newValue) {
      this.updateOffers(newValue)
    },

    inProgress(newValue) {
      this.updateAgreements(newValue)
    },
  },

  async mounted() {
    // 時間切れにより無効なものがあれば削除して更新

    // timesのチェック
    const checkUnavailableTimes = this.$store.getters[
      'issues/times/checkUnavailableTimes'
    ]({ times: this.times })

    if (checkUnavailableTimes) {
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

    // requestsのチェック
    const checkUnavailableRequests = this.$store.getters[
      'issues/requests/checkUnavailableRequests'
    ]({ requests: this.requests })

    if (checkUnavailableRequests) {
      const { data } = await this.$axios.get(this.reloadRequestsPath, {
        params: {
          id: this.target.id,
        },
      })
      this.$store.commit('issues/requests/saveRequests', data.requests)
    }

    // offersのチェック
    const checkUnavailableOffers = this.$store.getters[
      'issues/offers/checkUnavailableOffers'
    ]({ offers: this.offers })

    if (checkUnavailableOffers) {
      const config = {
        headers: this.$cookies.get('authInfo'),
        params: {
          id: this.target.id,
        },
      }
      const { data } = await this.$axios.get(this.reloadOffersPath, config)
      this.$store.commit('issues/offers/saveOffers', data.offers)
    }

    // agreementsのチェック
    const checkAgreementsState = this.$store.getters[
      'issues/agreements/checkAgreementsState'
    ]({ agreements: this.agreements })

    if (checkAgreementsState) {
      const config = {
        headers: this.$cookies.get('authInfo'),
      }

      const { data } = await this.$axios.get(
        '/api/agreements/in_progress',
        config
      )
      this.$store.commit('issues/agreements/saveAgreements', data.agreements)
    }
  },

  methods: {
    ...mapMutations('dialog/skillList', ['displaySkillList']),
    ...mapMutations('dialog/datePicker', ['displayDatePicker']),

    updateTimes(newValue) {
      this.$emit('update-times', newValue)
    },
    updateRequests(newValue) {
      this.$emit('update-requests', newValue)
    },
    updateOffers(newValue) {
      this.$emit('update-offers', newValue)
    },
    updateAgreements(newValue) {
      this.$emit('update-agreements', newValue)
    },
  },
}
</script>