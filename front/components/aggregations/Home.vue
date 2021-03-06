<template>
  <v-card class="mx-auto">
    <div>
      <GmapMap
        v-if="maplocation.lng"
        map-type-id="roadmap"
        :center="maplocation"
        :zoom="13"
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
    </div>

    <v-card-title
      >{{ target.name }}
      <v-chip small class="ma-2" text-color="white" :color="wantedChipColor">{{
        target.wanted === true ? '募集中' : '募集していません'
      }}</v-chip>

      <v-spacer></v-spacer>

      <v-btn
        v-if="
          $route.path ===
          `/${$cookies.get('user')}/${$store.state.info.info.myid}`
        "
        @click="editDisplay = true"
        outlined
        >プロフィール編集
        <v-icon color="#B0C4B1" size="35">mdi-account-cog-outline</v-icon>
      </v-btn>
    </v-card-title>

    <v-card-text>
      <v-row
        v-if="$route.path === `/host/${target.myid}`"
        align="center"
        class="mx-0"
      >
        <v-rating
          :value="target.rate_average"
          color="amber"
          dense
          smasll
          half-increments
          readonly
          size="14"
        ></v-rating>
        <v-btn
          :to="{
            path: `/host/${target.myid}/rates`,
          }"
          class="pa-0"
          depressed
          rounded
          nuxt
        >
          <div class="grey--text ms-4">
            {{ target.rate_average }} （{{ target.rate_count }}）
          </div>
        </v-btn>
      </v-row>

      <slot name="profile"></slot>
    </v-card-text>

    <v-divider class="mx-4"></v-divider>

    <Calendar :events="events" :wanted="target.wanted" />
    <Edit
      :editDisplay="editDisplay"
      :info="target"
      @click-close-button="closeEdit"
    />
  </v-card>
</template>


<script>
import { mapMutations, mapGetters } from 'vuex'
import Calendar from '@/components/aggregations/Calendar.vue'
import Edit from '@/components/dialog/Edit.vue'
export default {
  components: {
    Calendar,
    Edit,
  },

  props: {
    target: {
      type: Object,
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

    editDisplay: false,
  }),

  head() {
    return {
      title: this.target.name,
    }
  },

  computed: {
    wantedChipColor() {
      return this.target.wanted === true ? '#B0C4B1' : '#DEDBD2'
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
    closeEdit() {
      this.editDisplay = false
    },
  },
}
</script>