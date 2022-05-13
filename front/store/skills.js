export const state = () => ({
  skills: [],
})

export const mutations = {
  saveSkills(state, skills) {
    state.skills = skills
  },

  addSkill(state, skill) {
    state.skills.push(skill)
  },

  removeSkill(state, payload) {
    const target = state.skills.find(skill => skill.id === payload.id)
    const index = state.skills.indexOf(target)
    state.skills.splice(index, 1)
  },

  reset(state) {
    state.skills = []
  },
}

export const actions = {
  saveSkills({ commit }, skills) {
    commit('saveSkills', skills)
  },


  async addSkill({ commit }, payload) {
    try {

      const { data } = await this.$axios
        .post(
          `/api/${this.$cookies.get('user')}_skills`,
          { skill_id: payload.id },
          {
            headers: this.$cookies.get('authInfo'),
          }
        )
      commit('addSkill', data)
    } catch { }
  },

  async removeSkill({ commit }, payload) {
    try {
      const { data } = await this.$axios
        .delete(`/api/${this.$cookies.get('user')}_skills/${payload.id}`, {
          headers: this.$cookies.get('authInfo'),
        })
      commit('removeSkill', data)
    } catch { }
  },
}

export const getters = {

  skills(state) {
    return state.skills
  },

  skillsId(state) {
    const ids = []
    state.skills.forEach((obj) => {
      ids.push(obj.id)
    })
    return ids
  }

}
