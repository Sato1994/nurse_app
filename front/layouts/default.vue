<template>
  <v-app id="inspire">
    <Header />
    <v-main class="grey lighten-3">
      <v-container>
        <v-row>
          <SideMenu />
          <v-col>
            <v-sheet color="orange lighten-5" min-height="70vh" rounded="lg">
              <Nuxt />
            </v-sheet>
          </v-col>
        </v-row>
      </v-container>
    </v-main>
  </v-app>
</template>

<script>
import Header from '@/components/Header.vue'
import SideMenu from '@/components/SideMenu.vue'
export default {
  components: {
    Header,
    SideMenu,
  },

  async fetch() {
    if (this.$cookies.get('authInfo')) {
      await this.$axios
        .get(
          `http://web:3000/api/${this.$cookies.get(
            'user'
          )}s/${this.$cookies.get('myid')}`,
          { headers: this.$cookies.get('authInfo') }
        )
        .then((response) => {
          this.$store.dispatch('info/saveInfo', response.data.info)
          this.$store.dispatch('skills/saveSkills', response.data.skills)
          this.$store.dispatch('times/saveTimes', response.data.times)
          this.$store.dispatch('requests/saveRequests', response.data.requests)
          this.$store.dispatch(
            'agreements/saveAgreements',
            response.data.agreements
          )
          this.$store.dispatch('offers/saveOffers', response.data.offers)
          this.$store.dispatch('rooms/saveRooms', response.data.rooms)
        })
        .catch(() => {
          this.$cookies.removeAll()
        })
    }
  },
}
</script>