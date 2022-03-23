<template>
  <v-container>
    <v-toolbar color="warning" flat dark dense>
      <v-toolbar-title>メッセージ</v-toolbar-title>
    </v-toolbar>

    <v-list dense subheader two-line>
      <v-subheader inset>交渉中</v-subheader>

      <v-list-item
        v-for="(room, index) in myRooms"
        :key="index"
        link
        @click="jumpRoom(room.id)"
      >
        <v-list-item-avatar>
          <v-icon class="grey lighten-1" dark> mdi-mail </v-icon>
        </v-list-item-avatar>

        <v-list-item-content>
          <v-list-item-title v-text="room.partner.name"></v-list-item-title>

          <v-list-item-subtitle v-text="room.start_time"></v-list-item-subtitle>
        </v-list-item-content>
      </v-list-item>

      <v-divider inset></v-divider>

      <v-subheader inset>交渉済み</v-subheader>
    </v-list>
  </v-container>
</template>

<script>
export default {
  data: () => ({}),

  head: {
    title: 'メッセージ',
  },

  computed: {
    myRooms() {
      return this.$store.getters['rooms/unclosedRooms'](
        this.$cookies.get('user')
      )
    },
  },
  methods: {
    jumpRoom(id) {
      this.$router.push(`/rooms/${id}`)
    },
  },
}
</script>
