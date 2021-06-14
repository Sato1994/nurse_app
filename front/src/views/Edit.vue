<template>
<section class="text-gray-600 body-font">
  <div class="container px-5 py-24 mx-auto flex flex-wrap items-center">
    
    
    <div class="lg:w-2/6 md:w-1/2 bg-gray-100 rounded-lg p-8 flex flex-col md:ml-auto w-full mt-10 md:mt-0">
      <h2 class="text-gray-900 text-lg font-medium title-font mb-5">Model編集</h2>

      <div class="relative mb-4">
        <label for="full-name"  class="leading-7 text-sm text-gray-600">名前</label>
        <input v-model="target.name" type="text"  id="name" name="name" class="w-full bg-white rounded border border-gray-300 focus:border-pink-500 focus:ring-2 focus:ring-pink-200 text-base outline-none text-gray-700 py-1 px-3 leading-8 transition-colors duration-200 ease-in-out">
      </div>

      <div class="relative mb-4">
        <label for="address" class="leading-7 text-sm text-gray-600">住所</label>
        <input v-model ="postalCode" @input="getAddress(postalCode)" placeholder="郵便番号を入力してください" class="w-full bg-white rounded border border-gray-300 focus:border-pink-500 focus:ring-2 focus:ring-pink-200 text-base outline-none text-gray-700 py-1 px-3 leading-8 transition-colors duration-200 ease-in-out">
        <input v-model="target.address" readonly type="text" id="address" name="address" class="w-full bg-white rounded border border-gray-300 focus:border-pink-500 focus:ring-2 focus:ring-pink-200 text-base outline-none text-gray-700 py-1 px-3 leading-8 transition-colors duration-200 ease-in-out">
      </div>

      <div class="relative mb-4">
        <label for="wanted" class="leading-7 text-sm text-gray-600">求職中？</label>
        <input v-model="target.wanted" type="radio" id="wanted" name="wanted" value="false" class="w-full bg-white rounded border border-gray-300 focus:border-pink-500 focus:ring-2 focus:ring-pink-200 text-base outline-none text-gray-700 py-1 px-3 leading-8 transition-colors duration-200 ease-in-out">
        <input v-model="target.wanted" type="radio" id="wanted" name="wated" value="true" class="w-full bg-white rounded border border-gray-300 focus:border-pink-500 focus:ring-2 focus:ring-pink-200 text-base outline-none text-gray-700 py-1 px-3 leading-8 transition-colors duration-200 ease-in-out">
      </div>

      <div class="relative mb-4">
        <label for="sex" class="leading-7 text-sm text-gray-600">性別</label>
        <input v-model="target.sex" type="radio" id="sex" name="sex" value="false" class="w-full bg-white rounded border border-gray-300 focus:border-pink-500 focus:ring-2 focus:ring-pink-200 text-base outline-none text-gray-700 py-1 px-3 leading-8 transition-colors duration-200 ease-in-out">
        <input v-model="target.sex" type="radio" id="sex" name="sex" value="true" class="w-full bg-white rounded border border-gray-300 focus:border-pink-500 focus:ring-2 focus:ring-pink-200 text-base outline-none text-gray-700 py-1 px-3 leading-8 transition-colors duration-200 ease-in-out">
      </div>

      <div class="relative mb-4">
        <label for="age" class="leading-7 text-sm text-gray-600">年齢</label>
        <input v-model="target.age" type="number" id="age" name="age" class="w-full bg-white rounded border border-gray-300 focus:border-pink-500 focus:ring-2 focus:ring-pink-200 text-base outline-none text-gray-700 py-1 px-3 leading-8 transition-colors duration-200 ease-in-out">
      </div>

      <div class="relative mb-4">
        <label for="year" class="leading-7 text-sm text-gray-600">経験年数</label>
        <input v-model="target.year" type="number" id="year" name="year" class="w-full bg-white rounded border border-gray-300 focus:border-pink-500 focus:ring-2 focus:ring-pink-200 text-base outline-none text-gray-700 py-1 px-3 leading-8 transition-colors duration-200 ease-in-out">
      </div>

      <div class="relative mb-4">
        <label for="profile" class="leading-7 text-sm text-gray-600">紹介文</label>
        <textarea v-model="target.profile" type="text" id="profile" name="profile" class="w-full bg-white rounded border border-gray-300 focus:border-pink-500 focus:ring-2 focus:ring-pink-200 text-base outline-none text-gray-700 py-1 px-3 leading-8 transition-colors duration-200 ease-in-out"></textarea>
      </div>

      <div class="relative mb-4">
        <label for="myid" class="leading-7 text-sm text-gray-600">myid</label>
        <input v-model="target.myid" type="text" id="myid" name="myid" class="w-full bg-white rounded border border-gray-300 focus:border-pink-500 focus:ring-2 focus:ring-pink-200 text-base outline-none text-gray-700 py-1 px-3 leading-8 transition-colors duration-200 ease-in-out">
      </div>

      

      <button @click="saveTarget" class="text-white bg-pink-500 border-0 py-2 px-8 focus:outline-none hover:bg-pink-600 rounded text-lg">Button</button>
      <p class="text-xs text-gray-500 mt-3">Literally you probably haven't heard of them jean shorts.</p>
    </div>
  </div>
</section>

</template>

<script>
import axios from 'axios'
export default {

  data() {
    return {
      target: {},
      postalCode: "",
    }
  },
  mounted() {
    this.target = this.$store.getters['target/getTarget']
  },

  methods: {
    saveTarget() {
      axios.put('http://localhost:3000/api/user', {
        name: this.target.name,
        address: this.target.address,
        wanted: this.target.wanted,
        sex: this.target.sex,
        age: this.target.age,
        year: this.target.year,
        profile: this.target.profile,
        myid: this.target.myid,
      },{
        headers: {
          "Content-Type": "application/json",
          uid: localStorage.getItem('uid'),
          "access-token": localStorage.getItem('access-token'),
          client: localStorage.getItem('client')
        }
      })
      .then((response) => {
        //vuexのtargetをresponse.dataを使って更新
        this.$store.dispatch('target/saveTarget', response.data.data)
        console.log('れすぽんすでーた',response.data)
        this.$router.push( {name: 'UserIndividual', params: { myid: response.data.data.myid }})
        })
      .catch((error) => {
        console.log(error)
       })
    },
    getAddress(postalCode) {
      axios.get(`https://api.zipaddress.net/?zipcode=${postalCode}`)
      .then(response => {
        console.log(response.data)
        this.target.address = response.data.data.fullAddress
      })
      .catch(error => {
        console.log(error)

      })
    }
  }
}
</script>