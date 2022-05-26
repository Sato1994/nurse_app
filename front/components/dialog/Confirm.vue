<template>
  <v-row justify="center">
    <v-dialog v-model="confirmIsDisplay" persistent max-width="290">
      <v-card>
        <ValidationObserver v-slot="{ invalid }">
          <v-card-title class="text-h5">
            {{ title }}
          </v-card-title>
          <v-card-text style="white-space: pre-wrap">{{
            description
          }}</v-card-text>

          <v-row v-if="commentIsDisplay">
            <v-col cols="12">
              <v-card-title class="justify-center">
                <v-icon>mdi-phone</v-icon><a :href="phoneLink">{{ phone }}</a>
              </v-card-title>
            </v-col>
            <v-col cols="12">
              <ValidationProvider rules="required|max:50">
                <v-text-field
                  v-model="comment"
                  label="理由を入力して下さい。"
                  :counter="50"
                  solo
                >
                </v-text-field>
              </ValidationProvider>
            </v-col>
          </v-row>

          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn color="#B0C4B1" text @click="disAgree"> 戻る </v-btn>
            <v-btn
              color="#EF6461"
              text
              :disabled="invalid && commentIsDisplay"
              @click="agree"
            >
              {{ agreeButtonText }}
            </v-btn>
          </v-card-actions>
        </ValidationObserver>
      </v-card>
    </v-dialog>
  </v-row>
</template>

<script>
import { mapState } from 'vuex'
export default {
  props: {
    confirmDisplay: {
      type: Boolean,
      default: false,
    },

    phone: {
      type: String,
      default: null,
    },
  },

  data() {
    return {
      comment: '',
      confirmIsDisplay: false,
    }
  },

  computed: {
    ...mapState('dialog/confirm', [
      'title',
      'description',
      'agreeButtonText',
      'commentIsDisplay',
    ]),

    phoneLink() {
      return 'tel:' + this.phone
    },
  },

  watch: {
    confirmDisplay(newValue) {
      this.confirmIsDisplay = newValue
    },
  },

  methods: {
    agree() {
      this.$emit('agree-button-click', this.comment)
    },

    disAgree() {
      this.$emit('disagree-button-click')
      this.comment = ''
    },
  },
}
</script>


<style scoped>
a {
  font-weight: bold;
  text-decoration: none;
}

a:link {
  color: #ff0000;
}

a:hover {
  text-decoration: underline;
}
</style>