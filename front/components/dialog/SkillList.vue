<template>
  <v-dialog v-model="isDisplay" persistent max-width="600px">
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
            @click="removeSkill(skill)"
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
            @click="addSkill(unselectedSkill)"
          >
            {{ unselectedSkill.name }}
          </v-chip>
        </div>
      </v-card-text>
      <v-btn color="success" @click="isDisplay = false"> 戻る</v-btn>
    </v-card>
  </v-dialog>
</template>

<script>
export default {
  data: () => ({
    isDisplay: false,
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

    skills() {
      return this.$store.getters['skills/skills']
    },
  },

  created() {
    this.$axios
      .get('/api/skills')
      .then((response) => {
        this.allSkills = response.data
        console.log('allSkillsをセット', response.data)
      })
      .catch((error) => {
        console.log('createdでエラー', error)
      })
  },

  methods: {
    addSkill(skill) {
      this.$axios
        .post(
          `/api/skills/${skill.id}/${this.$cookies.get('user')}_skills`,
          {},
          {
            headers: this.$cookies.get('authInfo'),
          }
        )
        .then((response) => {
          console.log(response.data)
          this.$emit('add-button-click', skill)
          this.$store.dispatch('skills/addNewSkill', response.data)
        })
        .catch((error) => {
          console.log(error)
        })
    },

    removeSkill(skill) {
      this.$axios
        .delete(`/api/${this.$cookies.get('user')}_skills/${skill.id}`, {
          headers: this.$cookies.get('authInfo'),
        })
        .then((response) => {
          console.log(response.data)
          this.$emit('remove-button-click', skill)
          this.$store.dispatch('skills/removeSkill', response.data)
        })
        .catch((error) => {
          console.log(error)
        })
    },
  },
}
</script>
