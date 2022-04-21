import Vue from 'vue'
import InfiniteLoading from 'vue-infinite-loading'

Vue.use(InfiniteLoading, {
  slots: {
    noMore: '全て表示しました。',
    noResults: '見つかりませんでした。'
  }
})