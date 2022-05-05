<template>
  <div v-if="cancellCommentDisplay">
    <v-card class="mx-auto">
      <v-card-title>急なキャンセルの理由</v-card-title>

      <v-card-text>
        <div class="my-4 text-subtitle-1">
          {{ comment }}
        </div>
      </v-card-text>
    </v-card>
  </div>
</template>

<script>
export default {
  props: {
    cancellCommentDisplay: {
      type: Boolean,
      default: false,
    },

    comment: {
      type: String,
      default: null,
    },
  },
}
</script>