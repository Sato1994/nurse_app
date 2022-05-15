export const state = () => ({
  rooms: [],
})

export const mutations = {
  saveRooms(state, rooms) {
    if (rooms) state.rooms = rooms
  },

  addRoom(state, payload) {
    state.rooms.push(payload)
  },

  removeRoom(state, payload) {
    const target = state.rooms.find(room => room.id === payload.id)
    const index = state.rooms.indexOf(target)
    state.rooms.splice(index, 1)
  },

  updateTime(state, payload) {
    const target = state.rooms.find(room => room.id === payload.room.id)
    if (target) {
      target.start_time = payload.room.start_time
      target.finish_time = payload.room.finish_time
    }
  },

  updateState(state, payload) {
    const target = state.rooms.find(room => room.id === payload.id)
    target.state = payload.state
  },

  reset(state) {
    state.rooms = []
  }
}

export const actions = {
  saveRooms({ commit }, rooms) {
    commit('saveRooms', rooms)
  },

  async createRoom({ dispatch, commit }, requestId) {
    try {
      const { data } = await this.$axios
        .post(
          '/api/rooms',
          {
            request_id: requestId,
          },
          { headers: this.$cookies.get('authInfo') }
        )
      dispatch('snackbar/setMessage', 'トークルームが作成されました。', { root: true })
      commit('issues/offers/removeOffer', requestId, { root: true })
      commit('addRoom', data.room)
      this.$router.push(`/rooms/${data.room.id}`)
    } catch {
    }
  },

}

export const getters = {
  rooms(state, getters) {
    return getters.formatting(state.rooms)
  },

  formatting: _ => (payload) => {
    return payload.map((obj) => {
      let s = new Date(obj.start_time)
      let f = new Date(obj.finish_time)
      // UTCを見る場合に差分プラスする
      if (process.server) {
        s = new Date(s.setHours(s.getHours() + 9))
        f = new Date(f.setHours(f.getHours() + 9))
      }
      const newObject = {
        id: obj.id,
        partnerName: obj.partner.name,
        partner: obj.partner,
        partnerMyid: obj.partner.myid,
        state: obj.state,
        startTime: {
          year: s.getFullYear(),
          month: s.getMonth() + 1,
          day: s.getDate(),
          hour: s.getHours(),
          minute: s.getMinutes(),
        },
        finishTime: {
          year: f.getFullYear(),
          month: f.getMonth() + 1,
          day: f.getDate(),
          hour: f.getHours(),
          minute: f.getMinutes(),
        }
      }
      return newObject
    })
  }
}