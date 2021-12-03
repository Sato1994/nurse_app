export const state = () => ({
  times: []
})

export const mutations = {
  saveTimes(state, times) {
    state.times = times
  }
}

export const actions = {
  saveTimes({ commit }, times) {
    commit('saveTimes', times)
  },
}

export const getters = {
  times(state) {
    return state.times
  }
}