<template>
  <v-row justify="center">
    <v-dialog
      max-width="600px"
      :value="skillListDisplay"
      @click:outside="close"
    >
      <v-card>
        <v-card-title>
          <span>登録済み</span>
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
                <span>未登録</span>
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
                  v-for="skill in unselectedSkills"
                  :key="skill.id"
                  class="ma-1"
                  color="orange"
                  text-color="white"
                  @click="addSkill(skill)"
                >
                  {{ skill.name }}
                </v-chip>
              </div>
            </v-card-text>
          </v-sheet>
        </v-container>

        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="warning darken-1" text @click="close"> 閉じる </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-row>
</template>

<script>
import { mapActions } from 'vuex'
export default {
  props: {
    skillListDisplay: {
      type: Boolean,
      default: false,
    },
  },
  data: () => ({
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
      this.allSkills = response.data.skills
    })
  },

  methods: {
    ...mapActions('skills', ['addSkill']),
    ...mapActions('skills', ['removeSkill']),

    close() {
      this.$emit('close-skill-list-click')
      this.inputValue = ''
    },
  },
}
</script>
