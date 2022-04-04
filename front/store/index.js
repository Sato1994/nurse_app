export const actions = {
  async nuxtServerInit({ commit }) {
    if (this.$cookies.get('authInfo')) {
      await this.$axios
        .get(
          `/api/${this.$cookies.get('user')}s/${this.$cookies.get('myid')}`,
          { headers: this.$cookies.get('authInfo') }
        )
        .then((response) => {
          commit('info/saveInfo', response.data.info)
          commit('skills/saveSkills', response.data.skills)
          commit('times/saveTimes', response.data.times)
          commit('requests/saveRequests', response.data.requests)
          commit(
            'issues/agreements/saveAgreements',
            response.data.agreements
          )
          commit('offers/saveOffers', response.data.offers)
          commit('rooms/saveRooms', response.data.rooms)
        })
        .catch(() => {
          this.$cookies.removeAll()
        })
    }
  },
}

