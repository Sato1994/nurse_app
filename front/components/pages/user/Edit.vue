<template>
  <v-form ref="form" v-model="valid" lazy-validation>
    <v-text-field
      v-model="copiedMyInfo.name"
      :counter="10"
      :rules="nameRules"
      label="名前（フルネーム）"
      required
    ></v-text-field>

    <v-text-field
      v-model="copiedMyInfo.address"
      label="住所"
      required
    ></v-text-field>

    <v-text-field
      v-model="copiedMyInfo.age"
      label="年齢"
      required
    ></v-text-field>

    <v-text-field
      v-model="copiedMyInfo.year"
      label="経験年数"
      required
    ></v-text-field>

    <v-textarea
      v-model="copiedMyInfo.profile"
      label="紹介文"
      required
    ></v-textarea>

    <v-text-field
      v-model="copiedMyInfo.myid"
      label="サイト内ID"
      required
    ></v-text-field>

    <v-select
      v-model="copiedMyInfo.sex"
      :items="sex"
      color="pink"
      label="性別"
      required
    ></v-select>

    <v-btn color="success" @click="editUser"> 登録する </v-btn>
  </v-form>
</template>

<script>
import axios from "axios";
export default {
  data: () => ({
    // myInfo: {},
    copiedMyInfo: {},
    authInfo: {},
    valid: true,
    nameRules: [
      (v) => !!v || "名前は必須です",
      (v) => (v && v.length <= 10) || "Name must be less than 10 characters",
    ],
    sex: ["男性", "女性"],
  }),
  // computed: {
  //   copiedMyInfo() {
  //     const myInfo = this.$store.getters["myInfo/getMyInfo"];
  //     const copied = Object.assign({}, myInfo);
  //     return copied;
  //   },
  // },
  mounted() {
    this.authInfo = this.$store.getters["myInfo/getAuthInfo"];
    const myInfo = this.$store.getters["myInfo/getMyInfo"];
    this.copiedMyInfo = Object.assign({}, myInfo);
  },

  methods: {
    editUser() {
      axios
        .put("http://localhost:3000/api/user", this.copiedMyInfo, {
          headers: {
            "Content-Type": "application/json",
            uid: this.authInfo.uid,
            "access-token": this.authInfo.accessToken,
            client: this.authInfo.client,
          },
        })
        .then((response) => {
          this.$router.push(`/user/${response.data.data.myid}`);
          this.$modal.hide("edit-modal");
          console.log("こんそるろぐ", response.data);
          this.$store.dispatch("myInfo/saveMyInfoAsUser", response.data.data);
          this.$emit("edit-button-click", response.data.data);
        })
        .catch((error) => {
          console.log("登録失敗", error);
        });
    },
  },
};
</script>
