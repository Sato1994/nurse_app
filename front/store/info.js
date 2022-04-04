export const state = () => ({
  info: [],
})

export const mutations = {
  saveInfo(state, info) {
    state.info = info
  },
  logout(state) {
    state.info = []
  },
}

export const actions = {
  saveInfo({ commit }, info) {
    commit('saveInfo', info)
  },
  logout({ commit }) {
    commit('logout')
  },

  loginAsGuestUser({ dispatch }) {
    this.$axios
      .post('/api/user/sign_in', {
        email: 'yamada@guest.user',
        password: 'yamadapass',
      })
      .then((response) => {
        dispatch('snackbar/setMessage', 'ログインしました。', { root: true })
        this.$cookies.set('user', 'user')
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
            dispatch('rooms/saveRooms', response.data.rooms, { root: true })
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

  loginAsGuestHost({ dispatch }) {
    this.$axios
      .post('/api/host/sign_in', {
        email: 'takayuki@guest.host',
        password: 'takayukipass',
      })
      .then((response) => {
        dispatch('snackbar/setMessage', 'ログインしました。', { root: true })
        this.$cookies.set('user', 'host')
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
            dispatch('rooms/saveRooms', response.data.rooms, { root: true })
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








}

export const getters = {
  info(state) {
    return state.info
  },
}