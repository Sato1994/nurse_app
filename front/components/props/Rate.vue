<template>
  <div>
    <div v-if="inputRateDisplay" class="rateArea">
      <v-stepper v-model="page">
        <v-stepper-items>
          <v-stepper-content step="1">
            <v-textarea
              background-color="blue lighten-5"
              v-model="comment"
              filled
              rows="4"
              label="匿名で病院の評価をしてください！"
              auto-grow
              :counter="300"
            ></v-textarea>

            <v-btn color="warning" @click="page = 2"> 次へ </v-btn>

            <v-btn text> キャンセル</v-btn>
          </v-stepper-content>

          <v-stepper-content step="2">
            <div>
              <v-card-text>
                <v-row align="center" class="mx-0">
                  <v-rating v-model="star" color="amber" size="35"></v-rating>
                </v-row>
              </v-card-text>
              <v-btn color="warning" @click="agree"> 送信 </v-btn>

              <v-btn text @click="page = 1"> 戻る</v-btn>
            </div>
          </v-stepper-content>
        </v-stepper-items>
      </v-stepper>
    </div>

    <div v-if="rateDisplay">
      <v-card class="mx-auto">
        <v-card-title>あなたの付けた評価</v-card-title>

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

          <div class="my-4 text-subtitle-1">
            {{ rate.comment }}
          </div>

          <div>お相手には表示されません。</div>
        </v-card-text>
      </v-card>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    inputRateDisplay: {
      type: Boolean,
    },
    rateDisplay: {
      type: Boolean,
    },

    rate: {
      type: Object,
    },
  },
  data: () => ({
    page: 1,
    comment: '',
    star: 0,
  }),

  methods: {
    agree() {
      this.$emit('agree-button-click', {
        comment: this.comment,
        star: this.star,
      })
    },
  },
}
</script>