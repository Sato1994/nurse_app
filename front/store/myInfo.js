// import axios from 'axios'

// export const strict = false

export const state = () => ({
  myInfo: [],
  mySkills: [],
})

export const mutations = {
  saveMyInfo(state, myInfo) {
    state.myInfo = myInfo
  },
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
  },
  logout(state) {
    state.myInfo = []
    state.mySkills = []
  }


}

export const actions = {
  saveMyInfo(context, myInfo) {
    context.commit('saveMyInfo', myInfo)
  }
  ,
  saveMySkills(context, mySkills) {
    context.commit('saveMySkills', mySkills)
  },
  addNewSkill(context, newSkill) {
    context.commit('addNewSkill', newSkill)
  },
  removeMySkill(context, selectedSkill) {
    context.commit('removeMySkill', selectedSkill)
  },
  logout(context) {
    context.commit('logout')
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