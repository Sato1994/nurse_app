export default {
  namespaced: true,

  state() {
    return {
      allSkills: {}
    }
  },

  mutations: {
    saveAllSkills(state, allSkills) {
      state.allSkills = allSkills
    },
  },
  actions: {
    saveAllSkills(context, allSkills) {
      context.commit('saveAllSkills', allSkills)
    },
  },

  getters: {
    getAllSkills: (state) => state.allSkills
  },
}