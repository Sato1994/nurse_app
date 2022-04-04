export const state = () => ({
  datePicker: {
    datePickerIsDisplay: false,
  },
})

export const mutations = {

  // DatePicker
  displayDatePicker(state) {
    state.datePicker.datePickerIsDisplay = true
  },

  hideDatePicker(state) {
    state.datePicker.datePickerIsDisplay = false
  },
}

export const actions = {
}

export const getters = {
  datePicker(state) {
    return state.datePicker
  },

}