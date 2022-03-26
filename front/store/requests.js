export const state = () => ({
  requests: [],
})

export const mutations = {
  saveRequests(state, requests) {
    state.requests = requests
  },

  addRequest(state, request) {
    state.requests.push(request)
  }
}

export const actions = {
  saveRequests({ commit }, requests) {
    commit('saveRequests', requests)
  },

  addRequest({ commit }, request) {
    commit('addRequest', request)
  },

  removeRequest({ commit, dispatch }, requestId) {
    commit('display/hideConfirm', null, { root: true })
    dispatch('snackbar/setMessage', 'リクエストを削除する機能を作る予定だよ！！', { root: true })

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
