export const state = () => ({
  skills: [],
})

export const mutations = {
  saveSkills(state, skills) {
    state.skills = skills
  },

  addNewSkill(state, newSkill) {
    state.skills.push(newSkill)
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

  addNewSkill({ commit }, newSkill) {
    commit('addNewSkill', newSkill)
  },

  removeSkill({ commit }, payload) {
    commit('removeSkill', payload)
  },
}

export const getters = {

  skills(state) {
    return state.skills
  },
}
