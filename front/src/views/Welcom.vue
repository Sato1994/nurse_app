<template>
<section class="text-gray-600 body-font">
  <div class="container px-5 py-24 mx-auto flex flex-wrap items-center">
    <div class="lg:w-3/5 md:w-1/2 md:pr-16 lg:pr-0 pr-0">
      <h1 class="title-font font-medium text-3xl text-gray-900">全く新しい転職サイトへようこそ</h1>
      <p class="leading-relaxed mt-4">NRSEUPは全く新しい転職マッチングサイトです。</p>
    </div>
    <div class="lg:w-2/6 md:w-1/2 bg-gray-100 rounded-lg p-8 flex flex-col md:ml-auto w-full mt-10 md:mt-0">
      <h2 class="text-gray-900 text-lg font-medium title-font mb-1">登録する</h2>
      <div class="relative mb-1">
        <label for="name" class="leading-7 text-sm text-gray-600">名前</label>
        <input v-model="newUser.name" type="text" id="name" name="name" class="w-full bg-white rounded border border-gray-300 focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200 text-base outline-none text-gray-700 py-1 px-3 leading-8 transition-colors duration-200 ease-in-out">
      </div>
      <div class="relative mb-1">
        <label for="email" class="leading-7 text-sm text-gray-600">メールアドレス</label>
        <input v-model="newUser.email" type="email" id="email" name="email" placeholder="info@sample.com" class="w-full bg-white rounded border border-gray-300 focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200 text-base outline-none text-gray-700 py-1 px-3 leading-8 transition-colors duration-200 ease-in-out">
      </div>   

      <div class="relative mb-1">
        <label for="password" class="leading-7 text-sm text-gray-600">パスワード</label>
        <input v-model="newUser.password" type="password" id="password" name="password" class="w-full bg-white rounded border border-gray-300 focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200 text-base outline-none text-gray-700 py-1 px-3 leading-8 transition-colors duration-200 ease-in-out">
      </div>
      <div class="relative mb-1">
        <label for="password_confirmation" class="leading-7 text-sm text-gray-600">パスワード確認用</label>
        <input v-model="newUser.password_confirmation" type="password" id="password_confirmation" name="password_confirmation" class="w-full bg-white rounded border border-gray-300 focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200 text-base outline-none text-gray-700 py-1 px-3 leading-8 transition-colors duration-200 ease-in-out">
      </div>
      <button @click="createNewUser" class="text-white bg-indigo-500 border-0 py-2 px-8 focus:outline-none hover:bg-indigo-600 rounded text-lg">登録してみる</button>
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
  setup() {
    const newUser = {}
    function createNewUser() {
      axios.post('http://localhost:3000/api/user', {
        name: newUser.name,
        email: newUser.email,
        password: newUser.password,
        password_confirmation: newUser.password_confirmation
      })
      .then(function (response) {
        console.log(response)
        })
      .catch(function (error) {
         console.log(error)
      })
    }
    return {
      createNewUser,
      newUser
    }
  }
}

</script>
