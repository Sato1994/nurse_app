<template>
<div>
  <TargetCards :targets="targets" />
  <infinite-loading @infinite="infiniteHandler"></infinite-loading>
</div>
</template>

<script>
import TargetCards from "@/components/pages/TargetCards.vue";
export default {
  components: {
    TargetCards,
  },
  data: () => ({
    targets: [],
    page: 1,
  }),
  methods: {
    infiniteHandler($state) {
      this.$axios.get(`/api/${this.$cookies.get('user') === 'user' ? 'host' : 'user'}s`, {
        params: {
          page: this.page
        },
      })
      .then((response) => {
        setTimeout(() => {
          if (this.page <= response.data.kaminari.pagination.pages) {
            this.page += 1
            this.targets.push(...response.data.users)
            $state.loaded()
          } else {
            $state.complete()
          }
        }, 700)
      }).catch((error) => {
        $state.complete()
        console.log(error)
      })
    }
  },

  computed: {
    mypageURL() {
      return `/${this.$cookies.get('user')}/${this.$store.state.myInfo.myInfo.myid}`
    }
  },
};
</script>
