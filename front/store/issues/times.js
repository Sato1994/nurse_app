export const state = () => ({
  times: []
})

export const mutations = {
  saveTimes(state, times) {
    if (times) state.times = times
  },

  addTime(state, time) {
    state.times.push(time)
  },

  removeTime(state, id) {
    const target = state.times.find(time => time.id === id)
    const index = state.times.indexOf(target)
    state.times.splice(index, 1)
  },

  reset(state) {
    state.times = []
  }
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

  async createTime({ commit, dispatch }, payload) {
    const startTime = `${payload.startTime.year}-${payload.startTime.month}-${payload.startTime.day}T${payload.startTime.hour}:${payload.startTime.minute}:00`
    const finsihTime = `${payload.finishTime.year}-${payload.finishTime.month}-${payload.finishTime.day}T${payload.finishTime.hour}:${payload.finishTime.minute}:00`
    try {
      const { data } = await this.$axios
        .post(
          `/api/${this.$cookies.get('user') === 'user' ? 'free' : 'recruitment'}_times`,
          {
            start_time: startTime,
            finish_time: finsihTime,
          },
          { headers: this.$cookies.get('authInfo') }
        )
      commit('addTime', data)
      dispatch('snackbar/setMessage', '募集時間を登録しました。', { root: true })
    } catch { }
  },
}

export const getters = {
  times(state) {
    return state.times
  },

  timesOnCalendar(state, getters) {
    return getters.formatting(state.times)
  },

  checkUnavailableTimes: _ => (payload) => {
    const laterHours8 = new Date().setHours(new Date().getHours() + 8)
    return payload.times.some(
      (value) =>
        new Date(
          value.startTime.year,
          value.startTime.month - 1,
          value.startTime.day,
          value.startTime.hour,
          value.startTime.minute
        ) <= laterHours8
    )
  },

  formatting: _ => (payload) => {
    return payload.map((obj) => {
      let s = new Date(obj.start_time)
      let f = new Date(obj.finish_time)
      // UTCを見る場合に差分プラスする
      if (process.server) {
        s = new Date(s.setHours(s.getHours() + 9))
        f = new Date(f.setHours(f.getHours() + 9))
      }

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
  }
}