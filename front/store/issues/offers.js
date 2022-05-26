export const state = () => ({
  offers: []
})

export const mutations = {
  saveOffers(state, offers) {
    if (offers) state.offers = offers
  },

  removeOffer(state, id) {
    const target = state.offers.find(offer => offer.id === id)
    const index = state.offers.indexOf(target)
    state.offers.splice(index, 1)
  },

  reset(state) {
    state.offers = []
  }
}

export const actions = {
  saveOffers({ commit }, offers) {
    commit('saveOffers', offers)
  },


  removeOffer({ commit, dispatch }, offerId) {
    if (this.$cookies.get('user') === 'user') {
      this.$axios.delete(`/api/host_requests/${offerId}`,
        {
          headers: this.$cookies.get('authInfo')
        })
        .then(() => {
          commit('dialog/confirm/hideConfirm', null, { root: true })
          dispatch('snackbar/setMessage', 'オファーを拒否しました。', { root: true })
          commit('removeOffer', offerId)
        })
    } else {
      this.$axios.delete(`/api/user_requests/${offerId}`,
        {
          headers: this.$cookies.get('authInfo')
        })
        .then(() => {
          commit('dialog/confirm/hideConfirm', null, { root: true })
          dispatch('snackbar/setMessage', 'オファーを拒否しました。', { root: true })
          commit('removeOffer', offerId)
        })
    }

  }
}

export const getters = {
  offers(state) {
    return state.offers
  },

  offersOnCalendar(state, getters) {
    return getters.formatting(state.offers)
  },

  checkUnavailableOffers: _ => (payload) => {
    const laterHours7 = new Date().setHours(new Date().getHours() + 7)
    return payload.offers.some(
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
        partnerMyid: obj.partner.myid,
        partnerId: obj.partner.id,
        partner: obj.partner,
        start: `${s.getFullYear()}-${(s.getMonth() + 1).toString().padStart(2, '0')
          }-${(s.getDate()).toString().padStart(2, '0')}T${(s.getHours()).toString().padStart(2, '0')}:${(s.getMinutes()).toString().padStart(2, '0')}`,
        end: `${f.getFullYear()}-${(f.getMonth() + 1).toString().padStart(2, '0')
          }-${(f.getDate()).toString().padStart(2, '0')}T${(f.getHours()).toString().padStart(2, '0')}:${(f.getMinutes()).toString().padStart(2, '0')}`,
        name: "オファーがあります",
        color: '#48B8D0',
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
