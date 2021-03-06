export const state = () => ({
  room: {
    id: null,
    start_time: null,
    finish_time: null,
    state: null,
    closed: null,
    na: null,
    user_messages: [],
    host_messages: [],
    partner: {
      id: null,
      name: null,
      myid: null,
      image: {
        url: null,
      },
      phone: null,
    }
  },

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
    state.room.start_time = payload.room.start_time
    state.room.finish_time = payload.room.finish_time
  },

  removeRoom(state) {
    state.room.id = null
    state.room.start_time = null
    state.room.finish_time = null
    state.room.state = null
    state.room.closed = null
    state.room.na = null
    state.room.user_message = []
    state.room.host_message = []
    state.room.partner.id = null
    state.room.partner.name = null
    state.room.partner.myid = null
    state.room.partner.image.url = null
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
    if (data.agreement) {
      commit('agreement/saveAgreement', data.agreement, { root: true })
    } else {
      commit('agreement/resetAgreement', {}, { root: true })
    }
  },

  async sendMessage({ commit, rootState }, payload) {
    try {
      const { data } = await this.$axios
        .post(
          `/api/${this.$cookies.get('user')}_messages`,

          {
            message: payload.message,
            room_id: payload.roomId
          },
          { headers: this.$cookies.get('authInfo') }
        )
      rootState.info.me === 'user'
        ? commit('addUserMessage', { user_message: data.user_message })
        : commit('addHostMessage', { host_message: data.host_message })
    } catch { }
  },


  async updateTime({ commit, dispatch }, payload) {
    try {
      const { data } = await this.$axios
        .patch(
          `/api/rooms/update_room_time`,
          {
            room_id: payload.roomId,
            start_time: `${payload.startTime.year}-${payload.startTime.month}-${payload.startTime.day}T${payload.startTime.hour}:${payload.startTime.minute}`,
            finish_time: `${payload.finishTime.year}-${payload.finishTime.month}-${payload.finishTime.day}T${payload.finishTime.hour}:${payload.finishTime.minute}`,
          },
          { headers: this.$cookies.get('authInfo') }
        )
      commit('updateTime', data)
      commit('issues/rooms/updateTime', data, { root: true })

      dispatch(
        'snackbar/setMessage',
        '????????????????????????????????????', { root: true }
      )
    } catch { }
  },

  async updateState({ commit, getters }) {
    const room = getters.room
    switch (room.state) {
      case this.$cookies.get('user') === 'user' ? 'host' : 'user':
        // agreement create
        // ????????? agreement?????????

        try {
          let config = {}
          switch (this.$cookies.get('user')) {
            case 'user':
              config = {
                host_id: room.partnerId,
                room_id: room.id,
                start_time: `${room.startTime.year}-${room.startTime.month}-${room.startTime.day}T${room.startTime.hour}:${room.startTime.minute}`,
                finish_time: `${room.finishTime.year}-${room.finishTime.month}-${room.finishTime.day}T${room.finishTime.hour}:${room.finishTime.minute}`,
              }
              break
            case 'host':
              config = {
                user_id: room.partnerId,
                room_id: room.id,
                start_time: `${room.startTime.year}-${room.startTime.month}-${room.startTime.day}T${room.startTime.hour}:${room.startTime.minute}`,
                finish_time: `${room.finishTime.year}-${room.finishTime.month}-${room.finishTime.day}T${room.finishTime.hour}:${room.finishTime.minute}`,
              }
              break
          }
          const agreementRes = await this.$axios
            .post(`/api/agreements`,
              config,
              { headers: this.$cookies.get('authInfo') }
            )
          commit('agreement/saveAgreement', agreementRes.data.agreement, { root: true })
          commit('issues/agreements/updateState', agreementRes.data.agreement, { root: true })
          commit('issues/agreements/updateTime', agreementRes.data.agreement, { root: true })

          const { data } = await this.$axios
            .patch(
              `/api/rooms/update_room_state`,
              { room_id: room.id },
              {
                headers: this.$cookies.get('authInfo'),
              }
            )

          commit('updateState', { state: data.state })
          commit('issues/rooms/removeRoom', { id: room.id }, { root: true })
        } catch {
        }
        break
      default:
        try {
          const { data } = await this.$axios
            .patch(
              `/api/rooms/update_room_state`,
              { room_id: room.id },
              { headers: this.$cookies.get('authInfo') }
            )
          commit('updateState', { state: data.state })
        } catch {
        }
    }
  },

  async cancellRoom({ state, dispatch, commit }) {
    const { data } = await this.$axios
      .patch(
        '/api/rooms/cancell_room',
        { id: state.room.id },
        { headers: this.$cookies.get('authInfo') }
      )
    commit('issues/rooms/updateState', { id: state.room.id, state: data.state }, { root: true })
    commit('updateState', { state: data.state })
    dispatch('snackbar/setMessage', '???????????????????????????????????????', { root: true })
  },

  async leaveRoom({ commit, state, rootState }) {
    try {
      await this.$axios
        .patch(
          '/api/rooms/leave',
          { id: state.room.id },
          { headers: this.$cookies.get('authInfo') }
        )
      commit('issues/rooms/removeRoom', { id: state.room.id }, { root: true })
      this.$router.push(`/${this.$cookies.get('user')}/${rootState.info.info.myid}`)
    } catch {
    }
  },
}

export const getters = {
  room(state, _, rootState) {

    let startTime = new Date(state.room.start_time)
    let finishTime = new Date(state.room.finish_time)
    // UTC???????????????????????????????????????
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
      partnerAddress: state.room.partner.address,
      partnerLng: state.room.partner.lng,
      partnerLat: state.room.partner.lat,
      partnerPhone: state.room.partner.phone,
      state: state.room.state,
      closed: state.room.closed,
      startTime: newStartTime,
      finishTime: newFinishTime,
      messages
    }
    return returnObject
  }
}