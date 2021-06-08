<template>
<div class=" bg-opacity-70 bg-gray-300 z-1 fixed top-0 left-0 w-full h-full    flex justify-center h-screen items-center bg-gray-200 antialiased">
  <div class=" z-10  p-4 bg-white  flex flex-col w-11/12 sm:w-5/6 lg:w-1/2 max-w-2xl mx-auto rounded-lg border border-gray-300 shadow-xl">
    <div class="flex flex-row justify-between p-6 bg-white border-b border-gray-200 rounded-tl-lg rounded-tr-lg">
      <p class=" ">スキルを登録する</p>
      <button @click="closeModal">
        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
        </svg>
      </button>
    </div>

    <div class=" flex-col px-6 py-5 bg-gray-50">
      <h1>現在の所持スキル</h1>
      <div v-for="targetSkill of targetSkills" :key="targetSkill.name" class="inline-block rounded-full text-white bg-yellow-400 hover:bg-yellow-500 duration-300 text-xs font-bold mr-1 md:mr-2 mb-2 px-2 md:px-4 py-1 opacity-90 hover:opacity-100">
      <Label :text="targetSkill.name" />
      </div>
    </div>

    <div class=" border-t border-gray-200 flex-col px-6 py-5 bg-gray-50">
      <SearchBox placeholder="スキルを検索" />
    </div>

    <div class=" border-t border-gray-200 flex-col px-6 py-5 bg-gray-50">
      <h1>未登録スキル一覧</h1>
      <div v-for="unselectedSkill of unselectedSkills" :key="unselectedSkill.name" class="inline-block rounded-full text-white bg-yellow-400 hover:bg-yellow-500 duration-300 text-xs font-bold mr-1 md:mr-2 mb-2 px-2 md:px-4 py-1 opacity-90 hover:opacity-100">
      <Label :text="unselectedSkill.name" />
      </div>
    </div>

    <div class="flex flex-row items-center justify-between p-5 bg-white border-t border-gray-200 rounded-bl-lg rounded-br-lg">
      <Button text="登録する" class="px-4 py-2 text-white font-semibold bg-blue-500 rounded" />
    </div>
  </div>
</div>


</template>

<script>
import axios from 'axios'
import Label from '@/components/atoms/Label.vue'
import SearchBox from '@/components/atoms/SearchBox.vue'
import Button from '@/components/atoms/Button.vue'

export default {

  components: {
    Label,
    SearchBox,
    Button,
  },
  props: {
    targetSkills: Object
  },
  methods: {
    closeModal() {
      this.$emit('close-button-click')
    },
  //   stopPropagation() {
  //     event.stopPropagation()
  //   }
  },

  mounted() {
    axios.get('http://localhost:3000/api/skills')
    .then(response => {
      this.$store.dispatch('skill/saveAllSkills', response.data)
    })
    .catch(error => {
      console.log('mountedでエラー', error)
    })
  },

  computed: {
    unselectedSkills() {
    //すべてのスキルから登録スキルを引いたものをオブジェクトにする
    const userSkills  = this.$store.getters['target/getSkills']
    const allSkills = this.$store.getters['skill/getAllSkills']
    const unselectedSkills = allSkills.filter(obj => !userSkills.map(obj=>obj.id).includes(obj.id))
    return unselectedSkills
    }
  }



}

</script>



<style>

</style>