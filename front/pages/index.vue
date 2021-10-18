<template>
  <TargetCards :targets="targets" />
</template>

<script>
import TargetCards from "@/components/pages/TargetCards.vue";
// import axios from "axios";
export default {
  components: {
    TargetCards,
  },
  data: () => ({
    targets: [],
  }),
 
  // async asyncData() {
  //   try {
  //     const response = await axios.get("http://web:3000/api/hosts");
  //     return {
  //       targets: response.data,
  //     };
  //   } catch (error) {
  //     console.log(error);
  //   }
  // },
  computed: {
    mypageURL() {
      return `/${this.$cookies.get('user')}/${this.$store.state.myInfo.myInfo.myid}`
    }
  },
  created() {
    this.$axios.get(`/api/${this.$cookies.get('user') === 'user' ? 'host' : 'user'}s`)
    .then((response) => {
     this.targets = response.data;
    })
    .catch((error) => {
      console.log(error)
    })
  },
};
</script>
