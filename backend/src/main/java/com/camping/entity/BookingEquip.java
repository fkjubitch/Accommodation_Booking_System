package com.camping.entity;

import java.time.LocalDateTime;

/**
 * 预订装备实体类
 */
public class BookingEquip {
    private Long bookingEquipId;
    private Long bookingId;
    private Long equipId;
    private Integer quantity;
    private LocalDateTime createTime;

    public BookingEquip() {
    }

    public Long getBookingEquipId() {
        return bookingEquipId;
    }

    public void setBookingEquipId(Long bookingEquipId) {
        this.bookingEquipId = bookingEquipId;
    }

    public Long getBookingId() {
        return bookingId;
    }

    public void setBookingId(Long bookingId) {
        this.bookingId = bookingId;
    }

    public Long getEquipId() {
        return equipId;
    }

    public void setEquipId(Long equipId) {
        this.equipId = equipId;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public LocalDateTime getCreateTime() {
        return createTime;
    }

    public void setCreateTime(LocalDateTime createTime) {
        this.createTime = createTime;
    }
}
