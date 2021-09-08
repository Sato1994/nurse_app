// import axios from 'axios'

export const state = () => ({
  myInfo: [],
  authInfo: [],
  user: true
})

export const mutations = {
  saveMyInfoAsUser(state, myInfo) {
    state.myInfo = myInfo
  },
  saveMyInfoAsHost(state, myInfo) {
    state.myInfo = myInfo
    state.user = false
  },
  saveAuthInfo(state, authInfo) {
    state.authInfo = authInfo
  }
}

export const actions = {
  saveMyInfoAsUser(context, myInfo) {
    context.commit('saveMyInfoAsUser', myInfo)
  }
  ,
  saveMyInfoAsHost(context, myInfo) {
    context.commit('saveMyInfoAsHost', myInfo)
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