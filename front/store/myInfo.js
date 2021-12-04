export const state = () => ({
  myInfo: [],
})

export const mutations = {
  saveMyInfo(state, myInfo) {
    state.myInfo = myInfo
  },
  logout(state) {
    state.myInfo = []
    state.mySkills = []
  },
}

export const actions = {
  saveMyInfo({ commit }, myInfo) {
    commit('saveMyInfo', myInfo)
  },
  logout({ commit }) {
    commit('logout')
  },
}

export const getters = {
  myInfo(state) {
    return state.myInfo
  },
}