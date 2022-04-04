export const state = () => ({
  datePicker: {
    datePickerIsDisplay: false,
  },

  selectUserType: {
    selectUserTypeIsDisplay: false,
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

  // SelectUserType
  displaySelectUserType(state) {
    state.selectUserType.selectUserTypeIsDisplay = true
  },

  hideSelectUserType(state) {
    state.selectUserType.selectUserTypeIsDisplay = false
  },
}

export const actions = {
}

export const getters = {
  datePicker(state) {
    return state.datePicker
  },

}