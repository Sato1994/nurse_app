import { createApp } from 'vue'
import App from './App.vue'
import './index.css'
import Router from './router/index.js'
import axios from 'axios'

const app = createApp(App).use(Router)
// グローバルにthis.axiosで呼び出せるようになる。
app.config.globalProperties.axios = axios

app.mount('#app')
