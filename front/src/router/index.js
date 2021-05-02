import { createRouter, createWebHistory } from 'vue-router'
import Welcom from '../views/Welcom.vue'
import Users from '../views/UserList.vue'
import User from '../views/User.vue'

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
  },
  {
    path: '/user',
    name: 'User',
    component: User
  }

]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

export default router