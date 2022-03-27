import Vue from 'vue'
import InfiniteLoading from 'vue-infinite-loading'

Vue.use(InfiniteLoading, {
  slots: {
    noMore: '全て読み込みました',
    noResults: '読み込みは完了しています'
  }
})