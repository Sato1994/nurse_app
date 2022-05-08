<template>
  <v-dialog :value="skillListDisplay" @click:outside="close">
    <v-card :min-height="400">
      <div class="py-3" align="center">
        <v-btn depressed rounded nuxt @click="switchPage = 1">
          <div class="grey--text">登録済み {{ targetSkills.length }}</div>
        </v-btn>

        <v-btn
          v-if="switchClickable"
          depressed
          rounded
          nuxt
          @click="switchPage = 2"
        >
          <div class="grey--text">スキル一覧</div>
        </v-btn>

        <v-card-text class="grey--text">
          <slot name="description"></slot
        ></v-card-text>
      </div>

      <template v-if="switchPage === 1">
        <v-sheet min-height="400" color="orange lighten-5">
          <div class="text-center">
            <v-chip
              v-for="skill in targetSkills"
              :key="skill.id"
              small
              class="ma-1"
              color="orange"
              text-color="white"
              :disabled="!switchClickable"
              @click="removeSkill(skill)"
            >
              {{ skill.name }}
            </v-chip>
          </div>
        </v-sheet>

        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="warning darken-1" text @click="close"> 閉じる </v-btn>
        </v-card-actions>
      </template>
      <template v-if="switchPage === 2">
        <v-text-field
          v-model="inputValue"
          label="スキルを検索"
          prepend-icon="mdi-magnify"
        ></v-text-field>
        <v-sheet min-height="400" color="orange lighten-5">
          <div class="text-center">
            <v-chip
              v-for="skill in unselectedSkills"
              :key="skill.id"
              class="ma-1"
              color="orange"
              text-color="white"
              small
              @click="addSkill(skill)"
            >
              {{ skill.name }}
            </v-chip>
          </div>
        </v-sheet>

        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="warning darken-1" text @click="close"> 閉じる </v-btn>
        </v-card-actions>
      </template>
    </v-card>
  </v-dialog>
</template>

<script>
import { mapActions } from 'vuex'
export default {
  props: {
    skillListDisplay: {
      type: Boolean,
      default: false,
    },
    targetSkills: {
      type: Array,
      default: () => [],
    },
  },
  data: () => ({
    allSkills: [],
    inputValue: '',
    switchPage: 1,
  }),

  computed: {
    unselectedSkills() {
      const unselectedSkills = this.allSkills.filter(
        (obj) => !this.targetSkills.map((obj) => obj.id).includes(obj.id)
      )
      const searchedSkills = unselectedSkills.filter((obj) =>
        obj.name.includes(this.inputValue)
      )
      return searchedSkills
    },

    skills() {
      return this.$store.getters['skills/skills']
    },

    switchClickable() {
      if (
        this.$route.path ===
        `/${this.$cookies.get('user')}/${this.$store.state.info.info.myid}`
      ) {
        return true
      } else {
        return false
      }
    },
  },

  mounted() {
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
      this.switchPage = 1
    },
  },
}
</script>
