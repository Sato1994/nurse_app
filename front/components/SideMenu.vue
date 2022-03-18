<template>
  <v-navigation-drawer
    v-model="sideMenuIsDisplay"
    v-click-outside="closeSideMenu"
    app
    absolute
    temporary
    persistent
  >
    <v-list nav dense>
      <v-list-item-group active-class="deep-purple--text text--accent-4">
        <v-list-item>
          <v-list-item-title>Foo</v-list-item-title>
        </v-list-item>

        <v-list-item>
          <v-list-item-title>Bar</v-list-item-title>
        </v-list-item>

        <v-list-item>
          <v-list-item-title>Fizz</v-list-item-title>
        </v-list-item>

        <v-list-item>
          <v-list-item-title>Buzz</v-list-item-title>
        </v-list-item>
      </v-list-item-group>
    </v-list>
  </v-navigation-drawer>
</template>

<script>
export default {
  props: {
    sideMenu: {
      type: Boolean,
      required: true,
    },
  },

  data() {
    return {
      tabs: null,
      sideMenuIsDisplay: this.sideMenu,
    }
  },

  watch: {
    sideMenu(newValue) {
      this.sideMenuIsDisplay = newValue
    },
  },

  methods: {
    closeSideMenu() {
      this.$emit('close-side-menu-click')
    },
  },
}
</script>