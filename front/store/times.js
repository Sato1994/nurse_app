export const state = () => ({
  times: []
})

export const mutations = {
  saveTimes(state, times) {
    state.times = times
  },

  addTime(state, time) {
    state.times.push(time)
  },

  removeTime(state, id) {
    const target = state.times.find(time => time.id === id)
    const index = state.times.indexOf(target)
    state.times.splice(index, 1)
  },
}

export const actions = {
  saveTimes({ commit }, times) {
    commit('saveTimes', times)
  },

  removeTime({ dispatch, commit }, timeId) {
    this.$axios
      .delete(`/api/free_times/${timeId}`, {
        headers: this.$cookies.get('authInfo'),
      })
      .then(() => {
        commit('dialog/confirm/hideConfirm', null, { root: true })
        dispatch('snackbar/setMessage', '取り消しました。', { root: true })
        commit('removeTime', timeId)
      })
  },

  createTime({ commit, dispatch }, payload) {
    const startTime = `${payload.startTime.year}-${payload.startTime.month}-${payload.startTime.day}T${payload.startTime.hour}:${payload.startTime.minute}:00`
    const finsihTime = `${payload.finishTime.year}-${payload.finishTime.month}-${payload.finishTime.day}T${payload.finishTime.hour}:${payload.finishTime.minute}:00`
    this.$axios
      .post(
        `/api/${this.$cookies.get('user') === 'user' ? 'free' : 'recruitment'}_times`,
        {
          start_time: startTime,
          finish_time: finsihTime,
        },
        { headers: this.$cookies.get('authInfo') }
      )
      .then((response) => {
        commit('addTime', response.data)
        commit('dialog/datePicker/hideDatePicker', null, { root: true })
        dispatch('snackbar/setMessage', '募集時間を登録しました。', { root: true })
      })
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
        startTime: {
          year: s.getFullYear(),
          month: s.getMonth() + 1,
          day: s.getDate(),
          hour: s.getHours(),
          minute: s.getMinutes(),
        },
        finishTime: {
          year: f.getFullYear(),
          month: f.getMonth() + 1,
          day: f.getDate(),
          hour: f.getHours(),
          minute: f.getMinutes(),
        }
      }

      return newObject
    })
    return times
  },
}