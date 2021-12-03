export const state = () => ({
  rooms: [],
})

export const mutations = {
  saveRooms(state, rooms) {
    state.rooms = rooms
  }
}

export const actions = {
  saveRooms({ commit }, rooms) {
    commit('saveRooms', rooms)
  }
}

export const getters = {
  rooms(state) {
    return state.rooms
  }
}