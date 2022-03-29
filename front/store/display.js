export const state = () => ({
  confirm: {
    commentIsDisplay: false,
    title: '',
    description: '',
    agreeButtonText: '',
  },

  skillList: {
    skillListIsDisplay: false,
  },

  datePicker: {
    datePickerIsDisplay: false,
  },
})

export const mutations = {
  // Confirm
  displayConfirmAsRemoveTime(state) {
    state.confirm.title = '募集時間の取り消し'
    state.confirm.description = 'この時間の募集を取り消しますか？'
    state.confirm.agreeButtonText = '取り消す'
  },

  displayConfirmAsRemoveRequest(state) {
    state.confirm.title = 'リクエストの取り消し'
    state.confirm.description = 'このリクエストを取り消しますか？'
    state.confirm.agreeButtonText = '取り消す'
  },

  displayConfirmAsRemoveOffer(state) {
    state.confirm.title = 'リクエストの拒否'
    state.confirm.description = 'このリクエストを拒否しますか？'
    state.confirm.agreeButtonText = '拒否する'
  },

  displayConfirmAsCancellAgreement(state) {
    state.confirm.title = '契約のキャンセル'
    state.confirm.description = '一度確定した契約のキャンセルは推奨されません。\nやむを得ない理由によりキャンセルしますか？`'
    state.confirm.agreeButtonText = '契約をキャンセル'
  },
  displayConfirmWithComment(state) {
    state.confirm.title = '開始時刻まで48時間を切っています。'
    state.confirm.description = 'お相手に電話して直接キャンセルを申し出てください。\nキャンセル後、簡単に理由を入力し確定を押してください。'
    state.confirm.agreeButtonText = '確定'
    state.confirm.commentIsDisplay = true
  },

  hideConfirm(state) {
    state.confirm.commentIsDisplay = false
    state.confirm.title = ''
    state.confirm.description = ''
    state.confirm.agreeButtonText = ''
  },

  // SkillList
  displaySkillList(state) {
    state.skillList.skillListIsDisplay = true
  },

  hideSkillList(state) {
    state.skillList.skillListIsDisplay = false
  },

  // DatePicker
  displayDatePicker(state) {
    state.datePicker.datePickerIsDisplay = true
  },

  hideDatePicker(state) {
    state.datePicker.datePickerIsDisplay = false
  },
}

export const getters = {
  datePicker(state) {
    return state.datePicker
  },
}