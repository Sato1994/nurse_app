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
      <Edit @edit-button-click="redraw" />
    </modal>

    <v-divider class="mx-4"></v-divider>

    <v-card-title>私の獲得スキル</v-card-title>

    <v-card-text>
      <v-chip-group
        v-model="selection"
        active-class="deep-purple accent-4 white--text"
        column
      >
        <v-chip>5:30PM</v-chip>

        <v-chip>7:30PM</v-chip>

        <v-chip>8:00PM</v-chip>

        <v-chip>9:00PM</v-chip>
      </v-chip-group>
    </v-card-text>

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
export default {
  components: {
    Edit,
  },

  data: () => ({
    selection: 1,
    target: [],
  }),
  mounted() {
    const myid = this.$route.params.id;
    axios.get(`http://localhost:3000/api/users/${myid}`).then((response) => {
      this.target = response.data.user;
    });
  },
  methods: {
    openEditModal() {
      this.$modal.show("edit-modal");
    },
    redraw(e) {
      this.target = e;
    },
  },
};

// 自分のプロフィールページならmyInfo登録する処理書きたい
</script>
