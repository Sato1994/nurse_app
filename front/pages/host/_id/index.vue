<template>
  <v-container>
    <Home
      :target="target"
      :targetSkills="targetSkills"
      :requests="requests"
      :offers="offers"
      :agreements="agreements"
      :times="times"
      :reloadTimesPath="reloadTimesPath"
      :reloadRequestsPath="reloadRequestsPath"
      :reloadOffersPath="reloadOffersPath"
      @update-times="updateTimes"
      @update-requests="updateRequests"
      @update-offers="updateOffers"
      @update-agreements="updateAgreements"
    >
      <template #profile>
        <div class="my-4 text-subtitle-2">
          {{
            target.address ? `${target.address}` : '住所を登録していません。'
          }}
        </div>

        <div>
          {{
            target.profile
              ? `${target.profile}`
              : 'プロフィールを登録していません。'
          }}
        </div>

        <v-btn
          :to="{
            path: `/host/${target.myid}/history`,
          }"
          nuxt
          class="mt-3"
          rounded
          small
          depressed
          block
        >
          ヒストリー
        </v-btn>
      </template>
    </Home>
  </v-container>
</template>

<script>
import { mapState } from 'vuex'
import Home from '@/components/aggregations/Home.vue'

export default {
  components: {
    Home,
  },

  async asyncData({ route, $axios, store }) {
    if (route.path === `/host/${store.state.info.info.myid}`) {
      return {
        target: store.getters['info/info'],
        targetSkills: store.getters['skills/skills'],
        requests: store.getters['issues/requests/requestsOnCalendar'],
        offers: store.getters['issues/offers/offersOnCalendar'],
        agreements: store.getters['issues/agreements/inProgress'],
        times: store.getters['issues/times/timesOnCalendar'],
      }
    } else {
      const data = await $axios.get(`/api/hosts/${route.params.id}`)
      const times = data.data.times.map((obj) => {
        let s = new Date(obj.start_time)
        let f = new Date(obj.finish_time)
        // UTCを見る場合に差分プラスする
        if (process.server) {
          s = new Date(s.setHours(s.getHours() + 9))
          f = new Date(f.setHours(f.getHours() + 9))
        }
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
        times,
      }
    }
  },

  data: () => ({
    times: [],
    agreements: [],
    offers: [],
    requests: [],
    target: [],
  }),

  computed: {
    ...mapState('info', ['info']),

    reloadTimesPath() {
      return '/api/recruitment_times'
    },

    reloadRequestsPath() {
      return '/api/host_requests'
    },
    reloadOffersPath() {
      return '/api/user_requests'
    },
  },

  watch: {
    info(newValue) {
      this.target = newValue
    },
  },

  methods: {
    updateTimes(newValue) {
      this.times = newValue
    },

    updateRequests(newValue) {
      this.requests = newValue
    },

    updateOffers(newValue) {
      this.offers = newValue
    },
    updateAgreements(newValue) {
      this.agreements = newValue
    },
  },
}
</script>
