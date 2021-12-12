export const state = () => ({
  info: [],
})

export const mutations = {
  saveInfo(state, info) {
    state.info = info
  },
  logout(state) {
    state.info = []
  },
}

export const actions = {
  saveInfo({ commit }, info) {
    commit('saveInfo', info)
  },
  logout({ commit }) {
    commit('logout')
  },
}

export const getters = {
  info(state) {
    return state.info
  },
}