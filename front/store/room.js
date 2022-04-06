export const state = () => ({
  id: null,
  partnerId: null,
  partnerMyid: null,
  partnerName: null,
  state: null,
  closed: null,
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
  messages: []

})
export const mutations = {
  saveRoom(state, payload) {
    state.id = payload.id
    state.partnerId = payload.partner.id
    state.partnerName = payload.partner.name
    state.partnerMyid = payload.partner.myid
    state.state = payload.state
    state.closed = payload.closed

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

    let messages = payload.user_messages
    messages = messages.concat(payload.host_messages).slice().sort((a, b) => {
      return new Date(b.created_at) - new Date(a.created_at)
    })
    state.messages = messages
  },

  addMessage(state, payload) {
    state.messages.unshift(payload.message)
  },

  updateTime(state, payload) {
    state.startTime = payload.startTime
    state.finishTime = payload.finishTime
  },

  updateState(state, payload) {
    state.state = payload.state
  },

  updateClosed(state, payload) {
    state.closed = payload.closed
  },
}

export const actions = {
  async getRoom({ commit }, payload) {
    const { data } = await this.$axios.get(`/api/rooms/${payload.roomId}`, {
      headers: this.$cookies.get('authInfo'),
    })
    commit('saveRoom', data)
  },

  async sendMessage({ commit }, payload) {
    const { data } = await this.$axios
      .post(
        `/api/${this.$cookies.get('user')}_messages/${payload.roomId}`,
        { message: payload.message },
        { headers: this.$cookies.get('authInfo') }
      )
    commit('addMessage', { message: data })
    console.log(data)
  },

  async updateTime({ commit, dispatch }, payload) {
    await this.$axios
      .patch(
        `/api/rooms/${payload.roomId}/update_room_time`,
        {
          start_time: `${payload.startTime.year}-${payload.startTime.month}-${payload.startTime.day}T${payload.startTime.hour}:${payload.startTime.minute}`,
          finish_time: `${payload.finishTime.year}-${payload.finishTime.month}-${payload.finishTime.day}T${payload.finishTime.hour}:${payload.finishTime.minute}`,
        },
        { headers: this.$cookies.get('authInfo') }
      )
    commit('updateTime', payload)
    dispatch(
      'snackbar/setMessage',
      '希望時間を変更しました。', { root: true }
    )
  },

  async updateState({ commit, state }) {
    switch (state.state) {
      case this.$cookies.get('user') === 'user' ? 'host' : 'user': {
        // agreement create
        await this.$axios
          .post(
            `/api/agreements/${this.$cookies.get('user') === 'user' ? 'host' : 'user'
            }/${state.partnerId}`,
            {
              room_id: state.id,
              start_time: `${state.startTime.year}-${state.startTime.month}-${state.startTime.day}T${state.startTime.hour}:${state.startTime.minute}`,
              finish_time: `${state.finishTime.year}-${state.finishTime.month}-${state.finishTime.day}T${state.finishTime.hour}:${state.finishTime.minute}`,
            },
            {
              headers: this.$cookies.get('authInfo'),
            }
          )
        // 成功したらstate変更
        const { data } = await this.$axios
          .patch(
            `/api/rooms/${state.id}/update_room_state`,
            {},
            {
              headers: this.$cookies.get('authInfo'),
            }
          )
        commit('updateState', { state: data.state })
      }
        break
      default: {
        const { data } = await this.$axios
          .patch(
            `/api/rooms/${state.id}/update_room_state`,
            {},
            {
              headers: this.$cookies.get('authInfo'),
            }
          )
        commit('updateState', { state: data.state })
      }
    }
  },

  async cancellRoom({ dispatch, commit, state, rootState }) {
    const { data } = await this.$axios
      .patch(
        '/api/rooms/cancell_room',
        { id: state.id },
        { headers: this.$cookies.get('authInfo') }
      )
    commit('updateClosed', { closed: data.closed })
    commit('updateState', { state: data.state })
    dispatch('snackbar/setMessage', 'トークルームを削除しました。', { root: true })
    this.$router.push(
      `/${this.$cookies.get('user')}/${rootState.info.info.myid}`
    )
  },
}

export const getters = {
  room(state) {
    return state
  }
}