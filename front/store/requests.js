export const state = () => ({
  requests: [],
})

export const mutations = {
  saveRequests(state, requests) {
    state.requests = requests
  },

  addRequest(state, request) {
    state.requests.push(request)
  }
}

export const actions = {
  saveRequests({ commit }, requests) {
    commit('saveRequests', requests)
  },

  addRequest({ commit }, request) {
    commit('addRequest', request)
  }
}

export const getters = {
  requests(state) {
    return state.requests
  },
}
