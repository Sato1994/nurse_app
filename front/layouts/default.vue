<template>
  <v-app id="inspire">
    <Header />
    <v-main class="warning lighten-2">
      <v-container>
        <v-row>
          <v-col>
            <Nuxt />
            <Snackbar />
          </v-col>
        </v-row>
      </v-container>
    </v-main>
  </v-app>
</template>

<script>
import Header from '@/components/Header.vue'
import Snackbar from '@/components/Snackbar.vue'

export default {
  components: {
    Header,
    Snackbar,
  },
}
</script>