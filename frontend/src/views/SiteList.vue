<template>
  <div class="site-list">
    <h2>房型列表</h2>

    <div v-if="loading">加载中...</div>
    <div v-else>
      <ul>
        <li v-for="type in types" :key="type.typeId">
          <strong>{{ type.typeName || type.type_name || "房型" }}</strong>
          <div>
            基础价: {{ formatPrice(type.basePrice || type.base_price) }}
          </div>
          <div>最大入住: {{ type.maxGuests || type.max_guests || "-" }}</div>
          <div v-if="type.description || type.remark">
            说明: {{ type.description || type.remark }}
          </div>
        </li>
      </ul>
      <div v-if="types.length === 0">
        暂无房型数据（数据库或 API 可能未初始化）
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from "vue";
import { resourceApi } from "@/api";

const types = ref<any[]>([]);
const loading = ref(true);

function formatPrice(val: any) {
  if (val === undefined || val === null) return "-";
  return typeof val === "string" ? val : Number(val).toFixed(2);
}

onMounted(async () => {
  try {
    // 调用后端接口（若后端未启动或接口未实现，捕获异常）
    const res: any = await resourceApi.getSiteTypes();
    // 期望返回结构：{ code, msg, data }
    types.value = (res && res.data) || [];
  } catch (e) {
    // 静默失败，保留空数据以便演示数据库相关功能
    types.value = [];
  } finally {
    loading.value = false;
  }
});
</script>

<style scoped>
.site-list ul {
  list-style: none;
  padding: 0;
}
.site-list li {
  padding: 10px;
  border-bottom: 1px solid #eee;
}
</style>
