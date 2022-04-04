export const state = () => ({
  signInIsDisplay: false,
})

export const mutations = {
  displaySignIn(state) {
    console.log('fefeefe')
    state.signInIsDisplay = true
  },

  hideSignIn(state) {
    state.signInIsDisplay = false
  },
}

export const actions = {
  signIn({ commit, dispatch }, payload) {
    this.$axios
      .post(`/api/${this.$cookies.get('user')}/sign_in`, payload)
      .then((response) => {
        dispatch('snackbar/setMessage', 'ログインしました。', { root: true })
        commit('hideSignIn')
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
            dispatch('info/saveInfo', response.data.info, { root: true })
            dispatch('skills/saveSkills', response.data.skills, { root: true })
            dispatch('times/saveTimes', response.data.times, { root: true })
            dispatch('requests/saveRequests', response.data.requests, { root: true })
            dispatch('issues/agreements/saveAgreements', response.data.agreements, { root: true })
            dispatch('offers/saveOffers', response.data.offers, { root: true })
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

}