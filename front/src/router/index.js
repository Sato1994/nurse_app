import { createRouter, createWebHistory } from 'vue-router'
import Welcom from '../views/Welcom.vue'
import Users from '../views/UserList.vue'

const routes = [
  {
    path: '/',
    name: 'Welcom',
    component: Welcom
  },
  {
    path: '/users',
    name: 'Users',
    component: Users
  }

]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

export default router