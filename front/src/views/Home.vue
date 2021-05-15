<template>

<section class="text-gray-600 body-font">
  <div class="container px-5 py-24 mx-auto">
    <div class="flex flex-wrap w-full mb-20 flex-col items-center text-center">
      <h1 class="sm:text-3xl text-2xl font-medium title-font mb-2 text-gray-900">Home.vueは病院一覧</h1>
      <p class="lg:w-1/2 w-full leading-relaxed text-gray-500">病院一覧です</p>
    </div>


       <TargetsCard :targets="targets" />


    <button class="flex mx-auto mt-16 text-white bg-indigo-500 border-0 py-2 px-8 focus:outline-none hover:bg-indigo-600 rounded text-lg">Button</button>
  </div>
</section>

</template>




<script>
import TargetsCard from '@/components/TargetsCard.vue'
import axios from 'axios'
export default {

  components: {
    TargetsCard
  },

  data() {
    return {
      targets: [],
    }
  },
  created() {
    axios.get('http://localhost:3000/api/hosts')
    .then(response => {
      this.targets = response.data
      console.log(response.data)
    })
    .catch(error => {
      console.log(error)
    })
  }



}



</script>