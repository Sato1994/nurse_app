<template>
  <v-container>
    <v-card class="mx-auto">
      <v-card-title>山田薬剤師病院 レビュー413件 </v-card-title>

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
            >{{ rate.age }}歳
            {{ rates[0].sex === true ? '男性' : '女性' }} 勤務時期：{{
              rate.createdAt
            }}
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
              {{ rate.comment }}{{ rate.comment }}{{ rate.comment
              }}{{ rate.comment }}
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

  data() {
    return {
      rates: [
        {
          id: 1,
          star: 4,
          comment:
            '会福祉法人恩賜財団済生会京都府病院凄く毎日が業務2時間以上残業している日もあります。毎日ベッド',
          age: 30,
          sex: true,
          createdAt: '最近',
        },
        {
          id: 2,
          star: 3,
          comment:
            '院は、安心安全の医療を提供しており、また一般医療にも重点をおいて、地域医療にも積極的に取安心安全の医療を提供しており、また一般医療にも重点をおいて、地域医療にも積極的に取り組んでいあります。毎日ベッドり組んでいあります。毎日ベッド',
          age: 29,
          sex: false,
          createdAt: '02/19',
        },
        {
          id: 3,
          star: 1,
          comment:
            '院は、安心安全の医療を提供しており、また一般医療にも重点をおいて、地域医療にも積極的に取り組んでいあります。毎日ベッド',
          age: 50,
          sex: false,
          createdAt: '12/05',
        },
        {
          id: 4,
          star: 1,
          comment:
            '院は、安心安全の医療を提供しており、また一般医療にも重点をおいて、地域医療にも積極的に取り組んでいあります。毎日ベッド',
          age: 50,
          sex: false,
          createdAt: '12/05',
        },
      ],
    }
  },
}
</script>