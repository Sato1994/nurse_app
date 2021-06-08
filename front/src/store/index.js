import { createStore } from 'vuex'
import { target, skill } from './modules'
// vuexのデータをlocalstorageへ自動的に保存してくれるプラグイン
import createPersistedState from 'vuex-persistedstate'

export const store = createStore({

  modules: {
    target,
    skill,
  },


  plugins: [createPersistedState()]


})