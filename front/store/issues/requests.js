export const state = () => ({
  requests: [],
})

export const mutations = {
  saveRequests(state, requests) {
    if (requests) state.requests = requests
  },

  addRequest(state, request) {
    state.requests.push(request)
  },

  removeRequest(state, id) {
    const target = state.requests.find(request => request.id === id)
    const index = state.requests.indexOf(target)
    state.requests.splice(index, 1)
  },

  reset(state) {
    state.requests = []
  }
}

export const actions = {
  saveRequests({ commit }, requests) {
    commit('saveRequests', requests)
  },

  addRequest({ commit }, request) {
    commit('addRequest', request)
  },

  async createRequest({ dispatch, commit }, payload) {
    let config = {}
    switch (this.$cookies.get('user')) {
      case 'user':
        config = {
          recruitment_time_id: payload.timeId,
          start_time: `${payload.startTime.year}-${payload.startTime.month}-${payload.startTime.day}T${payload.startTime.hour}:${payload.startTime.minute}`,
          finish_time: `${payload.finishTime.year}-${payload.finishTime.month}-${payload.finishTime.day}T${payload.finishTime.hour}:${payload.finishTime.minute}`,
        }
        break
      case 'host':
        config = {
          free_time_id: payload.timeId,
          start_time: `${payload.startTime.year}-${payload.startTime.month}-${payload.startTime.day}T${payload.startTime.hour}:${payload.startTime.minute}`,
          finish_time: `${payload.finishTime.year}-${payload.finishTime.month}-${payload.finishTime.day}T${payload.finishTime.hour}:${payload.finishTime.minute}`,
        }
        break
      default:
        dispatch('snackbar/setMessage', 'ログインしてください', { root: true })
        return
    }

    try {
      const { data } = await this.$axios
        .post(
          `/api/${this.$cookies.get('user')}_requests`,
          config,
          { headers: this.$cookies.get('authInfo') }
        )
      dispatch(
        'snackbar/setMessage',
        'リクエストを送信しました。', { root: true }
      )
      commit('addRequest', data)
    } catch { }
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

  requestsOnCalendar(state, getters) {
    return getters.formatting(state.requests)
  },

  checkUnavailableRequests: _ => (payload) => {
    const laterHours7 = new Date().setHours(new Date().getHours() + 7)
    return payload.requests.some(
      (value) =>
        new Date(
          value.startTime.year,
          value.startTime.month - 1,
          value.startTime.day,
          value.startTime.hour,
          value.startTime.minute
        ) <= laterHours7
    )
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
  }
}
