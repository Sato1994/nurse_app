<template>
  <v-row justify="center">
    <v-dialog v-model="isDisplay" persistent max-width="290">
      <v-card>
        <v-card-title class="text-h5">
          {{ confirmText }}
        </v-card-title>
        <v-card-text style="white-space: pre-wrap">{{
          confirmDescription
        }}</v-card-text>
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
    confirmDisplay: {
      type: Boolean,
      fefault: false,
    },
    confirmDescription: {
      type: String,
      required: true,
    },

    confirmText: {
      type: String,
      required: true,
    },

    agreeButtonText: {
      type: String,
      required: true,
    },
  },

  computed: {
    isDisplay: {
      get() {
        return this.confirmDisplay
      },
    },
  },

  methods: {
    agree() {
      this.$emit('click-agree-button')
    },
    disAgree() {
      this.$emit('click-disagree-button')
    },
  },
}
</script>