import { createRouter, createWebHashHistory } from 'vue-router'
import SiteList from '@/views/SiteList.vue'
import BookingConfirm from '@/views/BookingConfirm.vue'
import AdminDashboard from '@/views/AdminDashboard.vue'

const routes = [
  { path: '/', redirect: '/site-list' },
  { path: '/site-list', component: SiteList },
  { path: '/booking-confirm', component: BookingConfirm },
  { path: '/admin', component: AdminDashboard }
]

const router = createRouter({
  history: createWebHashHistory(),
  routes
})

export default router
