<template>
  <TargetCards :targets="targets" />
</template>

<script>
import TargetCards from "@/components/pages/TargetCards.vue";
import axios from "axios";
export default {
  components: {
    TargetCards,
  },

  async asyncData() {
    try {
      const response = await axios.get("http://web:3000/api/hosts");
      return {
        targets: response.data,
      };
    } catch (error) {
      console.log(error);
    }
  },

  data() {
    return {
      links: ["Dashboard", "Messages", "Profile", "Updates"],
    };
  },
};
</script>
