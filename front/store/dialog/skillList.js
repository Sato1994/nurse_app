export const state = () => ({
  skillListIsDisplay: false,
})

export const mutations = {
  displaySkillList(state) {
    state.skillListIsDisplay = true
  },

  hideSkillList(state) {
    state.skillListIsDisplay = false
  },
}

export const actions = {

}

export const getters = {

}