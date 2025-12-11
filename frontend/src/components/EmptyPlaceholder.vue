<template>
  <div class="placeholder">
    <slot>占位组件</slot>
  </div>
</template>

<script setup lang="ts">
// 通用占位组件
</script>

<style scoped>
.placeholder {
  padding: 12px;
  border: 1px dashed #ddd;
  border-radius: 6px;
  color: #666;
}
</style>
