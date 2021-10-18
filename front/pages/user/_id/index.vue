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
        {{ target.age }}歳 経験{{ target.year }}年
        {{ (target.sex = true ? "  男性" : "  女性") }}
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

    <v-card-title>私の獲得スキル</v-card-title>

    <v-card-text>
      <div>
        <li v-for="skill in targetSkills" :key="skill.id">
          {{ skill.name }}
        </li>
      </div>
    </v-card-text>


    <v-list dense>
      <v-subheader>routes.params.idのTimes一覧</v-subheader>
      <v-list-item-group
        v-for="time in formedTargetTimes"
          :key="time.formedTime"
          color="primary"
      >
        <v-list-item
        @click="jumpTargetTimes">
          <v-list-item-content>
            <v-list-item-title v-text="time.formedTime"></v-list-item-title>
          </v-list-item-content>
        </v-list-item>

      </v-list-item-group>
    </v-list>


    <v-card-actions>
      <v-btn color="deep-purple lighten-2" text @click="openSkillListModal">
        獲得スキルを編集
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
import axios from "axios";
import Edit from "@/components/pages/user/Edit.vue";
import SkillList from "@/components/pages/modal/SkillList.vue";
export default {
  components: {
    Edit,
    SkillList,
  },

  data: () => ({
    target: [],
    targetSkills: [],
    targetTimes: [],
  }),
  
  created() {
    const myid = this.$route.params.id;
    axios.get(`http://localhost:3000/api/users/${myid}`).then((response) => {
      this.target = response.data.user;
      this.targetSkills = response.data.target_skills;
      this.targetTimes = response.data.target_times
    });
  },

  computed: {
    formedTargetTimes() {
      const targetTimes = this.targetTimes.map(obj => {
        const s = new Date(obj.start_time)
        const f = new Date(obj.finish_time)
        const newObject = {id: obj.id, formedTime: `${s.getFullYear()}年${s.getMonth() +1}月${s.getDate()}日${s.getHours()}時${s.getMinutes()}分から${f.getFullYear()}年${f.getMonth() +1}月${f.getDate()}日${f.getHours()}時${f.getMinutes()}分`}
        return newObject
      })
      return targetTimes
    }

  },

  methods: {
    openEditModal() {
      this.$modal.show("edit-modal");
    },
    openSkillListModal() {
      this.$modal.show("skill-list-modal");
    },
    jumpTargetTimes() {
      this.$router.push(`/user/${this.target.myid}/times`)
    },
  },
};

</script>
