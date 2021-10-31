import { createRouter, createWebHistory } from 'vue-router'
import SignUp from '../views/auth/SignUp.vue'
import Home from '../views/Home.vue'
import SignIn from '../views/auth/SignIn.vue'
import SignOut from '../views/auth/SignOut.vue'
import Edit from '../views/Edit.vue'
import UserIndividual from '../views/UserIndividual.vue'
import NotFound from '../views/NotFound.vue'



const routes = [
  {
    path: '/',
    redirect: '/home',
  },
  {
    path: '/home',
    name: 'Home',
    component: Home
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
    path: '/logout',
    name: 'SignOut',
    component: SignOut,
  },
  {
    path: '/edit/:myid',
    name: 'Edit',
    component: Edit,
  },
  {
    path: '/notfound',
    name: 'NotFound',
    component: NotFound,
  },
  {
    path: '/:myid',
    name: 'UserIndividual',
    component: UserIndividual
  },

]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

export default router