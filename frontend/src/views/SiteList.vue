<template>
  <div class="site-list">
    <section class="block">
      <header class="block__title">房型列表</header>
      <div v-if="loadingTypes" class="loading">加载中...</div>
      <ul v-else class="card-list">
        <li v-for="type in types" :key="type.typeId" class="card">
          <div class="card__head">
            <div class="card__name">{{ type.typeName }}</div>
            <div class="card__price">
              ￥{{ formatPrice(type.basePrice) }}/晚
            </div>
          </div>
          <div class="card__meta">
            <span>可住 {{ type.maxGuests }} 人</span>
            <span
              >剩余 {{ type.availableSites }} /
              {{ type.totalSites || type.availableSites || "-" }}</span
            >
          </div>
          <p v-if="type.description" class="card__desc">
            {{ type.description }}
          </p>
        </li>
      </ul>
      <div v-if="!loadingTypes && types.length === 0" class="empty">
        暂无房型数据
      </div>
    </section>

    <section class="block">
      <header class="block__title">装备列表</header>
      <div v-if="loadingEquipments" class="loading">加载中...</div>
      <ul v-else class="card-list">
        <li v-for="equip in equipments" :key="equip.equipId" class="card">
          <div class="card__head">
            <div class="card__name">{{ equip.equipName }}</div>
            <div class="card__price">￥{{ formatPrice(equip.unitPrice) }}</div>
          </div>
          <div class="card__meta">
            <span>分类：{{ equip.category || "通用" }}</span>
            <span>剩余 {{ equip.availableStock }}</span>
          </div>
          <p v-if="equip.description" class="card__desc">
            {{ equip.description }}
          </p>
        </li>
      </ul>
      <div v-if="!loadingEquipments && equipments.length === 0" class="empty">
        暂无装备数据
      </div>
    </section>
  </div>
</template>

<script setup lang="ts">
import { onMounted, ref } from "vue";
import { resourceApi } from "@/api";
import type { SiteType, Equipment } from "@/api";

type SiteCard = {
  typeId: number;
  typeName: string;
  basePrice: number;
  maxGuests: number;
  description?: string;
  availableSites: number;
  totalSites: number;
};

type EquipCard = {
  equipId: number;
  equipName: string;
  unitPrice: number;
  availableStock: number;
  description?: string;
  category?: string;
};

const fallbackSiteTypes: SiteCard[] = [
  {
    typeId: 1,
    typeName: "湖景標准營位",
    basePrice: 120,
    maxGuests: 4,
    description: "臨湖草地，含電桩與野餐桌",
    availableSites: 8,
    totalSites: 10,
  },
  {
    typeId: 2,
    typeName: "森林豪華營位",
    basePrice: 220,
    maxGuests: 6,
    description: "樹蔭寬闊，附遮陽與吊床",
    availableSites: 10,
    totalSites: 10,
  },
  {
    typeId: 3,
    typeName: "星空A字小屋",
    basePrice: 320,
    maxGuests: 4,
    description: "硬頂小屋，配備空調與獨立衛浴",
    availableSites: 10,
    totalSites: 10,
  },
  {
    typeId: 4,
    typeName: "全套接駁房車位",
    basePrice: 180,
    maxGuests: 8,
    description: "房車泊位，上下水與30A電源",
    availableSites: 10,
    totalSites: 10,
  },
  {
    typeId: 5,
    typeName: "輕奢鈴鐺帳",
    basePrice: 260,
    maxGuests: 4,
    description: "木平台 + 棉布帳，含氛圍燈",
    availableSites: 10,
    totalSites: 10,
  },
];

const fallbackEquipments: EquipCard[] = [
  {
    equipId: 1,
    equipName: "羽絨睡袋",
    unitPrice: 28,
    availableStock: 120,
    description: "舒適溫標5C，可壓縮",
    category: "睡眠",
  },
  {
    equipId: 2,
    equipName: "自充氣防潮墊",
    unitPrice: 16,
    availableStock: 160,
    description: "5cm 厚度，R值 3.5",
    category: "睡眠",
  },
  {
    equipId: 3,
    equipName: "鈦合金炊煮套裝",
    unitPrice: 45,
    availableStock: 90,
    description: "含鍋碗與酒精爐架",
    category: "烹飪",
  },
  {
    equipId: 4,
    equipName: "雙口瓦斯爐",
    unitPrice: 55,
    availableStock: 70,
    description: "含兩罐230g氣罐",
    category: "烹飪",
  },
  {
    equipId: 5,
    equipName: "可折疊桌椅組",
    unitPrice: 32,
    availableStock: 140,
    description: "四人桌 + 四折疊椅",
    category: "營地",
  },
  {
    equipId: 6,
    equipName: "LED氛圍燈串",
    unitPrice: 12,
    availableStock: 180,
    description: "USB 供電，10m 長",
    category: "照明",
  },
  {
    equipId: 7,
    equipName: "便攜保溫冰箱",
    unitPrice: 48,
    availableStock: 80,
    description: "42L，附車載電源線",
    category: "存儲",
  },
  {
    equipId: 8,
    equipName: "戶外咖啡組",
    unitPrice: 26,
    availableStock: 110,
    description: "手沖壺 + 濾杯 + 豆",
    category: "烹飪",
  },
];

const types = ref<SiteCard[]>([]);
const equipments = ref<EquipCard[]>([]);
const loadingTypes = ref(true);
const loadingEquipments = ref(true);

const normalizeSiteType = (
  raw: Partial<SiteType> & Record<string, any>
): SiteCard => {
  const total = Number(raw.totalSites ?? raw.total_sites ?? raw.siteCount ?? 0);
  const occupied = Number(
    raw.occupiedSites ?? raw.occupied_sites ?? raw.busyCount ?? 0
  );
  const availableCandidate =
    raw.availableSites ?? raw.available_sites ?? undefined;
  const available =
    availableCandidate !== undefined
      ? Number(availableCandidate)
      : total
      ? Math.max(total - occupied, 0)
      : 0;

  return {
    typeId: Number(raw.typeId ?? raw.type_id ?? raw.id ?? 0),
    typeName: String(raw.typeName ?? raw.type_name ?? "未命名房型"),
    basePrice: Number(raw.basePrice ?? raw.base_price ?? 0),
    maxGuests: Number(raw.maxGuests ?? raw.max_guests ?? 0),
    description: raw.description ?? raw.remark ?? "",
    availableSites: available,
    totalSites: total || available,
  };
};

const normalizeEquipment = (
  raw: Partial<Equipment> & Record<string, any>
): EquipCard => {
  const total = Number(raw.totalStock ?? raw.total_stock ?? raw.stock ?? 0);
  const reserved = Number(raw.reserved ?? raw.reserved_stock ?? 0);
  const availableCandidate =
    raw.availableStock ?? raw.available_stock ?? undefined;
  const available =
    availableCandidate !== undefined
      ? Number(availableCandidate)
      : total
      ? Math.max(total - reserved, 0)
      : 0;

  return {
    equipId: Number(raw.equipId ?? raw.equip_id ?? raw.id ?? 0),
    equipName: String(raw.equipName ?? raw.equip_name ?? "未命名装备"),
    unitPrice: Number(raw.unitPrice ?? raw.unit_price ?? raw.price ?? 0),
    availableStock: available,
    description: raw.description ?? raw.remark ?? "",
    category: raw.category ?? raw.type ?? "",
  };
};

const loadSiteTypes = async () => {
  loadingTypes.value = true;
  try {
    const res = await resourceApi.getSiteTypes();
    const data = (res?.data ?? []).map(normalizeSiteType);
    types.value = data.length ? data : fallbackSiteTypes;
  } catch (error) {
    types.value = fallbackSiteTypes;
  } finally {
    loadingTypes.value = false;
  }
};

const loadEquipments = async () => {
  loadingEquipments.value = true;
  try {
    const res = await resourceApi.getEquipments();
    const data = (res?.data ?? []).map(normalizeEquipment);
    equipments.value = data.length ? data : fallbackEquipments;
  } catch (error) {
    equipments.value = fallbackEquipments;
  } finally {
    loadingEquipments.value = false;
  }
};

function formatPrice(val: any) {
  if (val === undefined || val === null) return "-";
  return Number(val).toFixed(2);
}

onMounted(() => {
  loadSiteTypes();
  loadEquipments();
});
</script>

<style scoped>
.site-list {
  display: grid;
  gap: 24px;
  padding: 16px;
}

.block {
  background: #fff;
  border: 1px solid #e6e6e6;
  border-radius: 8px;
  padding: 16px;
  box-shadow: 0 6px 18px rgba(0, 0, 0, 0.04);
}

.block__title {
  font-size: 18px;
  font-weight: 600;
  margin-bottom: 12px;
}

.card-list {
  list-style: none;
  padding: 0;
  margin: 0;
  display: grid;
  gap: 12px;
}

.card {
  border: 1px solid #f0f0f0;
  border-radius: 8px;
  padding: 12px 14px;
  background: linear-gradient(135deg, #fafafa, #ffffff);
}

.card__head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 6px;
}

.card__name {
  font-weight: 600;
  font-size: 15px;
}

.card__price {
  color: #f97316;
  font-weight: 600;
}

.card__meta {
  display: flex;
  gap: 12px;
  font-size: 13px;
  color: #606266;
  flex-wrap: wrap;
}

.card__desc {
  margin: 6px 0 0;
  color: #4b5563;
  font-size: 13px;
}

.loading,
.empty {
  color: #6b7280;
  font-size: 14px;
}
</style>
