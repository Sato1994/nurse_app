<template>
  <v-row justify="center">
    <v-dialog v-model="isDisplay" persistent max-width="600px">
      <v-card>
        <v-card-title>
          <span>登録済みスキル</span>
        </v-card-title>
        <v-container>
          <v-sheet color="orange lighten-5">
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
          </v-sheet>
        </v-container>

        <v-container>
          <v-row>
            <v-col cols="12">
              <v-card-title>
                <span>未登録スキル</span>
              </v-card-title>
            </v-col>

            <v-col cols="12">
              <v-text-field
                v-model="inputValue"
                label="スキルを検索"
                prepend-icon="mdi-magnify"
              ></v-text-field>
            </v-col>
          </v-row>
        </v-container>

        <v-container>
          <v-sheet color="orange lighten-5">
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
          </v-sheet>
        </v-container>

        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="warning darken-1" text @click="isDisplay = false">
            閉じる
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-row>
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
    this.$axios.get('/api/skills').then((response) => {
      this.allSkills = response.data
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
          this.$emit('add-button-click', skill)
          this.$store.dispatch('skills/addNewSkill', response.data)
        })
    },

    removeSkill(skill) {
      this.$axios
        .delete(`/api/${this.$cookies.get('user')}_skills/${skill.id}`, {
          headers: this.$cookies.get('authInfo'),
        })
        .then((response) => {
          this.$emit('remove-button-click', skill)
          this.$store.dispatch('skills/removeSkill', response.data)
        })
    },
  },
}
</script>
