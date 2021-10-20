<template>
  <v-form
    ref="form"
    v-model="valid"
    lazy-validation
  >
    <v-text-field
      v-model="myInfo.name"
      :counter="10"
      :rules="nameRules"
      label="名前（フルネーム）"
      required
    ></v-text-field>

    <v-text-field
      v-model="myInfo.myid"
      label="サイト内ID"
      required
    ></v-text-field>

    <v-text-field
      v-model="myInfo.email"
      :rules="emailRules"
      label="メールアドレス"
      required
    ></v-text-field>

    <v-text-field
      v-model="myInfo.address"
      label="住所"
      required
    ></v-text-field>


    <v-textarea
      v-model="myInfo.profile"
      label="紹介文"
      required
    ></v-textarea>

    



    <v-text-field
      v-model="myInfo.password"
      label="パスワード"
      required
    ></v-text-field>


    <v-text-field
      v-model="myInfo.password_confirmation"
      label="パスワード確認用"
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
      @click="signUp"
    >
    登録する
    </v-btn>
  </v-form>
</template>

<script>

// name, email, address, profile, password, password_confirmation, myid,
import axios from 'axios'
  export default {

    data: () => ({
      myInfo: {
        name: '',
        email: '',
        myid: '',
        address: '',
        profile: '',
        password: '',
        password_confirmation: '',
      },

      valid: true,
      nameRules: [
        v => !!v || '名前は必須です',
        v => (v && v.length <= 10) || 'Name must be less than 10 characters',
      ],
      emailRules: [
        v => !!v || 'メールアドレスは必須です',
        v => /.+@.+\..+/.test(v) || 'E-mail must be valid',
      ],
      select: null,
      items: [
        'Item 1',
        'Item 2',
        'Item 3',
        'Item 4',
      ],
      checkbox: false,
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
      signUp() {
        axios.post('http://localhost:3000/api/host', this.myInfo)
        .then((response) => {
          this.$router.push(`/host/${response.data.data.myid}`)
          console.log('signUpのresponse', response.data.data)
          
          this.$store.dispatch('myInfo/saveMyInfo', response.data.data)
          this.$modal.hide('host-modal')

         const authInfo = {
            "access-token": response.headers["access-token"],
            client: response.headers.client,
            uid: response.headers.uid,
          };

           // cookieへ認証tokenをセット
          this.$cookies.set("authInfo", authInfo);
          // cookieへuser or hostセット
          this.$cookies.set("user", "host");

          //  this.$axios.get(`http://localhost:3000/api/${this.$cookies.get("user")}s/${response.data.data.myid}`)
          //  .then((response) => {
          //   this.$store.dispatch("myInfo/saveMySkills", response.data.target_skills)
          //   this.$store.dispatch("myInfo/saveMyTimes", response.data.target_times)
          //  });
        })
        .catch((error) => {
          console.log('登録失敗', error)
        }) 
      }
    },
  }
</script>