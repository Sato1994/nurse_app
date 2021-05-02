import { createApp } from 'vue'
import App from './App.vue'
import './index.css'
import Router from './router/index.js'

const app = createApp(App).use(Router)

app.mount('#app')
