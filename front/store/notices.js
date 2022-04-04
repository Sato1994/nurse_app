export const state = () => ({
  notices: [],
  noticeIsDisplay: false
})

export const mutations = {

  displayNotice(state) {
    state.noticeIsDisplay = true
  },

  hideNotice(state) {
    state.noticeIsDisplay = false
  },

  removeNotice(state, payload) {
    const target = state.notices.find(notice => notice.id === payload.noticeId)
    const index = state.notices.indexOf(target)
    state.notices.splice(index, 1)
  },

  saveFormedNotices(state, notices) {
    const formedNotices = notices.map((obj) => {
      let title = ''
      switch (obj.source_type) {
        case 'HostRequest' || 'UserRequest':
          title = '新しいオファーが届いています！'
          break
        case 'Room':
          switch (obj.action) {
            case 'created':
              title = '新しいトークルームが作られました！'
              break
            case 'left':
              title = 'お相手がトークルームから退出しました。'
              break
            case 'changed':
              title = '希望時間が変更されました。'
              break
            case 'agreed':
              title = '希望時間が同意されました。'
              break
          }
          break
        case 'Agreement':
          switch (obj.action) {
            case 'created':
              title = '新しい契約があります！'
              break
            case 'changed':
              title = '契約の変更申請があります！'
              break
            case 'agreed':
              title = '変更中の契約が確定されました。'
              break
            case 'cancelled':
              break
          }
          break
        case 'Rate':
          title = '評価されました！'
          break
      }
      const today = new Date()
      const diff = today - new Date(obj.created_at)
      let creatdAt = ''

      switch (true) {
        case (diff) / 1000 / 60 < 5:
          creatdAt = '今'
          break
        case (diff) / 1000 / 60 < 60:
          creatdAt = '60分未満'
          break
        case (diff) / 1000 / 60 < 1440 && (today - new Date(obj.created_at)) / 1000 / 60 >= 60:
          creatdAt = '一日未満'
          break
        default:
          creatdAt = `${new Date(obj.created_at).getMonth() + 1}月${new Date(obj.created_at).getDate()}日`
      }



      const newObject = {
        id: obj.id,
        title,
        creatdAt,
        source_id: obj.source_id,
        partnerName: this.$cookies.get('user') === 'user' ? obj.source.host.name : obj.source.user.name,
        partnerMyId: this.$cookies.get('user') === 'user' ? obj.source.host.myid : obj.source.user.myid,
      }
      return newObject
    })
    state.notices = formedNotices
  },
}

export const actions = {
  removeNotice({ commit }, payload) {
    this.$axios.delete(`/api/${this.$cookies.get('user') === 'user' ? 'user' : 'host'}_notices/${payload.noticeId}`, {
      headers: this.$cookies.get('authInfo'),
    })
      .then(() => {
        commit('removeNotice', payload)
      })
  },
}

export const getters = {
  noticesOnDialog(state) {
    return state.notices
  },
}