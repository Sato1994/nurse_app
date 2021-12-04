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