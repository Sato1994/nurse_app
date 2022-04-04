<template>
  <v-container>
    <Home :target="target" :targetSkills="targetSkills" :events="events" />
  </v-container>
</template>

<script>
import Home from '@/components/Home.vue'

export default {
  components: {
    Home,
  },

  async asyncData({ route, $axios, store }) {
    if (route.path === `/host/${store.state.info.info.myid}`) {
      let events = []
      const requests = store.getters['issues/requests/requestsOnCalendar']
      const offers = store.getters['issues/offers/offersOnCalendar']
      const agreements = store.getters['issues/agreements/agreementsOnCalendar']
      const times = store.getters['times/timesOnCalendar']
      events = events.concat(requests)
      events = events.concat(offers)
      events = events.concat(agreements)
      events = events.concat(times)

      return {
        target: store.getters['info/info'],
        targetSkills: store.getters['skills/skills'],
        events,
      }
    } else {
      try {
        const data = await $axios.get(`/api/hosts/${route.params.id}`)
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
    }
  },
}
</script>
