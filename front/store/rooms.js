export const state = () => ({
  rooms: [],
  // rooms: [
  //   {
  //     "id": 133,
  //     "created_at": "2022-04-18T17:02:37.858+09:00",
  //     "start_time": "2022-04-20T22:00:00.000+09:00",
  //     "finish_time": "2022-04-21T08:00:00.000+09:00",
  //     "state": "negotiating",
  //     "closed": "na",
  //     "partner": {
  //       "id": 46,
  //       "name": "東京都立孝之協同病院"
  //     }
  //   }
  // ]
})

export const mutations = {
  saveRooms(state, rooms) {
    state.rooms = rooms
  },

  addRoom(state, payload) {
    state.rooms.push(payload)
  },

  removeRoom(state, payload) {
    const target = state.rooms.find(room => room.id === payload.id)
    const index = state.rooms.indexOf(target)
    state.rooms.splice(index, 1)
  },
}

export const actions = {
  saveRooms({ commit }, rooms) {
    commit('saveRooms', rooms)
  },

  addRoom({ commit }, room) {
    commit('addRoom', room)
  },

  createRoom({ dispatch, commit }, requestId) {
    this.$axios
      .post(
        '/api/rooms',
        {
          request_id: requestId,
        },
        { headers: this.$cookies.get('authInfo') }
      )
      .then((response) => {
        dispatch('snackbar/setMessage', 'トークルームが作成されました。', { root: true })
        commit('issues/offers/removeOffer', requestId, { root: true })
        dispatch('addRoom', response.data.room)
        this.$router.push(`/rooms/${response.data.room.id}`)
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