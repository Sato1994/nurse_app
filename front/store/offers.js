export const state = () => ({
  offers: []
})

export const mutations = {
  saveOffers(state, offers) {
    state.offers = offers
  },
}

export const actions = {
  saveOffers({ commit }, offers) {
    commit('saveOffers', offers)
  },
}

export const getters = {
  offers(state) {
    return state.offers
  }
}
