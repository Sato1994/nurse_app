<template>
<section class="text-gray-600 body-font">
  <div class="container px-5 py-24 mx-auto flex flex-wrap">
    <div class="lg:w-2/3 mx-auto">

      <div class="flex flex-wrap w-full bg-gray-100 py-32 px-10 relative mb-4">
        <div class="text-center relative z-10 w-full">
          <h2 class="text-2xl text-gray-900 font-medium title-font mb-2">ログアウトしますか？</h2>
          <div class="flex justify-center">
            <button @click="signOut" class="inline-flex text-white bg-pink-500 border-0 py-2 px-6 focus:outline-none hover:bg-pink-600 rounded text-lg">ログアウト</button>
            <button class="ml-4 inline-flex text-gray-700 bg-gray-300 border-0 py-2 px-6 focus:outline-none hover:bg-gray-200 rounded text-lg">キャンセル</button>
          </div>
        </div>
      </div>

    </div>
  </div>
</section>
</template>





<script>
import axios from 'axios'
export default {

  data() {
    return {
      uid: localStorage.getItem("uid"),
      access_token: localStorage.getItem("access-token"),
      client: localStorage.getItem("client"),
    }

  },
  methods: {
    signOut() {
      console.log(this.uid, this.access_token, this.client)
      axios.delete('http://localhost:3000/api/user/sign_out', {
        headers: {
          uid: this.uid,
          'access-token': this.access_token,
          client: this.client
        }
      })
      .then((response) => {
        console.log('サインアウト成功', response)
        localStorage.removeItem('uid')
        localStorage.removeItem('access-token')
        localStorage.removeItem('client')
      })
      .catch((error) => {
        console.log(error)
      })
    }
  }

}


</script>