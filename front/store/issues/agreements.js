export const state = () => ({
  agreements: [],
})

export const mutations = {
  saveAgreements(state, agreements) {
    if (agreements) state.agreements = agreements
  },

  updateState(state, payload) {
    const target = state.agreements.find(agreement => agreement.id === payload.id)
    if (target) {
      target.state = payload.state
    } else {
      state.agreements.push(payload)
    }
  },

  updateTime(state, payload) {
    const target = state.agreements.find(agreement => agreement.id === payload.id)
    if (target) {
      target.start_time = payload.start_time
      target.finish_time = payload.finish_time
    } else {
      state.agreements.push(payload)
    }
  },

  removeAgreement(state, payload) {
    const target = state.agreements.find(agreement => agreement.id === payload.id)
    const index = state.agreements.indexOf(target)
    state.agreements.splice(index, 1)
  },

  reset(state) {
    state.agreements = []
  }
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
        commit('dialog/confirm/hideConfirm', null, { root: true })
      })
  },
}

export const getters = {
  checkAgreementsState: _ => (payload) => {
    const now = new Date()
    const laterHours6 = new Date().setHours(new Date().getHours() + 6)

    const before = []
    const during = []
    const requesting = []
    payload.agreements.forEach((obj) => {
      if (obj.state === 'before') { before.push(obj) }
      else if (obj.state === 'during') { during.push(obj) }
      else if (obj.state === 'requesting') { requesting.push(obj) }
    })

    // beforeは時刻から勤務時間より下回っているならtrue
    const beforeSome = before.some(
      (value) =>
        new Date(
          value.startTime.year,
          value.startTime.month - 1,
          value.startTime.day,
          value.startTime.hour,
          value.startTime.minute
        ) <= now
    )

    // duringは時刻がfinish_timeより下回っているならtrue
    const duringSome = during.some(
      (value) =>
        new Date(
          value.finishTime.year,
          value.finishTime.month - 1,
          value.finishTime.day,
          value.finishTime.hour,
          value.finishTime.minute
        ) <= now
    )

    // requestingは時刻が6時間より下回っているならtrue
    const requestingSome = requesting.some(
      (value) =>
        new Date(
          value.startTime.year,
          value.startTime.month - 1,
          value.startTime.day,
          value.startTime.hour,
          value.startTime.minute
        ) <= laterHours6
    )

    if (beforeSome || duringSome || requestingSome) { return true } else { return false }
  },

  inProgress(state, getters) {
    return getters.formatting(state.agreements)
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
        partnerPhone: obj.partner.phone,
        roomId: obj.room.id,
        state: obj.state,
        start: `${s.getFullYear()}-${s.getMonth() + 1
          }-${s.getDate()}T${s.getHours()}:${s.getMinutes()}`,
        end: `${f.getFullYear()}-${f.getMonth() + 1
          }-${f.getDate()}T${f.getHours()}:${f.getMinutes()}`,
        name: "契約済み",
        color: '#F26157',
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