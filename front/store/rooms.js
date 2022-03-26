export const state = () => ({
  rooms: [],
})

export const mutations = {
  saveRooms(state, rooms) {
    state.rooms = rooms
  },

  updateClosed(state, payload) {
    state.rooms.find(obj => obj.id === payload.id).closed = payload.closed
  },

  updateState(state, payload) {
    state.rooms.find(obj => obj.id === payload.id).state = payload.state
  },

  addRoom(state, payload) {
    state.rooms.push(payload)
  }
}

export const actions = {
  saveRooms({ commit }, rooms) {
    commit('saveRooms', rooms)
  },

  updateClosed({ commit }, payload) {
    commit('updateClosed', payload)
  },

  updateState({ commit }, payload) {
    commit('updateState', payload)
  },
  addRoom({ commit }, room) {
    commit('addRoom', room)
  },

  createRoom({ dispatch }, payload) {
    this.$axios
      .post(
        `/api/rooms/${this.$cookies.get('user') === 'user' ? 'host' : 'user'
        }/${payload.partnerId}`,
        {
          start_time: payload.startTime,
          finish_time: payload.finishTime,
          request_id: payload.requestId,
        },
        { headers: this.$cookies.get('authInfo') }
      )
      .then((response) => {
        dispatch('snackbar/setMessage', 'トークルームが作成されました。', { root: true })
        dispatch('offers/removeOffer', payload.requestId, { root: true })
        dispatch('addRoom', response.data)
        this.$router.push(`/rooms/${response.data.id}`)
      })
  },
}

export const getters = {
  unclosedRooms: (state) => (value) => {
    if (value === 'user') {
      return state.rooms.filter(obj => obj.closed === 'na' || obj.closed === 'host')
    } else if (value === 'host') {
      return state.rooms.filter(obj => obj.closed === 'na' || obj.closed === 'user')
    } else {
      return null
    }
  },
}