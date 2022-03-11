export default ({ $axios, redirect }) => {
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
}