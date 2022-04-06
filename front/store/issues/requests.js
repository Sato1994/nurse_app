export const state = () => ({
  requests: [],
})

export const mutations = {
  saveRequests(state, requests) {
    state.requests = requests
  },

  addRequest(state, request) {
    state.requests.push(request)
  },

  removeRequest(state, id) {
    const target = state.requests.find(request => request.id === id)
    const index = state.requests.indexOf(target)
    state.requests.splice(index, 1)
  }
}

export const actions = {
  saveRequests({ commit }, requests) {
    commit('saveRequests', requests)
  },

  addRequest({ commit }, request) {
    commit('addRequest', request)
  },

  createRequest({ dispatch, commit }, payload) {
    this.$axios
      .post(
        `/api/${this.$cookies.get('user')}_requests/${payload.timeId}`,
        {
          start_time: `${payload.startTime.year}-${payload.startTime.month}-${payload.startTime.day}T${payload.startTime.hour}:${payload.startTime.minute}`,
          finish_time: `${payload.finishTime.year}-${payload.finishTime.month}-${payload.finishTime.day}T${payload.finishTime.hour}:${payload.finishTime.minute}`,
        },
        { headers: this.$cookies.get('authInfo') }
      )
      .then((response) => {
        dispatch(
          'snackbar/setMessage',
          'リクエストを送信しました。', { root: true }
        )
        commit('addRequest', response.data)
      })
  },

  removeRequest({ commit, dispatch }, requestId) {
    if (this.$cookies.get('user') === 'user') {
      this.$axios.delete(`/api/user_requests/${requestId}`,
        {
          headers: this.$cookies.get('authInfo')
        })
        .then(() => {
          commit('dialog/confirm/hideConfirm', null, { root: true })
          dispatch('snackbar/setMessage', 'リクエストを削除しました。', { root: true })
          commit('removeRequest', requestId)
        })
    } else {
      this.$axios.delete(`/api/host_requests/${requestId}`,
        {
          headers: this.$cookies.get('authInfo')
        })
        .then(() => {
          commit('dialog/confirm/hideConfirm', null, { root: true })
          dispatch('snackbar/setMessage', 'リクエストを削除しました。', { root: true })
          commit('removeRequest', requestId)
        })
    }
  },
}

export const getters = {
  requests(state) {
    return state.requests
  },

  requestsOnCalendar(state) {
    const requests = state.requests.map((obj) => {
      const s = new Date(obj.start_time)
      const f = new Date(obj.finish_time)
      const newObject = {
        id: obj.id,
        partnerName: obj.partner.name,
        partner: obj.partner,
        partnerMyid: obj.partner.myid,
        start: `${s.getFullYear()}-${s.getMonth() + 1
          }-${s.getDate()}T${s.getHours()}:${s.getMinutes()}`,
        end: `${f.getFullYear()}-${f.getMonth() + 1
          }-${f.getDate()}T${f.getHours()}:${f.getMinutes()}`,
        name: 'リクエスト中',
        color: 'lime',
        dislayStart: `${s.getMonth() + 1
          }/${s.getDate()}  ${s.getHours()}:${s.getMinutes()}`,
        displayFinish: `${f.getMonth() + 1
          }/${f.getDate()}  ${f.getHours()}:${f.getMinutes()}`,
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
    return requests

  },
}
