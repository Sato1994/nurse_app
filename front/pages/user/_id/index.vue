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
          <v-icon color="black">{{ sexIcon }}</v-icon>
          {{ target.sex === true ? '女性' : '男性' }}
        </div>

        <div class="my-4 text-subtitle-2">
          {{ target.age ? `年齢${target.age}歳` : '年齢を登録していません。' }}
        </div>

        <div class="my-4 text-subtitle-2">
          {{
            target.year
              ? `経験${target.year}年`
              : '経験年数を登録していません。'
          }}
        </div>

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
      </template>
    </Home>
  </v-container>
</template>

<script>
import Home from '@/components/Home.vue'

export default {
  components: {
    Home,
  },

  async asyncData({ route, $axios, store }) {
    if (route.path === `/user/${store.state.info.info.myid}`) {
      return {
        target: store.getters['info/info'],
        targetSkills: store.getters['skills/skills'],
        requests: store.getters['issues/requests/requestsOnCalendar'],
        offers: store.getters['issues/offers/offersOnCalendar'],
        agreements: store.getters['issues/agreements/inProgress'],
        times: store.getters['issues/times/timesOnCalendar'],
      }
    } else {
      const data = await $axios.get(`/api/users/${route.params.id}`)
      const times = store.getters['issues/times/formatting'](data.data.times)

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
    reloadTimesPath() {
      return '/api/free_times'
    },
    reloadRequestsPath() {
      return '/api/user_requests'
    },
    reloadOffersPath() {
      return '/api/host_requests'
    },
    sexIcon() {
      if (this.target.sex === true) {
        return 'mdi-face-woman'
      } else {
        return 'mdi-face-man'
      }
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