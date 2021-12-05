export const state = () => ({
  offers: []
})

export const mutations = {
  saveOffers(state, offers) {
    state.offers = offers
  },

  removeOffer(state, id) {
    const target = state.offers.find(offer => offer.id === id)
    const index = state.offers.indexOf(target)
    state.offers.splice(index, 1)
  }
}

export const actions = {
  saveOffers({ commit }, offers) {
    commit('saveOffers', offers)
  },

  removeOffer({ commit }, id) {
    commit('removeOffer', id)
  }
}

export const getters = {
  offers(state) {
    return state.offers
  }
}
