// import axios from 'axios'

// export const state = () => ({
//   target: [],

// })

// export const mutations = {
//   saveTarget(state, target) {
//     state.target = target
//   },
//   saveSkills(state, skills) {
//     state.skills = skills
//   }
// }

// export const actions = {
//   async getTarget({ commit, id }) {
//     const res = await axios.get(`http://localhost:3000/api/users/${id}`)
//     commit('saveTarget', res.data.user)
//   }
// }

// export const getters = {
//   setTarget: state => {
//     return state.target
//   }
// }