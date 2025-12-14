package com.camping.controller;

import com.camping.common.Result;
import com.camping.service.ResourceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.*;

/**
 * 资源查询控制器
 */
@RestController
public class ResourceController {

    @Autowired
    private ResourceService resourceService;

    /**
     * 获取当日房型列表（含当日价格与可用量）
     */
    @GetMapping("/type/list/today")
    public Result<List<Object>> getSiteTypesToday() {
        try {
            // TODO: 调用 Service 查询 view_site_availability_today
            List<Object> list = resourceService.getSiteTypesToday();
            return Result.success(list);
        } catch (Exception e) {
            return Result.error("获取当日房型列表失败: " + e.getMessage());
        }
    }

    /**
     * 获取所有房型列表
     */
    @GetMapping("/type/list")
    public Result<List<Object>> getSiteTypes() {
        try {
            // TODO: 调用 Service 查询房型列表，并补充 totalSites/availableSites
            List<Object> types = resourceService.getSiteTypes();
            return Result.success(types);
        } catch (Exception e) {
            return Result.error("获取房型列表失败: " + e.getMessage());
        }
    }

    /**
     * 获取房型详情
     */
    @GetMapping("/type/{typeId}")
    public Result<Object> getSiteTypeDetail(@PathVariable Long typeId) {
        try {
            // TODO: 从数据库查询房型详情
            Object detail = resourceService.getSiteTypeDetail(typeId);
            return Result.success(detail);
        } catch (Exception e) {
            return Result.error("获取房型详情失败: " + e.getMessage());
        }
    }

    /**
     * 获取价格日历
     * 返回指定日期范围内，每天的价格和库存情况
     */
    @GetMapping("/type/calendar")
    public Result<Object> getCalendar(@RequestParam Long typeId,
            @RequestParam String startDate,
            @RequestParam String endDate) {
        try {
            Map<String, Object> calendar = resourceService.getCalendar(typeId, startDate, endDate);
            return Result.success(calendar);
        } catch (Exception e) {
            return Result.error("获取日历失败: " + e.getMessage());
        }
    }

    /**
     * 获取指定日期范围的日价
     */
    @PostMapping("/type/prices")
    public Result<List<Object>> getDailyPrices(@RequestBody Map<String, Object> data) {
        try {
            // TODO: 从数据库查询日价信息
            return Result.success(new ArrayList<>());
        } catch (Exception e) {
            return Result.error("获取日价失败: " + e.getMessage());
        }
    }

    /**
     * 获取所有装备列表
     */
    @GetMapping("/equip/list")
    public Result<List<Object>> getEquipments() {
        try {
            // TODO: 调用 Service 查询装备列表，返回 totalStock/availableStock
            List<Object> list = resourceService.getEquipments();
            return Result.success(list);
        } catch (Exception e) {
            return Result.error("获取装备列表失败: " + e.getMessage());
        }
    }

    /**
     * 获取当日装备列表（含当日可用库存）
     */
    @GetMapping("/equip/list/today")
    public Result<List<Object>> getEquipmentsToday() {
        try {
            // TODO: 调用 Service 查询 view_equipment_availability_today
            List<Object> list = resourceService.getEquipmentsToday();
            return Result.success(list);
        } catch (Exception e) {
            return Result.error("获取装备可用库存失败: " + e.getMessage());
        }
    }

    /**
     * 获取装备详情
     */
    @GetMapping("/equip/{equipId}")
    public Result<Object> getEquipmentDetail(@PathVariable Long equipId) {
        try {
            // TODO: 从数据库查询装备详情
            Object detail = resourceService.getEquipmentDetail(equipId);
            return Result.success(detail);
        } catch (Exception e) {
            return Result.error("获取装备详情失败: " + e.getMessage());
        }
    }

    /**
     * 获取装备库存信息
     */
    @PostMapping("/equip/stock")
    public Result<List<Object>> getEquipmentStock(@RequestBody Map<String, Object> data) {
        try {
            // TODO: 查询多个装备的库存
            return Result.success(new ArrayList<>());
        } catch (Exception e) {
            return Result.error("获取装备库存失败: " + e.getMessage());
        }
    }

    /**
     * 获取装备分类列表
     */
    @GetMapping("/equip/categories")
    public Result<List<Object>> getEquipmentCategories() {
        try {
            // TODO: 从数据库查询装备分类
            return Result.success(new ArrayList<>());
        } catch (Exception e) {
            return Result.error("获取分类列表失败: " + e.getMessage());
        }
    }

    /**
     * 根据分类获取装备列表
     */
    @GetMapping("/equip/category/{category}")
    public Result<List<Object>> getEquipmentsByCategory(@PathVariable String category) {
        try {
            // TODO: 按分类查询装备
            return Result.success(new ArrayList<>());
        } catch (Exception e) {
            return Result.error("获取分类装备失败: " + e.getMessage());
        }
    }

    /**
     * 查询指定资源在日期范围内的剩余数量
     * kind: site|equip, typeId: 房型ID或装备类型ID
     */
    @GetMapping("/availability/query")
    public Result<Object> queryAvailability(@RequestParam String kind,
            @RequestParam Long typeId,
            @RequestParam String startDate,
            @RequestParam String endDate) {
        try {
            // TODO: 根据 kind 判断查询房型或装备在日期范围的剩余量
            // 返回示例: { kind:"site", typeId:1, startDate, endDate, remaining: 5, total: 10 }
            var data = new java.util.HashMap<String, Object>();
            data.put("kind", kind);
            data.put("typeId", typeId);
            data.put("startDate", startDate);
            data.put("endDate", endDate);
            data.put("remaining", 0);
            data.put("total", 0);
            return Result.success(data);
        } catch (Exception e) {
            return Result.error("查询可用量失败: " + e.getMessage());
        }
    }
}