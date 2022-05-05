<template>
  <v-card align="center" height="350" flat tile color="green" dark>
    <v-card-text class="body-1 pb-0 pt-2"> welcome</v-card-text>

    <v-card-text class="text-h3 py-0"> nurse-hop.com</v-card-text>

    <v-card-actions class="justify-center">
      <v-btn text @click="signIn"> ログイン </v-btn>

      <v-btn text @click="signUp"> 新規登録 </v-btn>
    </v-card-actions>

    <div>
      <v-img width="150" src="/image/nurse_hop_logo.png"></v-img>
    </div>

    <SignUp :signUpDisplay="signUpDisplay" @close-sign-up-click="closeSignUp" />
    <SignIn :signInDisplay="signInDisplay" @close-sign-in-click="closeSignIn" />
    <SelectType
      :selectTypeDisplay="selectTypeDisplay"
      @close-select-type-click="closeSelectType"
      @select-click="actionSelectedType"
    />
  </v-card>
</template>



<script>
import SignUp from '@/components/dialog/SignUp.vue'
import SignIn from '@/components/dialog/SignIn.vue'
import SelectType from '@/components/dialog/SelectType.vue'
export default {
  components: {
    SignUp,
    SignIn,
    SelectType,
  },
  middleware: 'auth',

  data() {
    return {
      selectTypeDisplay: false,
      signInDisplay: false,
      signUpDisplay: false,
      sign: null,
    }
  },

  methods: {
    signIn() {
      this.sign = 'in'
      this.selectTypeDisplay = true
    },

    signUp() {
      this.sign = 'up'
      this.selectTypeDisplay = true
    },

    closeSelectType() {
      this.selectTypeDisplay = false
    },

    closeSignIn() {
      this.signInDisplay = false
    },

    closeSignUp() {
      this.signUpDisplay = false
    },

    actionSelectedType() {
      this.closeSelectType()
      if (this.sign === 'in') {
        this.signInDisplay = true
      } else if (this.sign === 'up') {
        this.signUpDisplay = true
      }
    },
  },
}
</script>
