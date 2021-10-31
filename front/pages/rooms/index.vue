<template>
<container>
<v-list dense>
      <v-subheader>ログイン者のTalkRoom一覧</v-subheader>
      <v-list-item-group
        v-for="room in myRooms"
          :key="room"
         
          
          color="primary">
        <v-list-item>
          <v-list-item-content >
          




            <v-btn nuxt :to="{ name: 'rooms-id', params: { id: room.id}}" v-text="`${$cookies.get('user') === 'user' ? room.host.name : room.user.name}`"></v-btn>



            
            <v-list-item-title v-text="index"></v-list-item-title>
          </v-list-item-content>
        </v-list-item>
      </v-list-item-group>
    </v-list>
    </container>
</template>


<script>
export default {
  data: () => ({
    myRooms: [],

  }),
  mounted() {
    this.myRooms = this.$store.getters['myInfo/getMyRooms']
  },
  // computed: {
  //   roomURL() {
  //     return 
  //   },
  // },

  methods: {
    
  }
};

</script>
