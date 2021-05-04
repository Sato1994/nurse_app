import { createRouter, createWebHistory } from 'vue-router'
import Welcom from '../views/Welcom.vue'
import Users from '../views/UserList.vue'
import User from '../views/User.vue'
import Hosts from '../views/HostList.vue'

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
    path: '/user/:id',
    name: 'User',
    component: User
  },
  {
    path: '/hosts',
    name: 'Hosts',
    component: Hosts
  }

]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

export default router