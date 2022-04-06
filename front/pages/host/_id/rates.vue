<template>
  <v-container>
    <v-card class="mx-auto">
      <v-card-title>{{ hostName }} レビュー{{ ratesCount }}件 </v-card-title>
      <v-row>
        <v-col
          cols="12"
          sm="6"
          md="6"
          v-for="(rate, index) in rates"
          :key="index"
        >
          <v-avatar color="brown" size="50">
            <v-img
              class="elevation-6"
              alt=""
              src="https://avataaars.io/?avatarStyle=Transparent&topType=ShortHairShortCurly&accessoriesType=Prescription02&hairColor=Black&facialHairType=Blank&clotheType=Hoodie&clotheColor=White&eyeType=Default&eyebrowType=DefaultNatural&mouthType=Default&skinColor=Light"
            ></v-img>
          </v-avatar>

          <v-card-subtitle
            >{{ rate.agreement.user.age }}歳
            {{ rate.agreement.user.sex === true ? '男性' : '女性' }}
            勤務時期：{{ agreementStartTime(rate.agreement.start_time) }}
          </v-card-subtitle>

          <v-card-text>
            <v-row align="center" class="mx-0">
              <v-rating
                :value="rate.star"
                color="amber"
                dense
                half-increments
                readonly
                size="14"
              ></v-rating>
            </v-row>
          </v-card-text>

          <v-card-text>
            <div>
              {{ rate.comment }}
            </div>
          </v-card-text>
          <v-divider></v-divider>
        </v-col>
      </v-row>
    </v-card>
  </v-container>
</template>



<script>
export default {
  components: {},

  async asyncData({ $axios, route }) {
    const { data } = await $axios.get(`/api/rates/${route.params.id}`)
    return {
      rates: data.rates,
      hostName: data.host_name,
    }
  },

  computed: {
    ratesCount() {
      return this.rates.length
    },
  },

  methods: {
    agreementStartTime(value) {
      const date = new Date(value)
      const year = date.getFullYear()
      const month = date.getMonth() + 1
      return `${year}年${month}月頃`
    },
  },
}
</script>