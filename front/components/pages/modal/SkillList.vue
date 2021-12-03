<template>
  <v-card>
    <v-card-title>取得済みスキル一覧</v-card-title>

    <v-text-field
      v-model="inputValue"
      hide-details
      prepend-icon="mdi-magnify"
      single-line
      placeholder="スキルを検索"
    ></v-text-field>

    <v-card-text>
      <div class="text-center">
        <v-chip
          v-for="skill in skills"
          :key="skill.id"
          class="ma-1"
          color="orange"
          text-color="white"
          @click="removeSkill(skill.id)"
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
          v-for="unselectedSkill in unselectedSkills"
          :key="unselectedSkill.id"
          class="ma-1"
          color="orange"
          text-color="white"
          @click="addSkill(unselectedSkill.id)"
        >
          {{ unselectedSkill.name }}
        </v-chip>
      </div>
    </v-card-text>
  </v-card>
</template>

<script>
export default {
  data: () => ({
    skills: [],
    allSkills: [],
    inputValue: '',
  }),
  computed: {
    unselectedSkills() {
      const unselectedSkills = this.allSkills.filter(
        (obj) => !this.skills.map((obj) => obj.id).includes(obj.id)
      )
      const searchedSkills = unselectedSkills.filter((obj) =>
        obj.name.includes(this.inputValue)
      )
      return searchedSkills
    },
  },

  mounted() {
    this.skills = this.$store.getters['skills/skills']
    this.$axios
      .get('http://localhost:3000/api/skills')
      .then((response) => {
        this.allSkills = response.data
        console.log('allSkillsをセット', response.data)
      })
      .catch((error) => {
        console.log('computedでエラー', error)
      })
  },

  methods: {
    addSkill(e) {
      this.$axios
        .post(
          `http://localhost:3000/api/skills/${e}/${this.$cookies.get(
            'user'
          )}_skills`,
          {},
          {
            headers: this.$cookies.get('authInfo'),
          }
        )
        .then((response) => {
          console.log(response.data)
          this.$store.dispatch('skills/addNewSkill', response.data)
        })
        .catch((error) => {
          console.log(error)
        })
    },
    removeSkill(e) {
      this.$axios
        .delete(
          `http://localhost:3000/api/${this.$cookies.get('user')}_skills/${e}`,
          {
            headers: this.$cookies.get('authInfo'),
          }
        )
        .then((response) => {
          console.log(response.data)
          this.$store.dispatch('skills/removeSkill', response.data)
        })
        .catch((error) => {
          console.log(error)
        })
    },
  },
}
</script>
