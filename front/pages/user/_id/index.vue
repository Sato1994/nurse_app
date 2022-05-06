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

        <div class="pt-3">
          <v-btn depressed rounded nuxt @click="openSkillList">
            <div class="grey--text">苦手スキル {{ targetSkills.length }}</div>
          </v-btn>
        </div>

        <v-btn
          :to="{
            path: `/user/${target.myid}/history`,
          }"
          nuxt
          class="mt-3 grey--text"
          rounded
          small
          depressed
          block
        >
          ヒストリー
        </v-btn>
      </template>
    </Home>
    <SkillList
      :skillListDisplay="skillListDisplay"
      @close-skill-list-click="closeSkillList"
    >
      <template #description>
        選択した技術を必須に設定している病院は検索されなくなります
      </template>
    </SkillList>
  </v-container>
</template>

<script>
import { mapState } from 'vuex'
import SkillList from '@/components/dialog/SkillList.vue'
import Home from '@/components/aggregations/Home.vue'

export default {
  components: {
    SkillList,
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
    skillListDisplay: false,
  }),

  computed: {
    ...mapState('info', ['info']),

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

    openSkillList() {
      this.skillListDisplay = true
    },

    closeSkillList() {
      this.skillListDisplay = false
    },
  },
}
</script>