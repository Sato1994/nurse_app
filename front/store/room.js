export const state = () => ({
  room: [],

})
export const mutations = {
  saveRoom(state, payload) {
    state.room = payload
  },

  addUserMessage(state, payload) {
    state.room.user_messages.push(payload.user_message)
  },

  addHostMessage(state, payload) {
    state.room.host_messages.push(payload.host_message)
  },

  updateTime(state, payload) {
    state.room.star_time = payload.room.start_time
    state.room.finish_time = payload.room.finish_time
  },

  updateState(state, payload) {
    state.room.state = payload.state
  },

  updateClosed(state, payload) {
    state.room.closed = payload.closed
  },
}

export const actions = {
  async getRoom({ commit }, payload) {
    const { data } = await this.$axios.get(`/api/rooms/${payload.roomId}`, {
      headers: this.$cookies.get('authInfo'),
    })
    commit('saveRoom', data.room)
    if (data.agreement !== null) {
      commit('agreement/saveAgreement', data.agreement, { root: true })
    }
  },

  async sendMessage({ commit, rootState }, payload) {
    const { data } = await this.$axios
      .post(
        `/api/${this.$cookies.get('user')}_messages/${payload.roomId}`,
        { message: payload.message },
        { headers: this.$cookies.get('authInfo') }
      )
    rootState.info.me === 'user'
      ? commit('addUserMessage', { user_message: data.user_message })
      : commit('addHostMessage', { host_message: data.host_message })
  },

  async updateTime({ commit, dispatch }, payload) {
    const { data } = await this.$axios
      .patch(
        `/api/rooms/${payload.roomId}/update_room_time`,
        {
          start_time: `${payload.startTime.year}-${payload.startTime.month}-${payload.startTime.day}T${payload.startTime.hour}:${payload.startTime.minute}`,
          finish_time: `${payload.finishTime.year}-${payload.finishTime.month}-${payload.finishTime.day}T${payload.finishTime.hour}:${payload.finishTime.minute}`,
        },
        { headers: this.$cookies.get('authInfo') }
      )
    commit('updateTime', data)

    dispatch(
      'snackbar/setMessage',
      '希望時間を変更しました。', { root: true }
    )
  },

  async updateState({ commit, state }) {
    switch (state.room.state) {
      case this.$cookies.get('user') === 'user' ? 'host' : 'user': {
        // agreement create
        await this.$axios
          .post(
            `/api/agreements/${this.$cookies.get('user') === 'user' ? 'host' : 'user'
            }/${state.room.partnerId}`,
            {
              room_id: state.room.id,
              start_time: `${state.room.startTime.year}-${state.room.startTime.month}-${state.room.startTime.day}T${state.room.startTime.hour}:${state.room.startTime.minute}`,
              finish_time: `${state.room.finishTime.year}-${state.room.finishTime.month}-${state.room.finishTime.day}T${state.room.finishTime.hour}:${state.room.finishTime.minute}`,
            },
            {
              headers: this.$cookies.get('authInfo'),
            }
          )
        // 成功したらstate変更
        const { data } = await this.$axios
          .patch(
            `/api/rooms/${state.room.id}/update_room_state`,
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
            `/api/rooms/${state.room.id}/update_room_state`,
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
        { id: state.room.id },
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
  room(state, _, rootState) {

    let startTime = new Date(state.room.start_time)
    let finishTime = new Date(state.room.finish_time)
    // UTCを見る場合に差分プラスする
    if (process.server) {
      startTime = new Date(startTime.setHours(startTime.getHours() + 9))
      finishTime = new Date(finishTime.setHours(finishTime.getHours() + 9))
    }

    const newStartTime = {
      year: startTime.getFullYear(),
      month: startTime.getMonth() + 1,
      day: startTime.getDate(),
      hour: startTime.getHours(),
      minute: startTime.getMinutes()
    }

    const newFinishTime = {
      year: finishTime.getFullYear(),
      month: finishTime.getMonth() + 1,
      day: finishTime.getDate(),
      hour: finishTime.getHours(),
      minute: finishTime.getMinutes()
    }

    let userName = ''
    let userImage = ''
    let hostName = ''
    let hostImage = ''

    if (rootState.info.me === 'user') {
      userName = rootState.info.info.name
      userImage = rootState.info.info.image.url
      hostName = state.room.partner.name
      hostImage = state.room.partner.image.url

    } else if (rootState.info.me === 'host') {
      userName = state.room.partner.name
      userImage = state.room.partner.image.url
      hostName = rootState.info.info.name
      hostImage = rootState.info.info.image.url
    }

    const userMessages = state.room.user_messages.map((obj) => {
      const newObject = {
        message: obj.message,
        createdAt: obj.created_at,
        name: userName,
        image: userImage
      }
      return newObject
    })

    const hostMessages = state.room.host_messages.map((obj) => {
      const newObject = {
        message: obj.message,
        createdAt: obj.created_at,
        name: hostName,
        image: hostImage
      }
      return newObject
    })


    const messages = userMessages.concat(hostMessages).slice().sort((a, b) => {
      return new Date(b.createdAt) - new Date(a.createdAt)
    })

    const returnObject = {
      id: state.room.id,
      partnerId: state.room.partner.id,
      partnerName: state.room.partner.name,
      partnerMyid: state.room.partner.myid,
      state: state.room.state,
      closed: state.room.closed,
      startTime: newStartTime,
      finishTime: newFinishTime,
      messages
    }
    return returnObject
  }
}