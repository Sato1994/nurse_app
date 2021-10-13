// https://noumenon-th.net/programming/2019/08/24/nuxt-js-store/

import createPersistedState from 'vuex-persistedstate'

export default ({ store }) => {
    window.onNuxtReady(() => {
        createPersistedState({})(store)
    })
}