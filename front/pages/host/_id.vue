<template>
  <v-card class="mx-auto">
    <template slot="progress">
      <v-progress-linear
        color="deep-purple"
        height="10"
        indeterminate
      ></v-progress-linear>
    </template>

    <v-img
      height="250"
      src="https://cdn.vuetifyjs.com/images/cards/cooking.png"
    ></v-img>

    <v-card-title>{{ target.name }}@{{ target.myid }}</v-card-title>

    <v-card-text>
      <v-row align="center" class="mx-0">
        <v-rating
          :value="4.5"
          color="amber"
          dense
          half-increments
          readonly
          size="14"
        ></v-rating>

        <div class="grey--text ms-4">4.5 (413)</div>
      </v-row>

      <div class="my-4 text-subtitle-1">
        {{ target.address }}
      </div>

      <div class="my-4 text-subtitle-1">
        {{ target.wanted = true ? " 募集中": "募集していません"}}
      </div>

      <div>{{ target.profile }}</div>
    </v-card-text>

    <modal name="edit-modal" height="auto" :scrollable="true">
      <Edit />
    </modal>

    <modal name="skill-list-modal" height="auto" :scrollable="true">
      <SkillList />
    </modal>

    <v-divider class="mx-4"></v-divider>

    <v-card-title>就業に必須なスキル</v-card-title>

    <v-card-text>
      <div>
        <li v-for="skill in targetSkills" :key="skill.id">
          {{ skill.name }}
        </li>
      </div>
    </v-card-text>

    <v-card-actions>
      <v-btn color="deep-purple lighten-2" text @click="openSkillListModal">
        必須スキルを編集
      </v-btn>
    </v-card-actions>

    <v-card-actions>
      <v-btn color="deep-purple lighten-2" text @click="openEditModal">
        プロフィールを編集
      </v-btn>
    </v-card-actions>
  </v-card>
</template>

<script>
import Edit from "@/components/pages/host/Edit.vue";
import SkillList from "@/components/pages/modal/SkillList.vue";
export default {
  components: {
    Edit,
    SkillList,
  },

  data: () => ({
    target: [],
    targetSkills: [],
  }),
  
  created() {
    const myid = this.$route.params.id;
    this.$axios.get(`http://localhost:3000/api/hosts/${myid}`).then((response) => {
      this.target = response.data.host;
      this.targetSkills = response.data.target_skills;
    });
  },

  methods: {
    openEditModal() {
      this.$modal.show("edit-modal");
    },
    openSkillListModal() {
      this.$modal.show("skill-list-modal");
    },
  },
};

</script>
