<template>
  <v-container>
    <v-list dense>
      <v-subheader>ログイン者のTalkRoom一覧</v-subheader>
      <v-list-item-group
        v-for="(room, index) in myRooms"
        :key="index"
        color="primary"
      >
        <v-list-item>
          <v-list-item-content>
            <v-btn
              nuxt
              :to="{ name: 'rooms-id', params: { id: room.id } }"
              v-text="
                `${
                  $cookies.get('user') === 'user'
                    ? room.host.name
                    : room.user.name
                }`
              "
            ></v-btn>

            <v-list-item-title></v-list-item-title>
          </v-list-item-content>
        </v-list-item>
      </v-list-item-group>
    </v-list>
  </v-container>
</template>


<script>
export default {
  data: () => ({}),
  computed: {
    myRooms() {
      return this.$store.getters['rooms/unclosedRooms'](
        this.$cookies.get('user')
      )
    },
  },
  methods: {},
}
</script>
