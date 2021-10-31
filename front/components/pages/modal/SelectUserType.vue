<template>
<div>

<v-btn
      color="success"
      @click="signInAsUser"
    >
    看護師としてサインインする
</v-btn>
<v-btn
      color="success"
      @click="signInAsHost"
    >
    病棟としてサインインする
</v-btn>

</div>



</template>

<script>
export default {
  data: () => ({
    
  }),
  methods: {
    signInAsUser() {
      this.$modal.hide("select-user-type-modal")
      this.$modal.show("sign-in-modal");
      this.$cookies.set('user', 'user')
    },
    signInAsHost() {
      this.$modal.hide("select-user-type-modal")
      this.$modal.show("sign-in-modal")
      this.$cookies.set('user', 'host')
    },
  }
}


</script>
