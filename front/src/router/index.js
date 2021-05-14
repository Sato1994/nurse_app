import { createRouter, createWebHistory } from 'vue-router'
import SignUp from '../views/auth/SignUp.vue'
import User from '../views/User.vue'
import Top from '../views/Top.vue'
import SignIn from '../views/auth/SignIn.vue'


const routes = [
  {
    path: '/',
    name: 'Top',
    component: Top
  },
  {
    path: '/signup',
    name: 'SignUp',
    component: SignUp
  },
  {
    path: '/signin',
    name: 'SignIn',
    component: SignIn
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