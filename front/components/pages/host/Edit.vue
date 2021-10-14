<template>
  <v-form ref="form" v-model="valid" lazy-validation>
    <v-text-field
      v-model="copiedMyInfo.name"
      :counter="10"
      :rules="nameRules"
      label="名前（フルネーム）"
      required
    ></v-text-field>

    <v-text-field v-model="postalCode" label="郵便番号" required></v-text-field>
    <v-btn color="success" @click="getAddress"> 住所を検索する</v-btn>

    <v-text-field
      v-model="copiedMyInfo.address"
      label="住所"
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

      <v-switch
      v-model="copiedMyInfo.wanted"
      label="募集中かどうか"
      ></v-switch>


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
    postalCode: "",
    valid: true,
    nameRules: [
      (v) => !!v || "名前は必須です",
      (v) => (v && v.length <= 10) || "Name must be less than 10 characters",
    ],
  }),
  // computed: {
  //   copiedMyInfo() {
  //     const myInfo = this.$store.getters["myInfo/getMyInfo"];
  //     const copied = Object.assign({}, myInfo);
  //     return copied;
  //   },
  // },
  mounted() {
    this.authInfo = this.$cookies.get("authInfo");
    const myInfo = this.$store.getters["myInfo/getMyInfo"];
    // storeから直接とってきたものをいじると怒られる
    this.copiedMyInfo = Object.assign({}, myInfo);
  },

  methods: {
    editUser() {
      axios
        .put("http://localhost:3000/api/host", this.copiedMyInfo, {
          headers: this.authInfo,
        })
        .then((response) => {
          this.$router.push(`/host/${response.data.data.myid}`);
          this.$modal.hide("edit-modal");
          console.log("editのresponse", response.data);
          this.$store.dispatch("myInfo/saveMyInfo", response.data.data);
          // this.$emit("edit-button-click", response.data.data);
        })
        .catch((error) => {
          console.log("登録失敗", error);
        });
    },
    getAddress() {
      axios
        .get(`https://api.zipaddress.net/?zipcode=${this.postalCode}`)
        .then((response) => {
          console.log(response.data);
          this.copiedMyInfo.address = response.data.data.fullAddress;
        })
        .catch((error) => {
          console.log(error);
        });
    },
  },
};
</script>
