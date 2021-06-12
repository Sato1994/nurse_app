export default {
  namespaced: true,

  state() {
    return {
      target: {},
      skills: {},
    }
  },

  mutations: {
    saveTarget(state, target) {
      state.target = target
    },
    saveSkills(state, skills) {
      state.skills = skills
    }

  },

  actions: {
    saveTarget(context, target) {
      context.commit('saveTarget', target)
    },
    saveSkills(context, skills) {
      context.commit('saveSkills', skills)

    }
  },

  getters: {
    getTarget: state => {
      return state.target
    },
    // ここで諸々算出できる

    getSkills: state => {
      return state.skills
    },

  }

}