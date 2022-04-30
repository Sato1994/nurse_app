<template>
  <v-container>
    <RefineSearch
      :issues="true"
      text="offers"
      @refine-button-click="refineSearch"
    />
    <Offers />
    <v-img
      class="noContent"
      v-if="noContentDisplay"
      width="100"
      src="/image/no_content.png"
    ></v-img>
  </v-container>
</template>


<script>
import Offers from '@/components/issues/Offers.vue'
import RefineSearch from '@/components/props/RefineSearch.vue'
export default {
  components: {
    Offers,
    RefineSearch,
  },

  head: {
    title: '届いたリクエスト',
  },

  computed: {
    noContentDisplay() {
      return this.$store.state.issues.offers.offers.length === 0
    },
  },

  methods: {
    refineSearch(value) {
      switch (value) {
        case 'all':
          this.$router.push('/issues')
          break
        case 'times':
          this.$router.push('/issues/times')
          break
        case 'offers':
          this.$router.push('/issues/offers')
          break
        case 'requests':
          this.$router.push('/issues/requests')
          break
      }
    },
  },
}
</script>

<style scoped>
.noContent {
  position: fixed;
  top: 50%;
  left: 43%;
}
</style>