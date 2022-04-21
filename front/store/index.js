export const actions = {
  async nuxtServerInit({ commit }) {
    if (this.$cookies.get('authInfo')) {
      await this.$axios
        .get(
          `/api/${this.$cookies.get('user')}s/${this.$cookies.get('myid')}`,
          { headers: this.$cookies.get('authInfo') }
        )
        .then((response) => {

          switch (this.$cookies.get('user')) {
            case 'user':
              commit('info/iAmUser', null, { root: true })
              break
            case 'host':
              commit('info/iAmHost', null, { root: true })
              break
          }

          commit('info/saveInfo', response.data.info)
          commit('skills/saveSkills', response.data.skills)
          commit('issues/times/saveTimes', response.data.times)
          commit('issues/requests/saveRequests', response.data.requests)
          commit(
            'issues/agreements/saveAgreements',
            response.data.agreements
          )
          commit('issues/offers/saveOffers', response.data.offers)
          commit('issues/rooms/saveRooms', response.data.rooms)
        })
        .catch(() => {
          this.$cookies.removeAll()
        })
    }
  },
}

