<template>
  <v-row justify="center">
    <v-dialog
      v-model="$store.state.display.selectUserType.selectUserTypeIsDisplay"
      max-width="600px"
    >
      <v-card>
        <v-card-title>
          <span class="text-h5"><v-icon>あなたは...</v-icon></span>
        </v-card-title>
        <v-card-actions>
          <v-container>
            <v-row>
              <v-col
                class="d-flex justify-space-around mb-6"
                cols="12"
                sm="6"
                md="6"
              >
                <v-btn color="warning" x-large @click="selectUser">
                  看護師 <v-icon>mdi-human-male-female</v-icon>
                </v-btn>
              </v-col>
              <v-col
                class="d-flex justify-space-around mb-6"
                cols="12"
                sm="6"
                md="6"
              >
                <v-btn color="warning" x-large @click="selectHost">
                  病院 <v-icon>mdi-hospital-box-outline</v-icon>
                </v-btn>
              </v-col>
            </v-row>
          </v-container>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-row>
</template>

<script>
export default {
  data: () => ({}),

  methods: {
    selectUser() {
      this.$cookies.set('user', 'user')
      this.go()
    },

    selectHost() {
      this.$cookies.set('user', 'host')
      this.go()
    },

    go() {
      this.$store.commit('display/hideSelectUserType')
      if (this.$cookies.get('sign') === 'in') {
        this.$store.commit('dialog/signIn/displaySignIn')
      } else {
        this.$store.commit('dialog/signUp/displaySignUp')
      }
    },
  },
}
</script>
