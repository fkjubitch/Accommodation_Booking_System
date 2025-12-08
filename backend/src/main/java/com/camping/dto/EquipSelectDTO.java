package com.camping.dto;

/**
 * 装备选择 DTO
 */
public class EquipSelectDTO {
    private Long equipId;
    private Integer count;

    public EquipSelectDTO() {
    }

    public EquipSelectDTO(Long equipId, Integer count) {
        this.equipId = equipId;
        this.count = count;
    }

    public Long getEquipId() {
        return equipId;
    }

    public void setEquipId(Long equipId) {
        this.equipId = equipId;
    }

    public Integer getCount() {
        return count;
    }

    public void setCount(Integer count) {
        this.count = count;
    }
}
