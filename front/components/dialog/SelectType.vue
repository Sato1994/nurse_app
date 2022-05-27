<template>
  <v-row justify="center">
    <v-dialog
      :value="selectTypeDisplay"
      max-width="600px"
      @click:outside="close"
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
                <v-btn color="#B0C4B1" dark x-large @click="selectUser">
                  看護師 <v-icon>mdi-human-male-female</v-icon>
                </v-btn>
              </v-col>
              <v-col
                class="d-flex justify-space-around mb-6"
                cols="12"
                sm="6"
                md="6"
              >
                <v-btn color="#B0C4B1" dark x-large @click="selectHost">
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
  props: {
    selectTypeDisplay: {
      type: Boolean,
      default: false,
    },
  },

  methods: {
    selectUser() {
      this.$cookies.set('user', 'user', { secure: true, sameSite: 'Lax' })
      this.$emit('select-user')
    },

    selectHost() {
      this.$cookies.set('user', 'host', { secure: true, sameSite: 'Lax' })
      this.$emit('select-host')
    },

    close() {
      this.$emit('close-select-type-click')
    },
  },
}
</script>
