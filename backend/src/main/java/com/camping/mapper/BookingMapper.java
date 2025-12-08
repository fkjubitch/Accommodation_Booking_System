package com.camping.mapper;

import com.camping.entity.Booking;
import java.util.List;

/**
 * 预订 Mapper 接口
 */
public interface BookingMapper {

    /**
     * 根据ID查询预订
     */
    Booking selectById(Long bookingId);

    /**
     * 按用户查询预订
     */
    List<Booking> selectByUserId(Long userId);

    /**
     * 按用户和状态查询预订
     */
    List<Booking> selectByUserIdAndStatus(Long userId, Integer status);

    /**
     * 查询时间段内的冲突预订
     */
    List<Booking> selectConflict(Long typeId, String checkIn, String checkOut);

    /**
     * 插入预订
     */
    void insert(Booking booking);

    /**
     * 更新预订
     */
    void update(Booking booking);
}
