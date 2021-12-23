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
  }
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
        start: `${s.getFullYear()}-${s.getMonth() + 1
          }-${s.getDate()}T${s.getHours()}:${s.getMinutes()}`,
        end: `${f.getFullYear()}-${f.getMonth() + 1
          }-${f.getDate()}T${f.getHours()}:${f.getMinutes()}`,
        name: 'リクエスト中',
        color: 'warning',
        dislayStart: `${s.getMonth() + 1
          }/${s.getDate()}  ${s.getHours()}:${s.getMinutes()}`,
        displayFinish: `${f.getMonth() + 1
          }/${f.getDate()}  ${f.getHours()}:${f.getMinutes()}`,

      }
      return newObject
    })
    return requests

  },
}
