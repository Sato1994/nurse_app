<template>
  <v-card>
    <v-card-title>山田孝之 </v-card-title>

    <v-card-text>
      <slot name="profile"></slot>
      <v-btn
        :to="$route.query.prev"
        nuxt
        class="mt-3"
        rounded
        small
        depressed
        block
      >
        プロフィール
      </v-btn>
    </v-card-text>
  </v-card>
</template>

<script>
export default {}
</script>