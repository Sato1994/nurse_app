<template>
  <v-row justify="center">
    <v-dialog v-model="display" scrollable max-width="300px">
      <v-card>
        <v-card-title>通知</v-card-title>
        <v-divider></v-divider>
        <v-card-text class="pa-0" style="height: 300px">
          <v-list two-line dense>
            <v-list-item-group>
              <template v-for="(notice, index) in noticesOnDialog">
                <v-list-item :key="notice.index">
                  <v-list-item-content>
                    <v-list-item-title
                      v-text="notice.title"
                    ></v-list-item-title>

                    <v-list-item-subtitle
                      class="text--primary"
                      v-text="notice.partnerName"
                    ></v-list-item-subtitle>

                    <v-list-item-subtitle
                      v-text="notice.partnerMyId"
                    ></v-list-item-subtitle>
                  </v-list-item-content>

                  <v-list-item-action>
                    <v-list-item-action-text
                      v-text="notice.creatdAt"
                    ></v-list-item-action-text>

                    <v-icon
                      btn
                      @click="removeNotice({ noticeId: notice.id })"
                      color="grey lighten-1"
                    >
                      mdi-trash-can-outline
                    </v-icon>
                  </v-list-item-action>
                </v-list-item>

                <v-divider
                  v-if="index < noticesOnDialog.length - 1"
                  :key="index"
                ></v-divider>
              </template>
            </v-list-item-group>
          </v-list>
        </v-card-text>
        <v-divider></v-divider>
        <v-card-actions>
          <v-btn @click="hideNotice" color="warning" text> 閉じる </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-row>
</template>
<script>
import { mapMutations, mapGetters, mapActions } from 'vuex'
export default {
  data() {
    return {}
  },

  computed: {
    ...mapGetters('notices', ['noticesOnDialog']),

    display: {
      get() {
        return this.$store.state.notices.noticeIsDisplay
      },
      set() {
        this.hideNotice()
      },
    },
  },
  methods: {
    ...mapMutations('notices', ['hideNotice']),
    ...mapActions('notices', ['removeNotice']),
  },
}
</script>