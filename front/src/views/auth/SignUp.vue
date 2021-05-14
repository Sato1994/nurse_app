<template>
<section class="text-gray-600 body-font">
  <div class="container px-5 py-24 mx-auto flex flex-wrap items-center">
    <div class="lg:w-3/5 md:w-1/2 md:pr-16 lg:pr-0 pr-0">
      <h1 class="title-font font-medium text-3xl text-gray-900">全く新しい転職サイトへようこそ</h1>
      <p class="leading-relaxed mt-4">NRSEUPは全く新しい転職マッチングサイトです。</p>



    </div>
    <div class="lg:w-2/6 md:w-1/2 bg-gray-100 rounded-lg p-8 flex flex-col md:ml-auto w-full mt-10 md:mt-0">
      <h2 class="text-gray-900 text-lg font-medium title-font mb-1">新規登録</h2>


      
      <button @click="userOrHost" class="text-white bg-indigo-500 border-0 py-2 px-8 focus:outline-none hover:bg-indigo-600 rounded text-lg">{{registrationMessage}}</button>
      
      
      <div class="relative mb-1">
        <label for="name" class="leading-7 text-sm text-gray-600">{{nameMessage}}</label>
        <input v-model="target.name" type="text" id="name" name="name" class="w-full bg-white rounded border border-gray-300 focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200 text-base outline-none text-gray-700 py-1 px-3 leading-8 transition-colors duration-200 ease-in-out">
      </div>
      <div class="relative mb-1">
        <label for="email" class="leading-7 text-sm text-gray-600">メールアドレス</label>
        <input v-model="target.email" type="email" id="email" name="email" placeholder="info@sample.com" class="w-full bg-white rounded border border-gray-300 focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200 text-base outline-none text-gray-700 py-1 px-3 leading-8 transition-colors duration-200 ease-in-out">
      </div>   


      <!--Host登録時のみ表示-->
      <div v-if="!isUser">
        <div class="relative mb-1">
          <label for="address" class="leading-7 text-sm text-gray-600">住所</label>
          <input v-model="target.address" type="text" id="address" name="address" class="w-full bg-white rounded border border-gray-300 focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200 text-base outline-none text-gray-700 py-1 px-3 leading-8 transition-colors duration-200 ease-in-out">
        </div>

        <div class="relative mb-1">
          <label for="profile" class="leading-7 text-sm text-gray-600">紹介文</label>
          <textarea v-model="target.profile" type="text" id="profile" name="profile" class="w-full bg-white rounded border border-gray-300 focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200 text-base outline-none text-gray-700 py-1 px-3 leading-8 transition-colors duration-200 ease-in-out"></textarea>
        </div>
      </div>




      <div class="relative mb-1">
        <label for="password" class="leading-7 text-sm text-gray-600">パスワード</label>
        <input v-model="target.password" type="password" id="password" name="password" class="w-full bg-white rounded border border-gray-300 focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200 text-base outline-none text-gray-700 py-1 px-3 leading-8 transition-colors duration-200 ease-in-out">
      </div>
      <div class="relative mb-1">
        <label for="password_confirmation" class="leading-7 text-sm text-gray-600">パスワード確認用</label>
        <input v-model="target.password_confirmation" type="password" id="password_confirmation" name="password_confirmation" class="w-full bg-white rounded border border-gray-300 focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200 text-base outline-none text-gray-700 py-1 px-3 leading-8 transition-colors duration-200 ease-in-out">
      </div>

      <div class="relative mb-1">
        <label for="myid" class="leading-7 text-sm text-gray-600">ユーザID</label>
        <input v-model="target.myid" type="text" id="myid" name="myid" class="w-full bg-white rounded border border-gray-300 focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200 text-base outline-none text-gray-700 py-1 px-3 leading-8 transition-colors duration-200 ease-in-out">
      </div>


      <input v-model="target.wanted" type="checkbox" id="wanted" name="wanted" />登録後すぐに募集を開始しますか？



      <button @click="createTarget" class="text-white bg-indigo-500 border-0 py-2 px-8 focus:outline-none hover:bg-indigo-600 rounded text-lg">登録してみる</button>
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
      registrationMessage: '病院として登録する',
      nameMessage: '名前',
      isUser: true,
      target: [],
      URL: 'http://localhost:3000/api/user'

    }
  },
  methods: {
    userOrHost() {
      this.isUser = !this.isUser
      this.registrationMessage = this.isUser ? '病院として登録する' : '看護師として登録する'
      this.nameMessage = this.isUser ? '名前' : '病院名'
      this.URL = this.isUser ? 'http://localhost:3000/api/user' : 'http://localhost:3000/api/host'

      console.log(this.isUser)
    },
    createTarget() {
        // axiosはPromiseをサポートしてるから簡潔にかける
        //.then(function (response) {と書いてしまい、thisがundefined。アロー関数とではスコープが異なる  https://wemo.tech/904
        axios.post(this.URL, {
        name: this.target.name,
        email: this.target.email,
        password: this.target.password,
        password_confirmation: this.target.password_confirmation,
        address: this.target.address,
        profile: this.target.profile,
        wanted: this.target.wanted,
        myid: this.target.myid,
      })
      .then((response) => {
        this.$router.push({ name: 'Top' })
        console.log('登録成功', response)
        })
      .catch((error) => {
        console.log('登録失敗', error)
       }) 
    }
  }



  // setup() {
  //   const target = {}
  //   let target = reactive({
  //     isUser: false
  //   })
  //   function userOrHost() {
  //     this.isUser = !this.isUser
  //     console.log(this.isUser)
  //   }
  //   function createtarget() {
  //     axios.post('http://localhost:3000/api/user', {
  //       name: target.name,
  //       email: target.email,
  //       password: target.password,
  //       password_confirmation: target.password_confirmation
  //     })
  //     .then(function (response) {
  //       console.log(response)
  //       })
  //     .catch(function (error) {
  //        console.log(error)
  //     })
  //   }
  //   return {
  //     createtarget,
  //     target,
  //     target,
  //     userOrHost
  //   }
  // }
}

</script>