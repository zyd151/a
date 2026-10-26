import { createRouter, createWebHistory } from 'vue-router'
import LoginView from '../views/LoginView.vue'
import { getToken } from '../api/auth'

const routes = [
  {
    path: '/',
    name: 'login',
    component: LoginView
  },
  {
    path: '/register',
    name: 'register',
    component: () => import('../views/RegisterView.vue')
  },
  {
    path: '/home',
    name: 'home',
    component: () => import('../views/HomeView.vue')
  },
  // 兜底重定向到登录页
  {
    path: '/:pathMatch(.*)*',
    redirect: '/'
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// 路由守卫：进入 /home 必须已登录（持有 token），否则回到登录页
router.beforeEach((to) => {
  if (to.name === 'home' && !getToken()) {
    return { name: 'login' }
  }
  return true
})

export default router
