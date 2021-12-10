<template>
  <v-card class="mx-auto">
    <v-img
      height="250"
      src="https://cdn.vuetifyjs.com/images/cards/cooking.png"
    ></v-img>

    <v-card-title
      >{{ target.name }}
      <v-chip small class="ma-2" text-color="white" :color="wantedChipColor">{{
        target.wanted === true ? '募集中' : '募集していません'
      }}</v-chip>
    </v-card-title>

    <v-card-subtitle>
      {{ target.age ? `年齢${target.age}歳` : '年齢を登録していません。' }}
    </v-card-subtitle>

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

      <div class="my-4 text-subtitle-2">
        {{ target.sex === true ? '女性' : '男性' }}
      </div>

      <div class="my-4 text-subtitle-2">
        {{
          target.year ? `経験${target.year}年` : '経験年数を登録していません。'
        }}
      </div>

      <div class="my-4 text-subtitle-2">
        {{ target.address ? `${target.address}` : '住所を登録していません。' }}
      </div>

      <div>
        {{
          target.profile
            ? `${target.profile}`
            : 'プロフィールを登録していません。'
        }}
      </div>
    </v-card-text>

    <v-card-actions
      v-if="
        $cookies.get('user') === 'user' &&
        $store.state.myInfo.myInfo.myid === $route.params.id
      "
    >
      <v-btn
        class="ma-2"
        color="amber lighten-4"
        small
        depressed
        @click="$refs.edit.isDisplay = true"
      >
        <v-icon>mdi-cog-outline</v-icon>
      </v-btn>
    </v-card-actions>

    <v-divider class="mx-4"></v-divider>

    <Calendar />

    <v-divider class="mx-4"></v-divider>

    <v-card-title>NGな技術</v-card-title>

    <v-card-text>
      <div>
        <v-chip
          v-for="(skill, i) in targetSkills"
          :key="i"
          class="ma-1"
          color="warning"
          small
        >
          {{ skill.name }}
        </v-chip>
      </div>
    </v-card-text>

    <v-card-actions
      v-if="
        $cookies.get('user') === 'user' &&
        $store.state.myInfo.myInfo.myid === $route.params.id
      "
    >
      <v-btn
        class="ma-2"
        color="amber lighten-4"
        small
        depressed
        @click="$refs.skillList.isDisplay = true"
      >
        <v-icon>mdi-plus-box-multiple-outline</v-icon>
      </v-btn>
    </v-card-actions>
    <Edit ref="edit" @edit-button-click="editMyInfo" />
    <SkillList
      ref="skillList"
      @add-button-click="addSkill"
      @remove-button-click="removeSkill"
    />
  </v-card>
</template>

<script>
import Edit from '@/components/dialog/Edit.vue'
import SkillList from '@/components/dialog/SkillList.vue'
import Calendar from '@/components/molecules/Calendar.vue'
export default {
  components: {
    Edit,
    SkillList,
    Calendar,
  },

  data: () => ({
    target: [],
    targetSkills: [],
    targetTimes: [],
    items: [
      { title: 'お相手のページへ移動' },
      { title: '契約時間の変更申請' },
      { title: '契約の取り消し申請' },
    ],
  }),

  computed: {
    formedTargetTimes() {
      const targetTimes = this.targetTimes.map((obj) => {
        const s = new Date(obj.start_time)
        const f = new Date(obj.finish_time)
        const newObject = {
          id: obj.id,
          formedTime: `${s.getFullYear()}年${
            s.getMonth() + 1
          }月${s.getDate()}日${s.getHours()}時${s.getMinutes()}分から${f.getFullYear()}年${
            f.getMonth() + 1
          }月${f.getDate()}日${f.getHours()}時${f.getMinutes()}分`,
        }
        return newObject
      })
      return targetTimes
    },

    formedTargetAgreements() {
      const targetAgreements = this.$store.getters[
        'agreements/agreementsInProgress'
      ].map((obj) => {
        const s = new Date(obj.start_time)
        const f = new Date(obj.finish_time)
        const newObject = {
          id: obj.id,
          room: obj.room,
          host: obj.host,
          formedAgreement: `${s.getFullYear()}年${
            s.getMonth() + 1
          }月${s.getDate()}日${s.getHours()}時${s.getMinutes()}分から${f.getFullYear()}年${
            f.getMonth() + 1
          }月${f.getDate()}日${f.getHours()}時${f.getMinutes()}分`,
        }
        return newObject
      })
      return targetAgreements
    },

    wantedChipColor() {
      return this.target.wanted === true ? 'green' : 'red'
    },
  },

  created() {
    const myid = this.$route.params.id
    this.$axios
      .get(`http://localhost:3000/api/users/${myid}`)
      .then((response) => {
        this.target = response.data.user
        this.targetSkills = response.data.target_skills
        this.targetTimes = response.data.target_times
      })
  },

  methods: {
    addSkill(skill) {
      this.targetSkills.push(skill)
    },

    removeSkill(skill) {
      const target = this.targetSkills.find(
        (targetSkill) => targetSkill.id === skill.id
      )
      const index = this.targetSkills.indexOf(target)
      this.targetSkills.splice(index, 1)
    },

    editMyInfo(copiedMyInfo) {
      this.$set(this.target, 'name', copiedMyInfo.name)
      this.$set(this.target, 'address', copiedMyInfo.address)
      this.$set(this.target, 'profile', copiedMyInfo.profile)
      this.$set(this.target, 'age', copiedMyInfo.age)
      this.$set(this.target, 'year', copiedMyInfo.year)
      this.$set(this.target, 'sex', copiedMyInfo.sex)
      this.$set(this.target, 'wanted', copiedMyInfo.wanted)
    },

    jumpTargetTimes(freeTimeId) {
      this.$router.push({
        path: `/user/${this.target.myid}/times`,
        query: { t: freeTimeId },
      })
    },

    selectedMenu(i, agreementId, roomId, hostMyId) {
      switch (i) {
        case 0:
          this.$router.push(`/host/${hostMyId}`)
          break
        case 1:
          this.$axios
            .patch(
              `/api/agreements/${agreementId}`,
              {},
              {
                headers: this.$cookies.get('authInfo'),
              }
            )
            .then((response) => {
              console.log(response)
              this.$router.push(`/rooms/${roomId}`)
            })
            .catch((error) => {
              console.log(error)
            })
          break
        case 2:
          this.$axios
            .patch(
              '/api/agreements/cancell',
              { id: agreementId },
              { headers: this.$cookies.get('authInfo') }
            )
            .then((response) => {
              console.log(response)
              this.$store.dispatch('agreements/updateState', {
                id: agreementId,
                state: 'cancelled',
              })
              this.$router.push(`/rooms/${roomId}`)
            })
            .catch((error) => {
              console.log(error)
            })
          break
      }
    },
  },
}
</script>


<!--
<template>
  <v-card class="mx-auto">
  
    <v-list dense>
      <v-subheader>routes.params.idのTimes一覧</v-subheader>
      <v-list-item-group
        v-for="(time, index) in formedTargetTimes"
        :key="index"
        color="primary"
      >
        <v-list-item @click="jumpTargetTimes(time.id)">
          <v-list-item-content>
            <v-list-item-title v-text="time.formedTime"></v-list-item-title>
          </v-list-item-content>
        </v-list-item>
      </v-list-item-group>
    </v-list>

    <v-list
      v-if="
        $cookies.get('user') === 'user' &&
        $store.state.myInfo.myInfo.myid === $route.params.id
      "
      dense
    >
      <v-subheader>Agreements一覧</v-subheader>
      <v-list-item-group
        v-for="(agreement, index) in formedTargetAgreements"
        :key="index"
        color="primary"
      >
        <v-row class="d-flex" justify="center">
          <v-menu v-model="showMenu" absolute offset-y style="max-width: 600px">
            <template #activator="{ on, attrs }">
              <v-list-item v-bind="attrs" v-on="on">
                <v-list-item-content>
                  <v-list-item-title
                    v-text="agreement.formedAgreement"
                  ></v-list-item-title>
                  <v-subheader>{{ agreement.host.name }}様との契約</v-subheader>
                </v-list-item-content>
              </v-list-item>
            </template>

            <v-list>
              <v-list-item
                v-for="(item, i) in items"
                :key="i"
                @click="
                  selectedMenu(
                    i,
                    agreement.id,
                    agreement.room.id,
                    agreement.host.myid
                  )
                "
              >
                <v-list-item-title>{{ item.title }}</v-list-item-title>
              </v-list-item>
            </v-list>
          </v-menu>
        </v-row>
      </v-list-item-group>
    </v-list>

  </v-card>
</template>
-->