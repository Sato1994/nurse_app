import { createRouter, createWebHistory } from 'vue-router'
import Welcom from '../views/Welcom.vue'

const routes = [
  {
    path: '/',
    name: 'Welcom',
    component: Welcom
  }
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

export default router