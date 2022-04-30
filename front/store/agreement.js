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
  rate: {
    comment: null,
    star: null,
  }
})

export const mutations = {
  saveAgreement(state, payload) {
    state.id = payload.id
    state.state = payload.state

    if (payload.rate) {
      state.rate.comment = payload.rate.comment
      state.rate.star = payload.rate.star
    } else {
      state.rate.comment = null
      state.rate.star = null
    }

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

    state.rate.comment = null
    state.rate.star = null

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

  updateState(state, payload) {
    state.state = payload.state
  },

  saveRate(state, payload) {
    state.rate.comment = payload.comment
    state.rate.star = payload.star
  },
}

export const actions = {
  async editAgreement({ commit }, payload) {
    try {
      const { data } = await this.$axios
        .patch(
          `/api/agreements/${payload.agreementId}`,
          {},
          {
            headers: this.$cookies.get('authInfo'),
          }
        )
      commit('room/updateState', data.room, { root: true })
      commit('updateState', data.agreement)
      commit('issues/agreements/updateState', data.agreement, { root: true })
    } catch {
    }
  },
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