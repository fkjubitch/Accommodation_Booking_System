import { createApp } from 'vue'
import App from './App.vue'
import router from './router'

const app = createApp(App)
app.use(router)
app.mount('#app')

// 如果项目未来使用 Element Plus、Pinia 等，可在此注册
