<template>
  <v-row class="fill-height">
    <v-col>
      <v-sheet height="64">
        <v-toolbar flat>
          <v-btn outlined class="mr-4" color="grey darken-2" @click="setToday">
            今日
          </v-btn>
          <v-btn
            fab
            text
            small
            color="grey darken-2"
            @click="$refs.calendar.prev()"
          >
            <v-icon small> mdi-chevron-left </v-icon>
          </v-btn>
          <v-btn
            fab
            text
            small
            color="grey darken-2"
            @click="$refs.calendar.next()"
          >
            <v-icon small> mdi-chevron-right </v-icon>
          </v-btn>
          <v-toolbar-title v-if="$refs.calendar">
            {{ $refs.calendar.title }}
          </v-toolbar-title>
          <v-spacer></v-spacer>

          <v-menu bottom right>
            <template #activator="{ on, attrs }">
              <v-btn outlined color="grey darken-2" v-bind="attrs" v-on="on">
                <span>{{ typeToLabel[type] }}</span>
                <v-icon right> mdi-menu-down </v-icon>
              </v-btn>
            </template>
            <v-list>
              <v-list-item @click="type = 'week'">
                <v-list-item-title>週表示</v-list-item-title>
              </v-list-item>
              <v-list-item @click="type = 'month'">
                <v-list-item-title>月表示</v-list-item-title>
              </v-list-item>
            </v-list>
          </v-menu>
        </v-toolbar>
      </v-sheet>
      <v-sheet height="600">
        <v-calendar
          ref="calendar"
          v-model="focus"
          color="primary"
          :events="events"
          :type="type"
          @click:event="showEvent"
          @click:more="viewWeek"
          @click:date="viewWeek"
        ></v-calendar>

        <v-menu
          v-model="selectedOpen"
          :close-on-content-click="false"
          :activator="selectedElement"
          offset-x
        >
          <v-card color="grey lighten-4" min-width="350px" flat>
            <v-toolbar :color="selectedEvent.color" dark>
              <v-btn icon>
                <v-icon>mdi-human-male-female</v-icon>
              </v-btn>
              <v-toolbar-title>{{ selectedEvent.partner }}様</v-toolbar-title>
              <v-spacer></v-spacer>
            </v-toolbar>
            <v-card-text>
              <span
                >{{ selectedEvent.dislayStart }}～{{
                  selectedEvent.displayFinish
                }}</span
              >
            </v-card-text>
            <v-card-actions>
              <v-btn
                outlined
                text
                color="secondary"
                @click="request(selectedEvent.id)"
              >
                リクエストを送る
              </v-btn>
              <v-btn
                outlined
                text
                color="secondary"
                @click="request(selectedEvent.id)"
              >
                リクエストを削除する
              </v-btn>
            </v-card-actions>
          </v-card>
        </v-menu>
      </v-sheet>
    </v-col>
  </v-row>
</template>

<script>
export default {
  props: {
    events: {
      type: Array,
      default: () => [],
    },
  },

  data: () => ({
    focus: '',
    type: 'month',
    typeToLabel: {
      month: '月表示',
      week: '週表示',
    },
    selectedEvent: {},
    selectedElement: null,
    selectedOpen: false,
  }),

  mounted() {
    this.$refs.calendar.checkChange()
  },

  methods: {
    request(id) {
      this.$emit('request-button-click', id)
      this.selectedOpen = false
    },
    viewWeek({ date }) {
      this.focus = date
      this.type = 'week'
    },
    setToday() {
      this.focus = ''
    },
    showEvent({ nativeEvent, event }) {
      const open = () => {
        this.selectedEvent = event
        this.selectedElement = nativeEvent.target
        requestAnimationFrame(() =>
          requestAnimationFrame(() => (this.selectedOpen = true))
        )
      }

      if (this.selectedOpen) {
        this.selectedOpen = false
        requestAnimationFrame(() => requestAnimationFrame(() => open()))
      } else {
        open()
      }
      nativeEvent.stopPropagation()
    },
  },
}
</script>