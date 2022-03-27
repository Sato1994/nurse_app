export const state = () => ({
  offers: []
})

export const mutations = {
  saveOffers(state, offers) {
    state.offers = offers
  },

  removeOffer(state, id) {
    const target = state.offers.find(offer => offer.id === id)
    const index = state.offers.indexOf(target)
    state.offers.splice(index, 1)
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
          commit('display/hideConfirm', null, { root: true })
          dispatch('snackbar/setMessage', 'オファーを拒否しました。', { root: true })
          commit('removeOffer', offerId)
        })
    } else {
      this.$axios.delete(`/api/user_request/${offerId}`,
        {
          headers: this.$cookies.get('authInfo')
        })
        .then(() => {
          commit('display/hideConfirm', null, { root: true })
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

  offersOnCalendar(state) {
    const offers = state.offers.map((obj) => {
      const s = new Date(obj.start_time)
      const f = new Date(obj.finish_time)
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
        color: 'blue',
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
    return offers
  }
}
