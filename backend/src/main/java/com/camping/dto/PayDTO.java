package com.camping.dto;

/**
 * 支付 DTO
 */
public class PayDTO {
    private Long bookingId;

    public PayDTO() {
    }

    public PayDTO(Long bookingId) {
        this.bookingId = bookingId;
    }

    public Long getBookingId() {
        return bookingId;
    }

    public void setBookingId(Long bookingId) {
        this.bookingId = bookingId;
    }
}
