<template>
  <div class="admin-dashboard">
    <h2>管理员面板（演示）</h2>

    <div class="cards">
      <div class="card">
        <h3>预订统计</h3>
        <div v-if="loadingStats">加载中...</div>
        <div v-else>
          <div>总订单: {{ stats.totalBookings || 0 }}</div>
          <div>已支付: {{ stats.paidBookings || 0 }}</div>
          <div>待支付: {{ stats.pendingPaymentBookings || 0 }}</div>
          <div>已取消: {{ stats.canceledBookings || 0 }}</div>
          <div>总收入: {{ stats.totalRevenue || 0 }}</div>
        </div>
      </div>

      <div class="card">
        <h3>简要报表 (示例)</h3>
        <div v-if="loadingReport">加载中...</div>
        <div v-else>
          <div>
            期间: {{ report.startDate || "-" }} ~ {{ report.endDate || "-" }}
          </div>
          <div>总收入: {{ report.totalRevenue || 0 }}</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from "vue";
import { adminApi } from "@/api";

const stats = ref<any>({});
const report = ref<any>({});
const loadingStats = ref(true);
const loadingReport = ref(true);

onMounted(async () => {
  try {
    const s: any = await adminApi.getBookingStats();
    stats.value = (s && s.data) || {};
  } catch (e) {
    stats.value = {};
  } finally {
    loadingStats.value = false;
  }

  try {
    const today = new Date();
    const start = new Date(today.getTime() - 7 * 24 * 3600 * 1000);
    const fmt = (d: Date) => d.toISOString().slice(0, 10);
    const r: any = await adminApi.getDailyReport(fmt(start), fmt(today));
    report.value = (r && r.data) || {};
  } catch (e) {
    report.value = {};
  } finally {
    loadingReport.value = false;
  }
});
</script>

<style scoped>
.cards {
  display: flex;
  gap: 12px;
  flex-wrap: wrap;
}
.card {
  border: 1px solid #e6e6e6;
  padding: 12px;
  border-radius: 6px;
  min-width: 200px;
}
</style>
