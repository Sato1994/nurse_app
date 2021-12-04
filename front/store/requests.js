export const state = () => ({
  requests: [],
})

export const mutations = {
  saveRequests(state, requests) {
    state.requests = requests
  },
}

export const actions = {
  saveRequests({ commit }, requests) {
    commit('saveRequests', requests)
  },
}

export const getters = {
  requests(state) {
    return state.requests
  },
}
