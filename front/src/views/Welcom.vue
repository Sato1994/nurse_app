<template>
<section class="text-gray-600 body-font">
  <div class="container px-5 py-24 mx-auto flex flex-wrap items-center">
    <div class="lg:w-3/5 md:w-1/2 md:pr-16 lg:pr-0 pr-0">
      <h1 class="title-font font-medium text-3xl text-gray-900">全く新しい転職サイトへようこそ</h1>
      <p class="leading-relaxed mt-4">NRSEUPは全く新しい転職マッチングサイトです。</p>
      
      <router-link to="/users">Usersへ</router-link> |



    </div>
    <div class="lg:w-2/6 md:w-1/2 bg-gray-100 rounded-lg p-8 flex flex-col md:ml-auto w-full mt-10 md:mt-0">
      <h2 class="text-gray-900 text-lg font-medium title-font mb-1">登録する</h2>


      
      <button @click="userOrHost" class="text-white bg-indigo-500 border-0 py-2 px-8 focus:outline-none hover:bg-indigo-600 rounded text-lg">{{registrationMessage}}</button>
      
      
      <div class="relative mb-1">
        <label for="name" class="leading-7 text-sm text-gray-600">{{nameMessage}}</label>
        <input v-model="state.name" type="text" id="name" name="name" class="w-full bg-white rounded border border-gray-300 focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200 text-base outline-none text-gray-700 py-1 px-3 leading-8 transition-colors duration-200 ease-in-out">
      </div>
      <div class="relative mb-1">
        <label for="email" class="leading-7 text-sm text-gray-600">メールアドレス</label>
        <input v-model="state.email" type="email" id="email" name="email" placeholder="info@sample.com" class="w-full bg-white rounded border border-gray-300 focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200 text-base outline-none text-gray-700 py-1 px-3 leading-8 transition-colors duration-200 ease-in-out">
      </div>   

      <div class="relative mb-1">
        <label for="password" class="leading-7 text-sm text-gray-600">パスワード</label>
        <input v-model="state.password" type="password" id="password" name="password" class="w-full bg-white rounded border border-gray-300 focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200 text-base outline-none text-gray-700 py-1 px-3 leading-8 transition-colors duration-200 ease-in-out">
      </div>
      <div class="relative mb-1">
        <label for="password_confirmation" class="leading-7 text-sm text-gray-600">パスワード確認用</label>
        <input v-model="state.password_confirmation" type="password" id="password_confirmation" name="password_confirmation" class="w-full bg-white rounded border border-gray-300 focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200 text-base outline-none text-gray-700 py-1 px-3 leading-8 transition-colors duration-200 ease-in-out">
      </div>
      <button @click="createState" class="text-white bg-indigo-500 border-0 py-2 px-8 focus:outline-none hover:bg-indigo-600 rounded text-lg">登録してみる</button>
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
      isUser: true,
      registrationMessage: '病院として登録する',
      nameMessage: '名前',
      state: {
        name: '',
        email: '',
        password: '',
        password_confirmation: ''
      }
    }
  },
  methods: {
    userOrHost: function() {
      this.isUser = !this.isUser
      this.registrationMessage = (this.isUser === true) ? '病院として登録する' : '看護師として登録する'
      this.nameMessage = (this.isUser === true) ? '名前' : '病院名'

      console.log(this.isUser)
    },
    createState() {
      if (this.isUser === true) {
        axios.post('http://localhost:3000/api/user', {
        name: this.state.name,
        email: this.state.email,
        password: this.state.password,
        password_confirmation: this.state.password_confirmation
      })
      .then(function (response) {
        console.log(response)
        })
      .catch(function (error) {
        console.log(error)
       })
      } else {
        axios.post('http://localhost:3000/api/host', {
        name: this.state.name,
        email: this.state.email,
        password: this.state.password,
        password_confirmation: this.state.password_confirmation
      })
      .then(function (response) {
        console.log(response)
        })
      .catch(function (error) {
        console.log(error)
       })
      }
      
    }
  }



  // setup() {
  //   const state = {}
  //   let state = reactive({
  //     isUser: false
  //   })
  //   function userOrHost() {
  //     this.isUser = !this.isUser
  //     console.log(this.isUser)
  //   }
  //   function createstate() {
  //     axios.post('http://localhost:3000/api/user', {
  //       name: state.name,
  //       email: state.email,
  //       password: state.password,
  //       password_confirmation: state.password_confirmation
  //     })
  //     .then(function (response) {
  //       console.log(response)
  //       })
  //     .catch(function (error) {
  //        console.log(error)
  //     })
  //   }
  //   return {
  //     createstate,
  //     state,
  //     state,
  //     userOrHost
  //   }
  // }
}

</script>
