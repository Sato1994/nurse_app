import colors from 'vuetify/es5/util/colors'

export default {


  server: {
    port: 8080,
    host: '0.0.0.0',

  },

  publicRuntimeConfig: {
    MAPS_API_KEY: process.env.MAPS_API_KEY
  },

  // Global page headers: https://go.nuxtjs.dev/config-head
  head: {
    titleTemplate: '%s | NurseHop',
    title: 'Good Nurses and Good Hospitals are here.',
    htmlAttrs: {
      lang: 'en'
    },
    meta: [
      { charset: 'utf-8' },
      { name: 'viewport', content: 'width=device-width, initial-scale=1' },
      { hid: 'description', name: 'description', content: '' },
      { name: 'format-detection', content: 'telephone=no' }
    ],
    link: [
      { rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' },
      {
        rel: 'stylesheet',
        href:
          'https://fonts.googleapis.com/css2?family=Noto+Sans+JP&family=Oswald:wght@700&family=Roboto&display=swap',
      }
    ]
  },

  // Global CSS: https://go.nuxtjs.dev/config-css
  css: [
  ],

  // Plugins to run before rendering page: https://go.nuxtjs.dev/config-plugins
  plugins: [
    {
      src: '~/plugins/main.js',
      mode: 'client'
    },

    { src: '~/plugins/vue2-google-maps.js' },
    'plugins/axios',
    'plugins/vee-validate'
  ],

  // Auto import components: https://go.nuxtjs.dev/config-components
  components: true,

  // Modules for dev and build (recommended): https://go.nuxtjs.dev/config-modules
  buildModules: [
    // https://go.nuxtjs.dev/eslint
    '@nuxtjs/eslint-module',
    // https://go.nuxtjs.dev/vuetify
    '@nuxtjs/vuetify',
  ],

  // Modules: https://go.nuxtjs.dev/config-modules
  modules: [
    // https://go.nuxtjs.dev/axios
    '@nuxtjs/axios',
    'cookie-universal-nuxt'
  ],

  // Axios module configuration: https://go.nuxtjs.dev/config-axios
  axios: {
    baseURL: process.env.BASE_URL,
    browserBaseURL: process.env.BROWSER_BASE_URL,
  },

  // Vuetify module configuration: https://go.nuxtjs.dev/config-vuetify
  vuetify: {
    customVariables: ['~/assets/variables.scss'],
    treeShake: true,
    theme: {
      dark: false,
      themes: {
        light: {
          background: "#DEDBD2"
        },
        dark: {
          primary: colors.blue.darken2,
          accent: colors.grey.darken3,
          secondary: colors.amber.darken3,
          info: colors.teal.lighten1,
          warning: "#A77E58",
          error: colors.deepOrange.accent4,
          success: colors.green.accent3,
        },
      }
    }
  },

  // Build Configuration: https://go.nuxtjs.dev/config-build
  build: {
    transpile: [
      "vee-validate/dist/rules",
      /^vue2-google-maps($|\/)/
    ]
  }
}
