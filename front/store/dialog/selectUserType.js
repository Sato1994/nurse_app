export const state = () => ({
  selectUserTypeIsDisplay: false,
})

export const mutations = {
  displaySelectUserType(state) {
    state.selectUserTypeIsDisplay = true
  },

  hideSelectUserType(state) {
    state.selectUserTypeIsDisplay = false
  },
}

export const actions = {

}

export const getters = {

}