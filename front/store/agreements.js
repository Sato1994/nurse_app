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

  cancellAgreement({ commit, dispatch }, payload) {
    return this.$axios
      .patch(
        '/api/agreements/cancell',
        { id: payload.agreementId, comment: payload.comment },
        { headers: this.$cookies.get('authInfo') }
      )
      .then(() => {
        dispatch(
          'snackbar/setMessage',
          '契約をキャンセルしました。', { root: true }
        )
        dispatch('agreements/updateState', {
          id: payload.agreementId,
          state: 'cancelled',
        },
          { root: true })
        this.$router.push(`/rooms/${payload.roomId}`)
        commit('display/hideConfirm', null, { root: true })
      })
  },
}

export const getters = {
  agreementsInProgress(state) {
    const filter = state.agreements.filter((obj) => {
      return obj.state !== ('cancelled' || 'finished')
    })
    const agreements = filter.map((obj) => {
      const s = new Date(obj.start_time)
      const f = new Date(obj.finish_time)
      const newObject = {
        id: obj.id,
        roomId: obj.room.id,
        state: obj.state,
        partner: obj.partner,
        partnerName: obj.partner.name,
        partnerMyid: obj.partner.myid,
        partnerPhone: obj.partner.phone,
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