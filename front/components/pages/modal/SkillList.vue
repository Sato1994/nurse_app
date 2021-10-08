<template>
  <v-card>
    <v-card-title>取得済みスキル一覧</v-card-title>
    <v-card-text>
      <div class="text-center">
        <v-chip
          @click="removeMySkill(skill.id)"
          v-for="skill in mySkills"
          :key="skill.id"
          class="ma-1"
          color="orange"
          text-color="white"
        >
          {{ skill.name }}
        </v-chip>
      </div>
    </v-card-text>
    <v-divider class="mx-4"></v-divider>
    <v-card-title>未取得のスキル一覧</v-card-title>
    <v-card-text>
      <div class="text-center">
        <v-chip
          @click="addMySkill(unselectedSkill.id)"
          v-for="unselectedSkill in unselectedSkills"
          :key="unselectedSkill.id"
          class="ma-1"
          color="orange"
          text-color="white"
        >
          {{ unselectedSkill.name }}
        </v-chip>
      </div>
    </v-card-text>
  </v-card>
</template>

<script>
import axios from "axios";

export default {
  data: () => ({
    // mySkills: [],
    uid: "",
    access_token: "",
    client: "",

    skills: [],
    // value: "",
  }),
  computed: {
    unselectedSkills() {
      const mySkills = this.$store.getters["myInfo/getMySkills"];
      const unselectedSkills = this.skills.filter(
        (obj) => !mySkills.map((obj) => obj.id).includes(obj.id)
      );
      // const searchedSkills = unselectedSkills.filter((obj) =>
      //   obj.name.includes(this.value)
      // );
      // return searchedSkills;
      return unselectedSkills;
    },
  },
  props: {
    mySkills: Array,
  },

  mounted() {
    const auth = this.$store.getters["myInfo/getAuthInfo"];
    this.uid = auth.uid;
    this.access_token = auth.accessToken;
    this.client = auth.client;
    axios
      .get("http://localhost:3000/api/skills")
      .then((response) => {
        this.skills = response.data;
        console.log("skillsをセット", response.data);
      })
      .catch((error) => {
        console.log("computedでエラー", error);
      });
  },

  methods: {
    addMySkill(e) {
      axios
        .post(
          `http://localhost:3000/api/skills/${e}/user_skills`,
          {},
          {
            headers: {
              uid: this.uid,
              "access-token": this.access_token,
              client: this.client,
              "content-type": "application/json",
            },
          }
        )
        .then((response) => {
          console.log(response.data);

          this.$emit("add-skill-button-click", response.data);
        })
        .catch((error) => {
          console.log(error);
        });
    },
    removeMySkill(e) {
      axios
        .delete(`http://localhost:3000/api/user_skills/${e}`, {
          headers: {
            uid: this.uid,
            "access-token": this.access_token,
            client: this.client,
            "content-type": "application/json",
          },
        })
        .then((response) => {
          console.log(response.data);
          this.$emit("remove-skill-button-click", response.data);
        })
        .catch((error) => {
          console.log(error);
        });
    },
  },
};
</script>
