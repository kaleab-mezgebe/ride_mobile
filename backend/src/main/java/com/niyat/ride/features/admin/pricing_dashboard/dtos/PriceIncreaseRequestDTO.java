package com.niyat.ride.features.admin.pricing_dashboard.dtos;

import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;
import java.util.List;

@Data
public class PriceIncreaseRequestDTO {
    @NotNull(message = "Percentage increase is required")
    @DecimalMin(value = "0.1", message = "Percentage increase must be at least 0.1%")
    @DecimalMax(value = "100.0", message = "Percentage increase cannot exceed 100%")
    private BigDecimal percentageIncrease;

    private String reason;

    private List<Long> vehicleTypeIds; // If null, apply to all active vehicle types

    private Boolean applyToBasePrice = true;
    private Boolean applyToPricePerKm = true;
}
