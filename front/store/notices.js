export const state = () => ({
  notices: [],
})

export const mutations = {
  removeNotice(state, payload) {
    const target = state.notices.find(notice => notice.id === payload.noticeId)
    const index = state.notices.indexOf(target)
    state.notices.splice(index, 1)
  },

  saveFormedNotices(state, notices) {
    const formedNotices = notices.map((obj) => {
      let title = ''
      let subTitle = ''
      let sourceLink = ''
      switch (obj.source_type) {
        case 'UserRequest':
        case 'HostRequest':
          title = '新しいオファーがあります'
          subTitle = '確認してみましょう'
          sourceLink = '/issues/offers'
          break
        case 'Room':
          sourceLink = `/rooms/${obj.source_id}`
          switch (obj.action) {
            case 'created':
              title = '新しいトークルームが作られました'
              subTitle = 'メッセージを送ってみましょう'
              break
            case 'left':
              title = 'お相手がトークルームから退出しました'
              subTitle = '独りぼっち'
              break
            case 'changed':
              title = '希望時間を修正が修正されました'
              subTitle = '確認してみましょう'
              break
            case 'agreed':
              title = '希望時間が同意されました'
              subTitle = 'あなたの同意で契約が確定します'
              break
          }
          break
        case 'Agreement':
          sourceLink = `/rooms/${obj.source.room.id}`
          switch (obj.action) {
            case 'created':
              title = '新しい契約があります！'
              subTitle = '確認してみましょう'
              break
            case 'changed':
              title = '契約の変更申請があります！'
              subTitle = '確認してみましょう'
              break
            case 'agreed':
              title = '変更中の契約が再確定されました'
              subTitle = '確認してみましょう'
              break
            case 'cancelled':
              title = '契約がキャンセルされました'
              subTitle = 'やむを得ない理由があったようです'
              break
          }
          break
        case 'Rate':
          sourceLink = `/something`
          title = '評価されました！'
          subTitle = '確認してみましょう'
          break
      }
      const today = new Date()
      const diff = today - new Date(obj.created_at)
      let createdAt = ''

      switch (true) {
        case diff / 1000 / 60 < 5:
          createdAt = '今'
          break
        case diff / 1000 / 60 < 60:
          createdAt = `${Math.round(diff / 1000 / 60)}分前`
          break
        case (diff / 1000 / 60 < 1440) && (diff / 1000 / 60 >= 60):
          createdAt = `${Math.floor(diff / 1000 / 60 / 60)}時間前`
          break
        default:
          createdAt = `${new Date(obj.created_at).getMonth() + 1}月${new Date(obj.created_at).getDate()}日`
      }

      const newObject = {
        id: obj.id,
        title,
        subTitle,
        createdAt,
        sourceId: obj.source_id,
        sourceLink,
        partnerName: obj.source.partner.name,
        partnerMyId: obj.source.partner.myid,
        partnerImage: obj.source.partner.image.url
      }
      return newObject
    })
    state.notices = formedNotices
  },
}

export const actions = {
  async removeNotice({ commit }, payload) {
    await this.$axios.delete(`/api/${this.$cookies.get('user') === 'user' ? 'user' : 'host'}_notices/${payload.noticeId}`, {
      headers: this.$cookies.get('authInfo'),
    })
    commit('removeNotice', payload)
  },
}

export const getters = {
  noticesOnDialog(state) {
    return state.notices
  },
}