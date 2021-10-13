<template>
  <v-form ref="form" v-model="valid" lazy-validation>
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

    <v-btn :disabled="!valid" color="success" class="mr-4" @click="validate">
      Validate
    </v-btn>

    <v-btn color="error" class="mr-4" @click="reset"> Reset Form </v-btn>

    <v-btn color="warning" @click="resetValidation"> Reset Validation </v-btn>

    <v-btn color="success" @click="signIn"> 登録する </v-btn>
  </v-form>
</template>

<script>
import axios from "axios";
export default {
  data: () => ({
    auth: {
      email: "",
      password: "",
    },

    valid: true,

    emailRules: [
      (v) => !!v || "メールアドレスは必須です",
      (v) => /.+@.+\..+/.test(v) || "E-mail must be valid",
    ],
  }),

  methods: {
    validate() {
      this.$refs.form.validate();
    },
    reset() {
      this.$refs.form.reset();
    },
    resetValidation() {
      this.$refs.form.resetValidation();
    },

    // サインインでやること。
    // axiosで登録しaccess token等をcookieへ保存し_id.vueへ。
    //
    signIn() {
      axios
        .post("http://localhost:3000/api/user/sign_in", this.auth)
        .then((response) => {
          const authInfo = {
            "access-token": response.headers["access-token"],
            client: response.headers.client,
            uid: response.headers.uid,
          };

          // cookieへ認証tokenをセット
          this.$cookies.set("authInfo", authInfo);

          this.$router.push(`/user/${response.data.data.myid}`);
          this.$modal.hide("user-auth-modal");
          this.$store.dispatch("myInfo/saveMyInfoAsUser", response.data.data);

          console.log("こんそるろぐ", response.data.data);
        })
        .catch((error) => {
          console.log("認証失敗", error);
        });
    },
  },
};
</script>
