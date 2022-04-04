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
        case 'HostRequest':
          switch (obj.action) {
            case 'created':
              title = '新しいオファーが届いています！'
              break
          }
      }
      const newObject = {
        id: obj.id,
        title,
        created_at: new Date(obj.created_at),
        source_id: obj.source_id,
        partnerName: obj.source.host.name,
        partnerMyId: obj.source.host.myid,
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