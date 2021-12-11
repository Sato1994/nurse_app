export const state = () => ({
  times: []
})

export const mutations = {
  saveTimes(state, times) {
    state.times = times
  }
}

export const actions = {
  saveTimes({ commit }, times) {
    commit('saveTimes', times)
  },
}

export const getters = {
  times(state) {
    return state.times
  },

  timesOnCalendar(state) {
    const times = state.times.map((obj) => {
      const s = new Date(obj.start_time)
      const f = new Date(obj.finish_time)
      const newObject = {
        id: obj.id,
        start: `${s.getFullYear()}-${s.getMonth() + 1
          }-${s.getDate()}T${s.getHours()}:${s.getMinutes()}`,
        end: `${f.getFullYear()}-${f.getMonth() + 1
          }-${f.getDate()}T${f.getHours()}:${f.getMinutes()}`,
        name: '募集中',
        color: 'green',
        dislayStart: `${s.getMonth() + 1
          }/${s.getDate()}  ${s.getHours()}:${s.getMinutes()}`,
        displayFinish: `${f.getMonth() + 1
          }/${f.getDate()}  ${f.getHours()}:${f.getMinutes()}`,
      }
      return newObject
    })
    return times

  },

}