export const state = () => ({
  commentIsDisplay: false,
  title: '',
  description: '',
  agreeButtonText: '',
})

export const mutations = {
  displayAsRemoveTime(state) {
    state.title = '募集時間の取り消し'
    state.description = 'この時間の募集を取り消しますか？'
    state.agreeButtonText = '取り消す'
  },

  displayAsRemoveRequest(state) {
    state.title = 'リクエストの取り消し'
    state.description = 'このリクエストを取り消しますか？'
    state.agreeButtonText = '取り消す'
  },

  displayAsRemoveOffer(state) {
    state.title = 'リクエストの拒否'
    state.description = 'このリクエストを拒否しますか？'
    state.agreeButtonText = '拒否する'
  },

  displayAsCancellAgreement(state) {
    state.title = '契約のキャンセル'
    state.description = '一度確定した契約のキャンセルは推奨されません。\nやむを得ない理由によりキャンセルしますか？`'
    state.agreeButtonText = '契約をキャンセル'
  },
  displayWithComment(state) {
    state.title = '開始時刻まで48時間を切っています。'
    state.description = 'お相手に電話して直接キャンセルを申し出てください。\nキャンセル後、簡単に理由を入力し確定を押してください。'
    state.agreeButtonText = '確定'
    state.commentIsDisplay = true
  },

  hideConfirm(state) {
    state.commentIsDisplay = false
    state.title = ''
    state.description = ''
    state.agreeButtonText = ''
  },

}

export const actions = {

}

export const getters = {

}