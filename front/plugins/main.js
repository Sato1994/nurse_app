import Vue from 'vue'
import VModal from 'vue-js-modal'
import InfiniteLoading from 'vue-infinite-loading'

Vue.use(VModal)
Vue.use(InfiniteLoading, {
  slots: {
    noMore: '全て読み込みました',
    noResults: '読み込みは完了しています'
  }
})