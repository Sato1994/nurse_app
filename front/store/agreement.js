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
  }
}

export const actions = {

}

export const getters = {
  agreement(state) {
    return state
  },

}