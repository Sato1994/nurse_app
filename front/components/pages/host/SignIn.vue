<template>
  <v-form
    ref="form"
    v-model="valid"
    lazy-validation
  >
    <v-text-field
      v-model="auth.email"
      :rules="emailRules"
      label="メールアドレス"
      required
    ></v-text-field>

    <v-text-field
      v-model="auth.password"
      label="パスワード"
      required
    ></v-text-field>


    <v-btn
      :disabled="!valid"
      color="success"
      class="mr-4"
      @click="validate"
    >
      Validate
    </v-btn>

    <v-btn
      color="error"
      class="mr-4"
      @click="reset"
    >
      Reset Form
    </v-btn>

    <v-btn
      color="warning"
      @click="resetValidation"
    >
      Reset Validation
    </v-btn>

    <v-btn
      color="success"
      @click="signIn"
    >
    ログイン
    </v-btn>
  </v-form>
</template>

<script>
import axios from 'axios'
  export default {

    data: () => ({
      auth: {
        email: '',
        password: '',
      },

      valid: true,
   
      emailRules: [
        v => !!v || 'メールアドレスは必須です',
        v => /.+@.+\..+/.test(v) || 'E-mail must be valid',
      ],
    
    }),

    methods: {
      validate () {
        this.$refs.form.validate()
      },
      reset () {
        this.$refs.form.reset()
      },
      resetValidation () {
        this.$refs.form.resetValidation()
      },
      signIn() {
        axios.post('http://localhost:3000/api/host/sign_in', this.auth)
        .then((response) => {
          const authInfo = {
            "access-token": response.headers["access-token"],
            client: response.headers.client,
            uid: response.headers.uid,
          }

          // cookieへ認証tokenをセット
          this.$cookies.set("authInfo", authInfo);

          // cookieへuser or hostセット
          this.$cookies.set("user", "host");

          this.$router.push(`/host/${response.data.data.myid}`)
          this.$modal.hide('host-auth-modal')
          this.$store.dispatch('myInfo/saveMyInfo', response.data.data)

          console.log("こんそるろぐ", response.data.data);

          this.$axios.get(`http://localhost:3000/api/${this.$cookies.get("user")}s/${response.data.data.myid}`, {headers: this.$cookies.get('authInfo')})
            .then((response) => {
              this.$store.dispatch("myInfo/saveMySkills", response.data.target_skills)
              this.$store.dispatch("myInfo/saveMyTimes", response.data.target_times)
              this.$store.dispatch("myInfo/saveMyRequests", response.data.requests)
              this.$store.dispatch("myInfo/saveMyAgreements", response.data.agreements)
            });
        })
        .catch((error) => {
          console.log('認証失敗', error)
        }) 
      }
    },







  }




</script>


