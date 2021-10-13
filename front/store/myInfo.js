// import axios from 'axios'

// export const strict = false

export const state = () => ({
  myInfo: [],
  // authInfo消去予定
  // authInfo: [],
  user: true,
  mySkills: [],
})

export const mutations = {
  saveMyInfoAsUser(state, myInfo) {
    state.myInfo = myInfo
  },
  saveMyInfoAsHost(state, myInfo) {
    state.myInfo = myInfo
    state.user = false
  },
  // saveAuthInfo(state, authInfo) {
  //   state.authInfo = authInfo
  // },
  saveMySkills(state, mySkills) {
    state.mySkills = mySkills
  },
  addNewSkill(state, newSkill) {
    state.mySkills.push(newSkill)
  },
  removeMySkill(state, selectedSkill) {
    const target = state.mySkills.find(skill => skill.id === selectedSkill.id)
    const index = state.mySkills.indexOf(target)
    state.mySkills.splice(index, 1)
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
  // saveAuthInfo(context, authInfo) {
  //   context.commit('saveAuthInfo', authInfo)
  // },

  saveMySkills(context, mySkills) {
    context.commit('saveMySkills', mySkills)
  },
  addNewSkill(context, newSkill) {
    context.commit('addNewSkill', newSkill)
  },
  removeMySkill(context, selectedSkill) {
    context.commit('removeMySkill', selectedSkill)
  },

}

export const getters = {
  // getAuthInfo(state) {
  //   return state.authInfo
  // },
  getMyInfo(state) {
    return state.myInfo
  },
  getMySkills(state) {
    return state.mySkills
  }
}




// export const actions = {
//   async getTarget({ commit, id }) {
//     const res = await axios.get(`http://localhost:3000/api/users/${id}`)
//     commit('saveTarget', res.data.user)
//   }
// }