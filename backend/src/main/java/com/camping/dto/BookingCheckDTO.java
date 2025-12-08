package com.camping.dto;

import java.util.List;

/**
 * 预订检查 DTO
 */
public class BookingCheckDTO {
    private Long typeId;
    private String checkIn;
    private String checkOut;
    private List<EquipSelectDTO> equipments;

    public BookingCheckDTO() {
    }

    public BookingCheckDTO(Long typeId, String checkIn, String checkOut, List<EquipSelectDTO> equipments) {
        this.typeId = typeId;
        this.checkIn = checkIn;
        this.checkOut = checkOut;
        this.equipments = equipments;
    }

    public Long getTypeId() {
        return typeId;
    }

    public void setTypeId(Long typeId) {
        this.typeId = typeId;
    }

    public String getCheckIn() {
        return checkIn;
    }

    public void setCheckIn(String checkIn) {
        this.checkIn = checkIn;
    }

    public String getCheckOut() {
        return checkOut;
    }

    public void setCheckOut(String checkOut) {
        this.checkOut = checkOut;
    }

    public List<EquipSelectDTO> getEquipments() {
        return equipments;
    }

    public void setEquipments(List<EquipSelectDTO> equipments) {
        this.equipments = equipments;
    }
}
