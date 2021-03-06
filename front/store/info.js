export const state = () => ({
  info: {
    id: null,
    name: null,
    address: null,
    image: {
      url: null,
    },
    wanted: null,
    sex: null,
    age: null,
    year: null,
    profile: null,
    created_at: null,
    myid: null,
    lat: null,
    lng: null,
  },
  me: '',
})

export const mutations = {
  saveInfo(state, info) {
    state.info = info
  },

  iAmUser(state) {
    state.me = 'user'
  },

  iAmHost(state) {
    state.me = 'host'
  },

  reset(state) {
    state.info = {
      id: null,
      name: null,
      address: null,
      image: {
        url: null,
      },
      wanted: null,
      sex: null,
      age: null,
      year: null,
      profile: null,
      created_at: null,
      myid: null,
      lat: null,
      lng: null,
    }
  },
}

export const actions = {
  saveInfo({ commit }, info) {
    commit('saveInfo', info)
  },

  async loginAsGuestUser({ dispatch, commit }) {
    try {
      const { data, headers } = await this.$axios
        .post('/api/user/sign_in', {
          email: 'guest@user.com',
          password: 'userpass',
        })

      const authInfo = {
        'access-token': headers['access-token'],
        client: headers.client,
        uid: headers.uid,
      }

      this.$cookies.set('authInfo', authInfo, { secure: true, sameSite: 'Lax' })
      this.$cookies.set('user', 'user', { secure: true, sameSite: 'Lax' })
      this.$cookies.set('myid', data.info.myid, { secure: true, sameSite: 'Lax' })

      dispatch('snackbar/setMessage', 'ログインしました。', { root: true })
      dispatch('saveInfo', data.info)
      dispatch('skills/saveSkills', data.skills, { root: true })
      dispatch('issues/times/saveTimes', data.times, { root: true })
      dispatch('issues/requests/saveRequests', data.requests, { root: true })
      dispatch('issues/agreements/saveAgreements', data.agreements, { root: true })
      dispatch('issues/offers/saveOffers', data.offers, { root: true })
      dispatch('issues/rooms/saveRooms', data.rooms, { root: true })
      commit('notices/saveNotices', data.notices, { root: true })
      commit('iAmUser')

      this.$router.push(`/${this.$cookies.get('user')}/${data.info.myid}`)
    } catch {
      dispatch('snackbar/setMessage', '入力内容に誤りがあります。', { root: true })
      this.$cookies.removeAll()
    }
  },

  async loginAsGuestHost({ dispatch, commit }) {
    try {
      const { data, headers } = await this.$axios
        .post('/api/host/sign_in', {
          email: 'guest@host.com',
          password: 'hostpass',
        })

      const authInfo = {
        'access-token': headers['access-token'],
        client: headers.client,
        uid: headers.uid,
      }

      this.$cookies.set('user', 'host', { secure: true, sameSite: 'Lax' })
      this.$cookies.set('myid', data.info.myid, { secure: true, sameSite: 'Lax' })
      this.$cookies.set('authInfo', authInfo, { secure: true, sameSite: 'Lax' })

      dispatch('saveInfo', data.info)
      dispatch('skills/saveSkills', data.skills, { root: true })
      dispatch('issues/times/saveTimes', data.times, { root: true })
      dispatch('issues/requests/saveRequests', data.requests, { root: true })
      dispatch('issues/agreements/saveAgreements', data.agreements, { root: true })
      dispatch('issues/offers/saveOffers', data.offers, { root: true })
      dispatch('issues/rooms/saveRooms', data.rooms, { root: true })
      dispatch('snackbar/setMessage', 'ログインしました。', { root: true })

      commit('notices/saveNotices', data.notices, { root: true })
      commit('iAmHost')

      this.$router.push(`/${this.$cookies.get('user')}/${data.info.myid}`)

    } catch {
      dispatch('snackbar/setMessage', '入力内容に誤りがあります。', { root: true })
      this.$cookies.removeAll()
    }
  },

  async signIn({ commit, dispatch }, payload) {
    try {
      const { data, headers } = await this.$axios
        .post(`/api/${this.$cookies.get('user')}/sign_in`, payload)

      switch (this.$cookies.get('user')) {
        case 'user':
          commit('iAmUser')
          break
        case 'host':
          commit('iAmHost')
          break
      }

      const authInfo = {
        'access-token': headers['access-token'],
        client: headers.client,
        uid: headers.uid,
      }

      this.$cookies.set('authInfo', authInfo, { secure: true, sameSite: 'Lax' })
      this.$cookies.set('myid', data.info.myid, { secure: true, sameSite: 'Lax' })
      dispatch('snackbar/setMessage', 'ログインしました。', { root: true })
      dispatch('skills/saveSkills', data.skills, { root: true })
      dispatch('issues/times/saveTimes', data.times, { root: true })
      dispatch('issues/requests/saveRequests', data.requests, { root: true })
      dispatch('issues/agreements/saveAgreements', data.agreements, { root: true })
      dispatch('issues/offers/saveOffers', data.offers, { root: true })
      dispatch('issues/rooms/saveRooms', data.rooms, { root: true })
      commit('notices/saveNotices', data.notices, { root: true })
      commit('saveInfo', data.info)
      this.$router.push(`/${this.$cookies.get('user')}/${data.info.myid}`)

    } catch (e) {
      if (e.response.status === 422) {
        dispatch('snackbar/setMessage', e.response.data.errors.full_messages[0], { root: true })
      }
      else {
        dispatch('snackbar/setMessage', '入力内容を見直してください。', { root: true })
        this.$cookies.removeAll()
      }
    }
  },

  async signUp({ commit, dispatch }, payload) {
    try {
      const { data, headers } = await this.$axios
        .post(`/api/${this.$cookies.get('user')}`, payload)

      const authInfo = {
        'access-token': headers['access-token'],
        client: headers.client,
        uid: headers.uid,
      }

      this.$cookies.set('authInfo', authInfo, { secure: true, sameSite: 'Lax' })
      this.$cookies.set('myid', data.info.myid, { secure: true, sameSite: 'Lax' })

      commit('saveInfo', data.info)
      switch (this.$cookies.get('user')) {
        case 'user':
          commit('iAmUser')
          break
        case 'host':
          commit('iAmHost')
          break
      }

      this.$router.push(`/${this.$cookies.get('user')}/${data.info.myid}`)

    } catch (e) {
      if (e.response.status === 422) {
        dispatch('snackbar/setMessage', e.response.data.errors.full_messages[0], { root: true })
        this.$cookies.removeAll()
      }
      else {
        dispatch('snackbar/setMessage', '入力内容を見直してください。', { root: true })
        this.$cookies.removeAll()
      }
    }
  },

  async getAddress({ dispatch }, payload) {
    try {
      const { data } = await this.$axios.get(
        `https://maps.googleapis.com/maps/api/geocode/json?address=${payload.searchSource}&key=${this.$config.MAPS_API_KEY}`
      )
      if (data.status === 'OK') {

        const addressBox = data.results[0].address_components
        const address = []

        for (let i = addressBox.length - 2; i !== 0; i -= 1) {
          address.push(addressBox[i].long_name)
        }

        const lat = data.results[0].geometry.location.lat
        const lng = data.results[0].geometry.location.lng
        return { status: 'OK', data: { address: address.join(''), lat, lng } }
      } else if (data.status === 'ZERO_RESULTS') {
        dispatch('snackbar/setMessage', '住所を見直してください', { root: true })
        return { status: data.status, data: '' }

      }
    } catch {
      dispatch('snackbar/setMessage', '住所検索に失敗しました', { root: true })
    }
  },

  resetAllStores({ commit }) {
    commit('reset')
    commit('issues/agreements/reset', {}, { root: true })
    commit('issues/offers/reset', {}, { root: true })
    commit('issues/requests/reset', {}, { root: true })
    commit('issues/rooms/reset', {}, { root: true })
    commit('issues/times/reset', {}, { root: true })
    commit('notices/reset', {}, { root: true })
    commit('skills/reset', {}, { root: true })
  },
}

export const getters = {
  info(state) {
    return state.info
  },
}