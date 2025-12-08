package com.camping.dto;

import java.math.BigDecimal;
import java.util.List;

/**
 * 价格设置 DTO
 */
public class PriceSetDTO {
    private Long typeId;
    private List<String> dates;
    private BigDecimal price;

    public PriceSetDTO() {
    }

    public PriceSetDTO(Long typeId, List<String> dates, BigDecimal price) {
        this.typeId = typeId;
        this.dates = dates;
        this.price = price;
    }

    public Long getTypeId() {
        return typeId;
    }

    public void setTypeId(Long typeId) {
        this.typeId = typeId;
    }

    public List<String> getDates() {
        return dates;
    }

    public void setDates(List<String> dates) {
        this.dates = dates;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }
}
