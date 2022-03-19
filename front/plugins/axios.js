export default ({ $axios, redirect, store }) => {
  // リクエストログ
  $axios.onRequest((config) => {
    console.log(config)
  })
  // レスポンスログ
  $axios.onResponse((config) => {
    console.log(config)
  })
  // エラーログ
  $axios.onError((e) => {
    console.log(e.response)
  })
  // 401エラーならホームへ遷移
  $axios.onError((e) => {
    if (e.response.status === 401) {
      redirect('/')
    }
  })

  // エラーメッセージをsnackbarで表示
  $axios.onError(e => {
    if (!e.response) {
      return
    }

    if (e.response.status === 400) {
      if (e.response.data === undefined) {
        return
      }
      const message = e.response.data.message[0]
      if (message === undefined || message === null || message === '') {
        return
      }
      store.dispatch('snackbar/setMessage', message)
    }
  })
}