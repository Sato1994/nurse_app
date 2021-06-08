<template>
<section class="text-gray-600 body-font">
  <div class="container px-5 py-24 mx-auto flex flex-wrap items-center">
    <div class="lg:w-2/6 md:w-1/2 bg-gray-100 rounded-lg p-8 flex flex-col md:ml-auto w-full mt-10 md:mt-0">
      <h2 class="text-gray-900 text-lg font-medium title-font mb-1">ログイン</h2>
      <button @click="userOrHost" class="text-white bg-indigo-500 border-0 py-2 px-8 focus:outline-none hover:bg-indigo-600 rounded text-lg">{{signInMessage}}</button>
        
      <div class="relative mb-1">
        <label for="email" class="leading-7 text-sm text-gray-600">メールアドレス</label>
        <input v-model="target.email" type="email" id="email" name="email" placeholder="info@sample.com" class="w-full bg-white rounded border border-gray-300 focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200 text-base outline-none text-gray-700 py-1 px-3 leading-8 transition-colors duration-200 ease-in-out">
      </div>




      <div class="relative mb-1">
        <label for="password" class="leading-7 text-sm text-gray-600">パスワード</label>
        <input v-model="target.password" type="password" id="password" name="password" class="w-full bg-white rounded border border-gray-300 focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200 text-base outline-none text-gray-700 py-1 px-3 leading-8 transition-colors duration-200 ease-in-out">
      </div>


      <button @click="signIn" class="text-white bg-indigo-500 border-0 py-2 px-8 focus:outline-none hover:bg-indigo-600 rounded text-lg">ログインする</button>
      <p class="text-xs text-gray-500 mt-3">ユーザ登録後すぐに詳しい条件を登録できます♪</p>
    </div>
  </div>
</section>
</template>

<script>
// import { reactive } from 'vue'
import axios from 'axios'

// export default で囲むことで、外部からも参照できるようにする。

export default {
  data() {
    return {
      signInMessage: '看護師としてログインする',
      isUser: true,
      target: [],
      URL: 'http://localhost:3000/api/user/sign_in'

    }
  },
  methods: {
    userOrHost() {
      this.isUser = !this.isUser
      this.signInMessage = this.isUser ? '看護師でログインする' : '病院でログインする'
      this.URL = this.isUser ? 'http://localhost:3000/api/user/sign_in' : 'http://localhost:3000/api/host/sign_in'

      console.log(this.isUser)
    },
    signIn() {
        // axiosはPromiseをサポートしてるから簡潔にかける
        //.then(function (response) {と書いてしまい、thisがundefined。アロー関数とではスコープが異なる  https://wemo.tech/904
        axios.post(this.URL, {
        email: this.target.email,
        password: this.target.password
      })
      .then((response) => {
        //ローカルストレージに access-token等を保存
        localStorage.setItem('access-token', response.headers['access-token'])
        localStorage.setItem('client', response.headers['client'])
        localStorage.setItem('uid', response.headers['uid'])

         //vuexにtargetのresponse.dataを挿入
        this.$store.dispatch('target/targetSave', response.data.data)
        console.log('state.target→',this.$store.state.target.target)


        this.$router.push({ name: 'Home' })
        console.log(this.isUser + 'としてログイン成功', response)
        })
      .catch((error) => {
        console.log(this.isUser + 'としてログイン失敗', error)
       }) 
    }
  }



}

</script>