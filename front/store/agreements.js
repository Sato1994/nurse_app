export const state = () => ({
  agreements: [],
})

export const mutations = {
  saveAgreements(state, agreements) {
    state.agreements = agreements
  },
  updateState(state, payload) {
    state.agreements.find(obj => obj.id === payload.id).state = payload.state
  },
}

export const actions = {
  saveAgreements({ commit }, agreements) {
    commit('saveAgreements', agreements)
  },
  updateState({ commit }, payload) {
    commit('updateState', payload)
  },
}

export const getters = {
  agreementsInProgress(state) {
    const agreements = state.agreements.filter((obj) => {
      return obj.state !== 'cancelled'
    })
    return agreements
  },
}