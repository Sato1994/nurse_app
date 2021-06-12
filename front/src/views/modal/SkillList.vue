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
      <Label :text="targetSkill.name" @click="removeTargetSkill(targetSkill.id)" />
      </div>
    </div>

    <div class=" border-t border-gray-200 flex-col px-6 py-5 bg-gray-50">
      <SearchBox  @change="changeValue" placeholder="スキルを検索" />
    </div>

    <div class=" border-t border-gray-200 flex-col px-6 py-5 bg-gray-50">
      <h1>未登録スキル一覧</h1>
      <div v-for="unselectedSkill of unselectedSkills" :key="unselectedSkill.name" class="inline-block rounded-full text-white bg-yellow-400 hover:bg-yellow-500 duration-300 text-xs font-bold mr-1 md:mr-2 mb-2 px-2 md:px-4 py-1 opacity-90 hover:opacity-100">
          <Label :text="unselectedSkill.name" @click="addTargetSkill(unselectedSkill.id)" />
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
  data() {
    return {
      uid: localStorage.getItem("uid"),
      access_token: localStorage.getItem("access-token"),
      client: localStorage.getItem("client"),
      value: ""
    }
  },
  props: {
    targetSkills: Object
  },
  methods: {
    closeModal() {
      this.$emit('close-button-click')
    },
    changeValue(newValue) {
      this.value = newValue
    },
    addTargetSkill(e) {
      console.log(this.uid, this.access_token, this.client)
      axios.post(`http://localhost:3000/api/skills/${e}/user_skills`, {}, {
        headers: {
          uid: this.uid,
          'access-token': this.access_token,
          client: this.client,
          'content-type': 'application/json'
        }
      })
      .then(response => {
        console.log(response.data)

        this.$emit('add-skill-button-click', response.data)
      })
      .catch(error => {
        console.log(error)
      })
    },
    removeTargetSkill(e) {
      axios.delete(`http://localhost:3000/api/user_skills/${e}`, {
        headers: {
          uid: this.uid,
          'access-token': this.access_token,
          client: this.client,
          'content-type': 'application/json'
        }
      })
      .then(response => {
        console.log(response.data)
        this.$emit('remove-skill-button-click', response.data)
      })
      .catch(error => {
        console.log(error)
      })
    },
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
    const searchedSkills = unselectedSkills.filter(obj => (obj.name).includes(this.value))
    return searchedSkills
    }
  }
}

</script>