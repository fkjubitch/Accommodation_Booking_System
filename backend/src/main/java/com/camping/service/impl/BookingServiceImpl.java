package com.camping.service.impl;

import com.camping.dto.BookingCreateDTO;
import com.camping.dto.EquipSelectDTO;
import com.camping.entity.*;
import com.camping.repository.*;
import com.camping.service.BookingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

@Service
public class BookingServiceImpl implements BookingService {

    @Autowired private SiteTableRepository siteRepo;
    @Autowired private BookingTableRepository bookingRepo;
    @Autowired private EquipmentTableRepository equipRepo;
    @Autowired private BookingEquipRepository bookingEquipRepo;
    // ... 其他 Repository

    @Override
    @Transactional(rollbackFor = Exception.class) // 核心：事务控制
    public Map<String, Object> createOrder(BookingCreateDTO dto) {
        
        // 1. 价格计算一致性 (Price Consistency)
        // 后端必须重新计算，不信任前端传来的价格
        BigDecimal finalTotalPrice = BigDecimal.ZERO;
        
        // A. 计算基础房费 (结合 SiteType basePrice + DailyPrice 浮动)
        BigDecimal roomPrice = calculateRoomPrice(dto.getTypeId(), dto.getCheckIn(), dto.getCheckOut());
        finalTotalPrice = finalTotalPrice.add(roomPrice);

        // 2. 装备库存检查与价格计算
        for (EquipSelectDTO eq : dto.getEquipments()) {
            Equipment equip = equipRepo.findById(eq.getEquipId())
                .orElseThrow(() -> new RuntimeException("装备不存在"));
            
            // 核心算法：检查剩余库存
            Integer used = bookingEquipRepo.getUsedStock(eq.getEquipId(), dto.getCheckIn(), dto.getCheckOut());
            if (equip.getTotalStock() - used < eq.getCount()) {
                // 抛出异常，触发 @Transactional 回滚
                throw new RuntimeException("装备 " + equip.getEquipName() + " 库存不足");
            }
            
            // 累加装备费用
            BigDecimal equipCost = equip.getPrice().multiply(new BigDecimal(eq.getCount()));
            finalTotalPrice = finalTotalPrice.add(equipCost);
        }

        // 3. 营位自动分配 (Auto-Assign Site)
        // 查找该时间段未被占用的 Site
        SiteTable availableSite = siteRepo.findFirstAvailableSite(dto.getTypeId(), dto.getCheckIn(), dto.getCheckOut());
        if (availableSite == null) {
            throw new RuntimeException("该房型已满房");
        }

        // 4. 落库 (BookingTable)
        BookingTable booking = new BookingTable();
        booking.setUserId(dto.getUserId());
        booking.setSiteId(availableSite.getSiteId());
        booking.setTotalPrice(finalTotalPrice); // 写入后端计算的价格
        booking.setStatus(0); // 待支付
        booking.setCheckInTime(Timestamp.valueOf(dto.getCheckIn() + " 14:00:00"));
        booking.setCheckOutTime(Timestamp.valueOf(dto.getCheckOut() + " 12:00:00"));
        booking = bookingRepo.save(booking);

        // 5. 落库关联表 (BookingEquipTable)
        for (EquipSelectDTO eq : dto.getEquipments()) {
            BookingEquip be = new BookingEquip();
            be.setBookingId(booking.getBookingId());
            be.setEquipId(eq.getEquipId());
            be.setQuantity(eq.getCount());
            bookingEquipRepo.save(be);
        }

        // 6. 返回结果
        return Map.of(
            "bookingId", booking.getBookingId(),
            "siteNo", availableSite.getSiteNo(),
            "totalPrice", finalTotalPrice
        );
    }
    
    // 辅助方法：计算房费逻辑省略...
}