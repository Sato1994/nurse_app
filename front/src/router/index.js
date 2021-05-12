import { createRouter, createWebHistory } from 'vue-router'
import Welcom from '../views/Welcom.vue'
import User from '../views/User.vue'
import Home from '../views/Home.vue'

const routes = [
  {
    path: '/',
    name: 'Welcom',
    component: Welcom
  },
  {
    path: '/home',
    name: 'Home',
    component: Home,
  },
  {
    path: '/user/:id',
    name: 'User',
    component: User
  },


]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

export default router