<template>

<section class="text-gray-600">
  <div class="container px-5 py-24 mx-auto flex flex-col">
    <div class="lg:w-4/6 mx-auto">
      <div class="rounded-lg h-64 overflow-hidden">
        <img alt="content" class="object-cover object-center h-full w-full" src="https://dummyimage.com/1200x500">
      </div>
      <div class="flex flex-col sm:flex-row mt-10">
        <div class="sm:w-1/3 text-center sm:pr-8 sm:py-8">
          <div class="w-20 h-20 rounded-full inline-flex items-center justify-center bg-gray-200 text-gray-400">
            <svg fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" class="w-10 h-10" viewBox="0 0 24 24">
              <path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"></path>
              <circle cx="12" cy="7" r="4"></circle>
            </svg>
          </div>
          <div class="flex flex-col items-center text-center justify-center">






            <h2 class="font-medium title-font mt-4 text-gray-900 text-lg">ID:{{target.myid}}</h2>


            <div class="w-12 h-1 bg-pink-500 rounded mt-2 mb-4"></div>
            <p class="text-base">Raclette knausgaard hella meggs normcore williamsburg enamel pin sartorial venmo tbh hot chicken gentrify portland.</p>
          </div>

          <div class="flex justify-center">
            <router-link :to="{ name: 'SignOut' }" class="inline-flex text-white bg-pink-500 border-0 py-2 px-6 focus:outline-none hover:bg-pink-600 rounded text-lg">ログアウト</router-link>
          </div>

          <div class="flex justify-center">
            <router-link :to="{ name: 'Edit', params: { myid: target.myid }}" class="inline-flex text-white bg-pink-500 border-0 py-2 px-6 focus:outline-none hover:bg-pink-600 rounded text-lg">プロフィールを編集</router-link>
          </div>

        </div>

        <div class="sm:w-2/3 sm:pl-8 sm:py-8 sm:border-l border-gray-200 sm:border-t-0 border-t mt-4 pt-4 sm:mt-0 text-center sm:text-left">
          <div  v-for="targetSkill of targetSkills" :key="targetSkill.name" class="inline-block rounded-full text-white bg-yellow-400 hover:bg-yellow-500 duration-300 text-xs font-bold mr-1
                      md:mr-2 mb-2 px-2 md:px-4 py-1 opacity-90 hover:opacity-100" >
            <Label :text="targetSkill.name" />
          </div>


          <button @click="openModal" class="bg-gray-200">スキルを追加する</button>
          <SkillList :targetSkills="targetSkills" v-show="showContent" @close-button-click="closeModal"></SkillList>


          <p class="leading-relaxed text-lg mb-4">{{target.profile}}</p>
          <a class="text-pink-500 inline-flex items-center">Learn More
            <svg fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" class="w-4 h-4 ml-2" viewBox="0 0 24 24">
              <path d="M5 12h14M12 5l7 7-7 7"></path>
            </svg>
          </a>
        </div>

      </div>
    </div>
  </div>
</section>



</template>


<script>
import axios from 'axios'
import Label from '@/components/atoms/Label.vue'
import SkillList from '@/views/modal/SkillList.vue'

export default {
  components: {
    Label,
    SkillList,
  },
  data() {
    return {
      // target: {},
      // targetSkills: [],
      showContent: false,
    }
  },

  methods: {
    openModal() {
      this.showContent = true
    },
    closeModal() {
      this.showContent = false
    }
  },
  computed: {
    target() {
      return this.$store.getters['target/getTarget']
    },
    targetSkills() {
      return this.$store.getters['target/getSkills']
    },

  },

  mounted() {
    // $route.params.myidで遷移元のparamsを受け取れる。
    // URLに適当に入力されてもmyidがないならnotfound表示。
    axios.get(`http://localhost:3000/api/users/${this.$route.params.myid}`)
    .then(response => {
        // this.target = response.data.user
        // this.targetSkills = response.data.target_skills
        this.$store.dispatch('target/saveTarget', response.data.user)
        this.$store.dispatch('target/saveSkills', response.data.target_skills)
        console.log('れすぽんすでーた',response.data)
    })
    .catch(error => {
      if (error.response.status === 404) {
        this.$router.replace({path: '/notfound'})
        console.log('404エラーでnotfound表示',error.response.status, error)
      }else{
      console.log('404エラー以外なのでnotfound表示は無し。',error.response.status, error)
      }
    })
  },

  // 同じコンポーネントを使用しているとURLを変更しても遷移されない問題を解決
  // watch: {
  //   $route() {
  //     axios.get(`http://localhost:3000/api/users/${this.$route.params.myid}`)
  //     .then(response => {
  //       this.target = response.data.user
  //       this.targetSkill = response.data.skills
  //       console.log('URLが変更されたのでwatchが作動',)
  //   })
  //     console.log('watch', this.$route.params.myid)
  //   }
  // }
  
}

</script>
