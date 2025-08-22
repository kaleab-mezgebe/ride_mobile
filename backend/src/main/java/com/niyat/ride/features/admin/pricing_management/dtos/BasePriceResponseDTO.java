package com.niyat.ride.features.admin.pricing_management.dtos;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class BasePriceResponseDTO {
    private Long id;
    private BigDecimal amount;
    private String currency;
    private Boolean isActive;
    private String changeReason;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private String updatedByAdminName;
}
