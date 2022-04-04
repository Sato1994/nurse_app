export const state = () => ({
  editIsDisplay: false,
})

export const mutations = {
  displayEdit(state) {
    state.editIsDisplay = true
  },

  hideEdit(state) {
    state.editIsDisplay = false
  },
}

export const actions = {

}

export const getters = {

}