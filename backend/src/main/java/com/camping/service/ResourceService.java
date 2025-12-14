package com.camping.service;

import com.camping.dto.PriceSetDTO;
import java.util.List;
import java.util.Map;

/**
 * 资源业务接口
 */
public interface ResourceService {

    /**
     * 获取所有房型列表
     */
    List<Object> getSiteTypes() throws Exception;

    /**
     * 获取当日房型列表（含当日价格与可用量）
     */
    List<Object> getSiteTypesToday() throws Exception;

    /**
     * 获取房型详情
     */
    Object getSiteTypeDetail(Long typeId) throws Exception;

    /**
     * 获取价格日历
     */
    Map<String, Object> getCalendar(Long typeId, String startDate, String endDate) throws Exception;

    /**
     * 获取装备列表
     */
    List<Object> getEquipments() throws Exception;

    /**
     * 获取当日装备列表（含当日可用库存）
     */
    List<Object> getEquipmentsToday() throws Exception;

    /**
     * 获取装备详情
     */
    Object getEquipmentDetail(Long equipId) throws Exception;
}
