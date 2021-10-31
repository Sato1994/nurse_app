<template>
  <v-app id="inspire">

    <v-navigation-drawer
      v-model="drawer"
      app
    >
      <v-sheet
        color="grey lighten-4"
        class="pa-4"
      >
        <v-avatar
          class="mb-4"
          color="grey darken-1"
          size="64"
        ></v-avatar>

        <div>john@vuetifyjs.com</div>
      </v-sheet>

      <v-divider></v-divider>

     
    </v-navigation-drawer>

    <v-main>
      <v-container
        class="py-8 px-6"
        fluid
      >
        <v-row>
          <v-col
            
            cols="12"
          >
            <v-card>
              <v-subheader>相手の名前とか</v-subheader>

              <v-list two-line>
                <template>
                  <v-list-item
                  v-for="(message, index) in messages"
                  :key="index"

                
                  >
                    <v-list-item-avatar color="grey darken-1">
                    </v-list-item-avatar>

                    <v-list-item-content>
                      <v-list-item-title>{{message.created_at}}</v-list-item-title>

                      <v-list-item-subtitle>
                       {{message.user}}{{message.message}}
                      </v-list-item-subtitle>
                      <v-divider></v-divider>

                    </v-list-item-content>
                   
                  </v-list-item>


                </template>
              </v-list>




               <v-textarea
                v-model="inputMessage"
                color="teal"
              >
                <template v-slot:label>
                  <div>
                    本文入力 <small>ここです</small>
                  </div>
                </template>
              </v-textarea>
              <v-btn @click="sendMessage">
              送信
              </v-btn>



            </v-card>
            
      {{messages}}
          </v-col>
        </v-row>
      </v-container>
    </v-main>
  </v-app>
</template>

<script>
  export default {
    data: () => ({
      drawer: null,
      messages: [], 
      inputMessage: '',
    }),
  
    mounted() {
      this.$axios.get(`/api/rooms/${this.$route.params.id}`, {headers: this.$cookies.get('authInfo')})
      .then((response) => {
        // Array.pushとArray.concatの違い https://qiita.com/pon_maeda/items/f034cccf3459c1d6505f
        this.messages = this.messages.concat(response.data.user_messages)
        this.messages = this.messages.concat(response.data.host_messages)
        this.messages.sort((a, b) => {
          return new Date(a.created_at) - new Date(b.created_at)
        })
      })
      .catch((error) => {
        console.log(error)
      })
    },
    methods: {
      sendMessage() {
        this.$axios.post(`/api/${this.$cookies.get('user')}_messages/${this.$route.params.id}`,{message: this.inputMessage}, {headers: this.$cookies.get('authInfo')})
        .then((response)=> {
          console.log(response)
        })
        .catch((error) => {
          console.log(error)
        })
      }
    }
  }
</script>