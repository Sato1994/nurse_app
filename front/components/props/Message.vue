<template>
  <v-card>
    <v-container v-if="inputEnabled" fluid>
      <v-textarea
        v-model="inputMessage"
        append-icon="mdi-email-fast-outline"
        filled
        rows="2"
        color="#B0C4B1"
        label="メッセージ"
        auto-grow
        :counter="500"
        @click:append="sendMessage"
        @keydown.enter.prevent="sendMessage"
      ></v-textarea>
    </v-container>

    <v-card-text>
      <div class="font-weight-bold ml-8 mb-2">最新</div>

      <v-timeline
        class="overflow-y-auto"
        style="max-height: 500px"
        align-top
        dense
      >
        <v-timeline-item
          v-for="message in room.messages"
          :key="message.createdAt"
          small
        >
          <template #icon>
            <v-avatar>
              <img :src="message.image" />
            </v-avatar>
          </template>

          <div>
            <div class="font-weight-normal">
              <strong>{{ message.name }}</strong> @{{
                new Date(message.createdAt).getMonth() + 1
              }}/{{ new Date(message.createdAt).getDate() }}&nbsp;{{
                new Date(message.createdAt).getHours()
              }}:{{ new Date(message.createdAt).getMinutes() }}
            </div>
            <div>{{ message.message }}</div>
          </div>
        </v-timeline-item>
      </v-timeline>
    </v-card-text>
  </v-card>
</template>

<script>
export default {
  components: {},

  data: () => ({
    inputMessage: '',
  }),

  computed: {
    room: {
      get() {
        return Object.assign({}, this.$store.getters['room/room'])
      },
    },

    inputEnabled() {
      return this.room.closed === 'na'
    },
  },

  methods: {
    sendMessage() {
      if (this.inputMessage) {
        this.$store.dispatch('room/sendMessage', {
          message: this.inputMessage,
          roomId: this.$route.params.id,
        })
        this.inputMessage = ''
      }
    },
  },
}
</script>