// import axios from 'axios'

// export const strict = false

export const state = () => ({
  myInfo: {},
  mySkills: [],
  myTimes: [],
  myRequests: [],
  myAgreements: [],
  myOffers: [],
  myRooms: [],

})

export const mutations = {
  saveMyInfo(state, myInfo) {
    state.myInfo = myInfo
  },
  saveMySkills(state, mySkills) {
    state.mySkills = mySkills
  },
  saveMyTimes(state, myTimes) {
    state.myTimes = myTimes
  },
  saveMyRequests(state, myRequests) {
    state.myRequests = myRequests
  },
  saveMyOffers(state, myOffers) {
    state.myOffers = myOffers
  },
  saveMyAgreements(state, myAgreements) {
    state.myAgreements = myAgreements
  },
  saveMyRooms(state, myRooms) {
    state.myRooms = myRooms
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
  },
  saveMyTimes(context, myTimes) {
    context.commit('saveMyTimes', myTimes)
  },
  saveMySkills(context, mySkills) {
    context.commit('saveMySkills', mySkills)
  },
  saveMyRequests(context, myRequests) {
    context.commit('saveMyRequests', myRequests)
  },
  saveMyOffers(context, myOffers) {
    context.commit('saveMyOffers', myOffers)
  },
  saveMyAgreements(context, myAgreements) {
    context.commit('saveMyAgreements', myAgreements)
  },
  saveMyRooms(context, myRooms) {
    context.commit('saveMyRooms', myRooms)
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
  },
  getMyTimes(state) {
    return state.myTimes
  },
  getMyRequests(state) {
    return state.myRequests
  },
  getMyOffers(state) {
    return state.myOffers
  },
  getMyRooms(state) {
    return state.myRooms
  },
  getMyAgreements(state) {
    return state.myAgreements
  }
}




// export const actions = {
//   async getTarget({ commit, id }) {
//     const res = await axios.get(`http://localhost:3000/api/users/${id}`)
//     commit('saveTarget', res.data.user)
//   }
// }