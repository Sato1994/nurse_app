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
}

export const actions = {
  saveSkills({ commit }, skills) {
    commit('saveSkills', skills)
  },


  addSkill({ commit }, payload) {
    this.$axios
      .post(
        `/api/skills/${payload.id}/${this.$cookies.get('user')}_skills`,
        {},
        {
          headers: this.$cookies.get('authInfo'),
        }
      )
      .then((response) => {
        commit('addSkill', response.data)
      })
  },

  removeSkill({ commit }, payload) {
    this.$axios
      .delete(`/api/${this.$cookies.get('user')}_skills/${payload.id}`, {
        headers: this.$cookies.get('authInfo'),
      })
      .then((response) => {
        commit('removeSkill', response.data)
      })
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
