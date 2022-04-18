export const state = () => ({
  id: null,
  state: null,
  startTime: {
    year: null,
    month: null,
    day: null,
    hour: null,
    minute: null,
  },
  finishTime: {
    year: null,
    month: null,
    day: null,
    hour: null,
    minute: null,
  },
})

export const mutations = {
  saveAgreement(state, payload) {
    state.id = payload.id
    state.state = payload.state

    const startTime = new Date(payload.start_time)
    state.startTime.year = startTime.getFullYear()
    state.startTime.month = startTime.getMonth() + 1
    state.startTime.day = startTime.getDate()
    state.startTime.hour = startTime.getHours()
    state.startTime.minute = startTime.getMinutes()

    const finishTime = new Date(payload.finish_time)
    state.finishTime.year = finishTime.getFullYear()
    state.finishTime.month = finishTime.getMonth() + 1
    state.finishTime.day = finishTime.getDate()
    state.finishTime.hour = finishTime.getHours()
    state.finishTime.minute = finishTime.getMinutes()
  },

  resetAgreement(state) {
    state.id = null
    state.state = null

    state.startTime.year = null
    state.startTime.month = null
    state.startTime.day = null
    state.startTime.hour = null
    state.startTime.minute = null

    state.finishTime.year = null
    state.finishTime.month = null
    state.finishTime.day = null
    state.finishTime.hour = null
    state.finishTime.minute = null
  },
}

export const actions = {

}

export const getters = {
  agreement(state) {
    return state
  },

  agreement6HoursLater(state, getters) {
    return getters.formattingTo6HoursLater(state)
  },

  formattingTo6HoursLater: _ => (payload) => {
    const start = new Date(payload.startTime.year, payload.startTime.month,
      payload.startTime.day, payload.startTime.hour, payload.startTime.minute)
    const hoursLater = new Date(start.setHours(start.getHours() - 6))
    return `${hoursLater.getMonth()}月${hoursLater.getDate()}日${hoursLater.getHours()}時`
  },


}