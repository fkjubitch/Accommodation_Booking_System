<template>
  <div id="app">
    <HeaderBar />

    <main class="app-main">
      <section>
        <p>
          这是一个数据库课程设计的前端演示壳。使用项目自带的路由（如已配置）可访问各视图。
        </p>
        <p>
          如果未配置路由，请直接打开对应视图文件查看或在路由中注册这些组件：
        </p>
        <ul>
          <li>`/src/views/SiteList.vue`</li>
          <li>`/src/views/BookingConfirm.vue`</li>
          <li>`/src/views/AdminDashboard.vue`</li>
        </ul>
      </section>

      <section class="demo-area">
        <!-- 如果已安装并配置路由，router-view 会渲染具体页面 -->
        <router-view v-if="$router" />
      </section>
    </main>

    <FooterBar />
  </div>
</template>

<script setup lang="ts">
import HeaderBar from "@/components/HeaderBar.vue";
import FooterBar from "@/components/FooterBar.vue";

// 根组件不需要复杂逻辑，组件化头部/底部已在模板中使用
</script>

<style scoped>
#app {
  font-family: Arial, Helvetica, sans-serif;
  color: #333;
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}
.app-header {
  background: #1976d2;
  color: #fff;
  padding: 12px 20px;
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.nav-links a {
  color: #fff;
  margin-left: 12px;
  text-decoration: none;
}
.app-main {
  flex: 1;
  padding: 20px;
}
.demo-area {
  margin-top: 16px;
}
.app-footer {
  text-align: center;
  padding: 10px;
  background: #f5f5f5;
}
</style>
