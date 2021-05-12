import { createStore } from 'vuex'

export const store = createStore({
  state() {
    return {
      message: 'This is store data.'
    }
  }
})