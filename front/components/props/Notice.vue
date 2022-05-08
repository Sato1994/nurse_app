<template>
  <v-row justify="space-around">
    <v-menu
      :close-on-content-click="false"
      transition="slide-y-transition"
      bottom
    >
      <template #activator="{ on, attrs }">
        <v-btn icon v-bind="attrs" v-on="on">
          <v-badge
            :value="value"
            bordered
            bottom
            color="warning"
            dot
            offset-x="7"
            offset-y="7"
          >
            <v-icon size="30">mdi-bell-outline</v-icon>
          </v-badge>
        </v-btn>
      </template>

      <v-list
        v-if="value"
        two-line
        style="max-height: 400px"
        class="overflow-auto"
      >
        <v-list-item-group>
          <template v-for="(notice, index) in noticesOnDialog">
            <v-list-item
              :key="notice.index"
              dense
              @click="$router.push(notice.sourceLink)"
            >
              <v-list-item-avatar>
                <img :src="notice.partnerImage" />
              </v-list-item-avatar>
              <v-list-item-content>
                <v-list-item-title v-text="notice.title"></v-list-item-title>

                <v-list-item-subtitle
                  class="text--primary"
                  v-text="notice.subTitle"
                ></v-list-item-subtitle>

                <v-list-item-subtitle
                  v-text="notice.partnerName"
                ></v-list-item-subtitle>
              </v-list-item-content>

              <v-list-item-action>
                <v-list-item-action-text
                  v-text="notice.createdAt"
                ></v-list-item-action-text>

                <v-icon
                  btn
                  color="grey lighten-1"
                  @click="removeNotice({ noticeId: notice.id })"
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
      <v-list v-else>
        <v-list-item>
          <v-list-item-content>
            <v-list-item-title v-text="noNoticeTitle"></v-list-item-title>
          </v-list-item-content>
        </v-list-item>
      </v-list>
    </v-menu>
  </v-row>
</template>
<script>
import { mapGetters, mapActions } from 'vuex'
export default {
  data: () => ({}),

  computed: {
    ...mapGetters('notices', ['noticesOnDialog']),

    value() {
      return this.$store.state.notices.notices.length
    },

    noNoticeTitle() {
      return '新しい通知はありません。'
    },
  },
  methods: {
    ...mapActions('notices', ['removeNotice']),
  },
}
</script>