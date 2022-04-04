export const state = () => ({
  datePickerIsDisplay: false,
})

export const mutations = {
  displayDatePicker(state) {
    state.datePickerIsDisplay = true
  },

  hideDatePicker(state) {
    state.datePickerIsDisplay = false
  },
}

export const actions = {

}

export const getters = {
  datePicker(state) {
    return state.datePickerIsDisplay
  },
}