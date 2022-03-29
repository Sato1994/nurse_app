<template>
  <v-app id="inspire">
    <Header />
    <v-main class="grey lighten-3">
      <v-container>
        <v-row>
          <v-col>
            <v-sheet color="orange lighten-5" min-height="70vh" rounded="lg">
              <Nuxt />
              <Snackbar />
            </v-sheet>
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