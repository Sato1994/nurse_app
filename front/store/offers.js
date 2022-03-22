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

  removeOffer({ commit }, id) {
    commit('removeOffer', id)
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
        start: `${s.getFullYear()}-${s.getMonth() + 1
          }-${s.getDate()}T${s.getHours()}:${s.getMinutes()}`,
        end: `${f.getFullYear()}-${f.getMonth() + 1
          }-${f.getDate()}T${f.getHours()}:${f.getMinutes()}`,
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
