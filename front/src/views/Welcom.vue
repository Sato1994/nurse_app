<template>
:name, :email, :address, :wanted, :sex, :age, :year
<section class="text-gray-600 body-font">
  <div class="container px-5 py-24 mx-auto flex flex-wrap items-center">
    <div class="lg:w-3/5 md:w-1/2 md:pr-16 lg:pr-0 pr-0">
      <h1 class="title-font font-medium text-3xl text-gray-900">全く新しい転職サイトへようこそ</h1>
      <p class="leading-relaxed mt-4">NRSEUPは全く新しい転職マッチングサイトです。</p>
    </div>
    <div class="lg:w-2/6 md:w-1/2 bg-gray-100 rounded-lg p-8 flex flex-col md:ml-auto w-full mt-10 md:mt-0">
      <h2 class="text-gray-900 text-lg font-medium title-font mb-5">登録する</h2>
      <div class="relative mb-4">
        <label for="full-name" class="leading-7 text-sm text-gray-600">名前</label>
        <input type="text" id="full-name" name="full-name" class="w-full bg-white rounded border border-gray-300 focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200 text-base outline-none text-gray-700 py-1 px-3 leading-8 transition-colors duration-200 ease-in-out">
      </div>
      <div class="relative mb-4">
        <label for="email" class="leading-7 text-sm text-gray-600">メールアドレス</label>
        <input type="email" id="email" name="email" class="w-full bg-white rounded border border-gray-300 focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200 text-base outline-none text-gray-700 py-1 px-3 leading-8 transition-colors duration-200 ease-in-out">
      </div>
      <div class="relative mb-4">
        <label for="age" class="leading-7 text-sm text-gray-600">年齢</label>
        <input type="text" id="age" name="age" class="w-full bg-white rounded border border-gray-300 focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200 text-base outline-none text-gray-700 py-1 px-3 leading-8 transition-colors duration-200 ease-in-out">
      </div>
      <div class="relative mb-4">
        <label for="year" class="leading-7 text-sm text-gray-600">経験年数</label>
        <input type="text" id="year" name="year" class="w-full bg-white rounded border border-gray-300 focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200 text-base outline-none text-gray-700 py-1 px-3 leading-8 transition-colors duration-200 ease-in-out">
      </div>
      <div class="relative mb-4">
        <label for="sex" class="leading-7 text-sm text-gray-600">性別</label>
        <input type="text" id="sex" name="sex" class="w-full bg-white rounded border border-gray-300 focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200 text-base outline-none text-gray-700 py-1 px-3 leading-8 transition-colors duration-200 ease-in-out">
      </div>
      <div class="relative mb-4">
        <label for="wanted" class="leading-7 text-sm text-gray-600">登録と同時に求職を開始しますか？</label>
        <input type="checkbox" id="wanted" name="wanted" class="form-checkbox rounded text-pink-500" />
      </div>
      <button v-on:click="createNewUser" class="text-white bg-indigo-500 border-0 py-2 px-8 focus:outline-none hover:bg-indigo-600 rounded text-lg">登録してみる</button>
      <p class="text-xs text-gray-500 mt-3">求職を開始にチェックすると条件の良い病院からスカウトがくるかもしれません♪</p>
    </div>
  </div>
</section>
</template>


<script>
import axios from 'axios'
// export default でメンバーを囲むことで、外部からも参照できるようにする。
export default {
  setup() {
    function createNewUser() {
      axios.post('http://localhost:3000/api/user', {
        name: "mochichann",
        email: "mocanntijijy@mochichan.com",
        password: "password"
      })
      .then(function (response) {
        console.log(response)
        })
      .catch(function (error) {
         console.log(error)
      })
    }
    return {
      createNewUser
    }
  }
}

</script>
