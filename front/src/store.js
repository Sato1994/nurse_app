import { createStore } from 'vuex'

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
  }


})