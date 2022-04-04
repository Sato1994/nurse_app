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
      const newObject = {
        id: obj.id,
        title,
        created_at: new Date(obj.created_at),
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
}

export const getters = {
  noticesOnDialog(state) {
    return state.notices
  },
}