import { createStore } from 'vuex'
// vuexのデータをlocalstorageへ自動的に保存してくれるプラグイン
import createPersistedState from 'vuex-persistedstate'

export const store = createStore({

  state() {
    return {
      target: {

      }
    }
  },
  mutations: {
    targetSave(state, target) {
      state.target = target

    }
  },

  actions: {
    targetSave(context, target) {
      context.commit('targetSave', target)
      console.log('this is context→', context)
    }
  },

  plugins: [createPersistedState()]


})