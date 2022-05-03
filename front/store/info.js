export const state = () => ({
  info: {},
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
    state.info = {}
  },
}

export const actions = {
  saveInfo({ commit }, info) {
    commit('saveInfo', info)
  },

  loginAsGuestUser({ dispatch, commit }) {
    this.$axios
      .post('/api/user/sign_in', {
        email: 'yamada@guest.user',
        password: 'yamadapass',
      })
      .then((response) => {
        dispatch('snackbar/setMessage', 'ログインしました。', { root: true })
        this.$cookies.set('user', 'user')

        commit('iAmUser')

        this.$cookies.set('myid', response.data.data.myid)
        const authInfo = {
          'access-token': response.headers['access-token'],
          client: response.headers.client,
          uid: response.headers.uid,
        }
        this.$cookies.set('authInfo', authInfo)
        // ログイン者情報の取得
        // いる？
        this.$axios
          .get(
            `/api/${this.$cookies.get('user')}s/${response.data.data.myid}`,
            { headers: this.$cookies.get('authInfo') }
          )
          .then((response) => {
            dispatch('saveInfo', response.data.info)
            dispatch('skills/saveSkills', response.data.skills, { root: true })
            dispatch('issues/times/saveTimes', response.data.times, { root: true })
            dispatch('issues/requests/saveRequests', response.data.requests, { root: true })
            dispatch('issues/agreements/saveAgreements', response.data.agreements, { root: true })
            dispatch('issues/offers/saveOffers', response.data.offers, { root: true })
            dispatch('issues/rooms/saveRooms', response.data.rooms, { root: true })
            this.$router.push(`/${this.$cookies.get('user')}/${response.data.info.myid}`)
          })
          .catch(() => {
            this.$cookies.removeAll()
          })
      })
      .catch(() => {
        dispatch('snackbar/setMessage', '入力内容に誤りがあります。', { root: true })
      })
  },

  loginAsGuestHost({ dispatch, commit }) {
    this.$axios
      .post('/api/host/sign_in', {
        email: 'takayuki@guest.host',
        password: 'takayukipass',
      })
      .then((response) => {
        dispatch('snackbar/setMessage', 'ログインしました。', { root: true })
        this.$cookies.set('user', 'host')

        commit('iAmHost')

        this.$cookies.set('myid', response.data.data.myid)
        const authInfo = {
          'access-token': response.headers['access-token'],
          client: response.headers.client,
          uid: response.headers.uid,
        }
        this.$cookies.set('authInfo', authInfo)
        // ログイン者情報の取得
        this.$axios
          .get(
            `/api/${this.$cookies.get('user')}s/${response.data.data.myid}`,
            { headers: this.$cookies.get('authInfo') }
          )
          .then((response) => {
            dispatch('saveInfo', response.data.info)
            dispatch('skills/saveSkills', response.data.skills, { root: true })
            dispatch('issues/times/saveTimes', response.data.times, { root: true })
            dispatch('issues/requests/saveRequests', response.data.requests, { root: true })
            dispatch('issues/agreements/saveAgreements', response.data.agreements, { root: true })
            dispatch('issues/offers/saveOffers', response.data.offers, { root: true })
            dispatch('issues/rooms/saveRooms', response.data.rooms, { root: true })
            this.$router.push(`/${this.$cookies.get('user')}/${response.data.info.myid}`)
          })
          .catch(() => {
            this.$cookies.removeAll()
          })
      })
      .catch(() => {
        dispatch('snackbar/setMessage', '入力内容に誤りがあります。', { root: true })
      })
  },


  async signIn({ commit, dispatch }, payload) {
    try {
      const res = await this.$axios
        .post(`/api/${this.$cookies.get('user')}/sign_in`, payload)
      dispatch('snackbar/setMessage', 'ログインしました。', { root: true })
      this.$cookies.set('myid', res.data.data.myid)

      switch (this.$cookies.get('user')) {
        case 'user':
          commit('iAmUser')
          break
        case 'host':
          commit('iAmHost')
          break
      }

      const authInfo = {
        'access-token': res.headers['access-token'],
        client: res.headers.client,
        uid: res.headers.uid,
      }
      this.$cookies.set('authInfo', authInfo)
      try {
        const response = await this.$axios
          .get(
            `/api/${this.$cookies.get('user')}s/${res.data.data.myid}`,
            { headers: authInfo }
          )
        commit('saveInfo', response.data.info)
        dispatch('skills/saveSkills', response.data.skills, { root: true })
        dispatch('issues/times/saveTimes', response.data.times, { root: true })
        dispatch('issues/requests/saveRequests', response.data.requests, { root: true })
        dispatch('issues/agreements/saveAgreements', response.data.agreements, { root: true })
        dispatch('issues/offers/saveOffers', response.data.offers, { root: true })
        dispatch('issues/rooms/saveRooms', response.data.rooms, { root: true })
        this.$router.push(`/${this.$cookies.get('user')}/${response.data.info.myid}`)
      } catch {
        this.$cookies.removeAll()
      }
    } catch {
      dispatch('snackbar/setMessage', '入力内容に誤りがあります。', { root: true })
    }
  },

  async signUp({ commit, dispatch }, payload) {
    try {
      const { data, headers } = await this.$axios
        .post(`/api/${this.$cookies.get('user')}`, payload)
      this.$cookies.set('myid', data.data.myid)

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
      this.$cookies.set('authInfo', authInfo)

      try {
        const res = await this.$axios
          .get(
            `/api/${this.$cookies.get('user')}s/${data.data.myid}`,
            { headers: authInfo })
        commit('saveInfo', res.data.info)
        this.$router.push(`/${this.$cookies.get('user')}/${res.data.info.myid}`)
      } catch {
        this.$cookies.removeAll()
      }
    } catch {
      dispatch('snackbar/setMessage', '入力内容に誤りがあります。', { root: true })
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
  },
}

export const getters = {
  info(state) {
    return state.info
  },
}