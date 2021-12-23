export const state = () => ({
  agreements: [],
})

export const mutations = {
  saveAgreements(state, agreements) {
    state.agreements = agreements
  },
  updateState(state, payload) {
    state.agreements.find(obj => obj.id === payload.id).state = payload.state
  },
}

export const actions = {
  saveAgreements({ commit }, agreements) {
    commit('saveAgreements', agreements)
  },
  updateState({ commit }, payload) {
    commit('updateState', payload)
  },
}

export const getters = {
  agreementsInProgress(state) {
    const agreements = state.agreements.filter((obj) => {
      return obj.state !== 'cancelled'
    })
    return agreements
  },

  agreementsOnCalendar(state) {
    const agreements = state.agreements.map((obj) => {
      const s = new Date(obj.start_time)
      const f = new Date(obj.finish_time)
      const newObject = {
        id: obj.id,
        partnerName: obj.partner.name,
        partnerMyid: obj.partner.myid,
        start: `${s.getFullYear()}-${s.getMonth() + 1
          }-${s.getDate()}T${s.getHours()}:${s.getMinutes()}`,
        end: `${f.getFullYear()}-${f.getMonth() + 1
          }-${f.getDate()}T${f.getHours()}:${f.getMinutes()}`,
        name: "契約済み",
        color: 'red',
        dislayStart: `${s.getMonth() + 1
          }/${s.getDate()}  ${s.getHours()}:${s.getMinutes()}`,
        displayFinish: `${f.getMonth() + 1
          }/${f.getDate()}  ${f.getHours()}:${f.getMinutes()}`,
      }
      return newObject
    })
    return agreements
  }
}