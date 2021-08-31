<template>
  <TargetCards :targets="targets" />        
</template>

<script>
import TargetCards from '@/components/pages/TargetCards.vue'
import axios from 'axios'
  export default {
    components: {
      TargetCards
    },

    asyncData () {
      return axios.get('http://web:3000/api/hosts')
      .then(response => {
        return {
          targets: response.data
        }
      })
    },


    data() {
      return {
        links: [
        'Dashboard',
        'Messages',
        'Profile',
        'Updates',
        ],
      }
    },

  }
</script>