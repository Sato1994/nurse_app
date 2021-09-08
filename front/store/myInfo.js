// import axios from 'axios'

export const state = () => ({
  myInfo: [],
  authInfo: [],
  user: true
})

export const mutations = {
  saveMyInfo(state, myInfo) {
    state.myInfo = myInfo
    state.user = true
  },
  saveAuthInfo(state, authInfo) {
    state.authInfo = authInfo
  }
}

export const actions = {
  saveMyInfo(context, myInfo) {
    context.commit('saveMyInfo', myInfo)
  },
  saveAuthInfo(context, authInfo) {
    context.commit('saveAuthInfo', authInfo)
  }
}


// export const actions = {
//   async getTarget({ commit, id }) {
//     const res = await axios.get(`http://localhost:3000/api/users/${id}`)
//     commit('saveTarget', res.data.user)
//   }
// }