<template>
  <v-row justify="center">
    <v-dialog v-model="dialogIsDisplay" persistent max-width="290">
      <v-card>
        <v-card-title class="text-h5">
          {{ confirmTitle }}
        </v-card-title>
        <v-card-text style="white-space: pre-wrap">{{
          confirmDescription
        }}</v-card-text>

        <v-row v-if="commentIsDisplay">
          <v-col cols="12">
            <v-card-title class="justify-center">
              <v-icon>mdi-phone</v-icon><a :href="phoneLink">{{ phone }}</a>
            </v-card-title>
          </v-col>
          <v-col cols="12">
            <v-text-field
              v-model="comment"
              label="理由を入力して下さい。"
              :counter="50"
              solo
            >
            </v-text-field>
          </v-col>
        </v-row>

        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="green darken-1" text @click="disAgree"> 戻る </v-btn>
          <v-btn color="red darken-1" text @click="agree">
            {{ agreeButtonText }}
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-row>
</template>

<script>
export default {
  props: {
    dialog: {
      type: Boolean,
      required: true,
    },

    confirmDescription: {
      type: String,
      required: true,
    },

    confirmTitle: {
      type: String,
      required: true,
    },

    agreeButtonText: {
      type: String,
      required: true,
    },

    commentIsDisplay: {
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
      dialogIsDisplay: this.dialog,

      comment: '',
    }
  },

  computed: {
    phoneLink() {
      return 'tel:' + this.phone
    },
  },

  watch: {
    dialog(newValue) {
      this.dialogIsDisplay = newValue
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