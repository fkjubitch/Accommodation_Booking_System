package com.camping.mapper;

import com.camping.entity.BookingEquip;
import java.util.List;

/**
 * 预订装备关联 Mapper 接口
 */
public interface BookingEquipMapper {

    /**
     * 按预订ID查询装备
     */
    List<BookingEquip> selectByBookingId(Long bookingId);

    /**
     * 查询装备在时间段内的使用总数
     */
    Integer sumQuantityByEquipAndDate(Long equipId, String checkIn, String checkOut);

    /**
     * 插入预订装备
     */
    void insert(BookingEquip bookingEquip);

    /**
     * 删除预订装备
     */
    void deleteByBookingId(Long bookingId);
}
