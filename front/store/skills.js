export const state = () => ({
  skills: [],
  allSkills: [],
})

export const mutations = {
  saveSkills(state, skills) {
    state.skills = skills
  },
  addNewSkill(state, newSkill) {
    state.skills.push(newSkill)
  },
  removeSkill(state, selectedSkill) {
    const target = state.skills.find(skill => skill.id === selectedSkill.id)
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
  removeSkill({ commit }, selectedSkill) {
    commit('removeSkill', selectedSkill)
  },
}

export const getters = {
  skills(state) {
    return state.skills
  },
}
