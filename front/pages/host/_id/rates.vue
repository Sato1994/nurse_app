<template>
  <v-container>
    <RefineSearch :rates="true" @refine-button-click="refineSearch" />
    <v-card class="mx-auto pt-5" :min-height="350">
      <v-card-title>{{ hostName }} </v-card-title>
      <v-card-subtitle> レビュー{{ refinedRates.length }}件 </v-card-subtitle>

      <v-row>
        <v-col
          cols="12"
          sm="12"
          md="12"
          v-for="(rate, index) in refinedRates"
          :key="index"
        >
          <div class="pl-5">
            <v-avatar size="50">
              <v-img :src="imageUrl(rate)"></v-img>
            </v-avatar>
          </div>

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
          <v-divider v-if="index < refinedRates.length - 1" :key="index">
          </v-divider>
        </v-col>
      </v-row>
    </v-card>
  </v-container>
</template>



<script>
import RefineSearch from '@/components/RefineSearch.vue'
export default {
  components: {
    RefineSearch,
  },

  data() {
    return {
      refine: 'all',
    }
  },

  async asyncData({ $axios, route }) {
    const { data } = await $axios.get(`/api/rates/${route.params.id}`)
    return {
      rates: data.rates,
      hostName: data.host_name,
      refinedRates: [],
    }
  },

  mounted() {
    this.refinedRates = this.rates
  },

  methods: {
    agreementStartTime(value) {
      const date = new Date(value)
      const year = date.getFullYear()
      const month = date.getMonth() + 1
      return `${year}年${month}月頃`
    },

    refineSearch(value) {
      const newArray = []
      switch (value) {
        case 'all':
          this.refinedRates = this.rates
          break

        case 'female':
          this.rates.forEach((obj) => {
            if (obj.agreement.user.sex === false) {
              newArray.push(obj)
            }
          })
          this.refinedRates = newArray
          break
        case 'male':
          this.rates.forEach((obj) => {
            if (obj.agreement.user.sex === true) {
              newArray.push(obj)
            }
          })
          this.refinedRates = newArray
          break
      }
    },
    imageUrl(rate) {
      if (rate.agreement.user.sex === true) {
        return '/image/anonymous_male.jpg'
      } else {
        return '/image/anonymous_female.jpg'
      }
    },
  },
}
</script>
