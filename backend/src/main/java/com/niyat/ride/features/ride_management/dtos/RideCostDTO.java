package com.niyat.ride.features.ride_management.dtos;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class RideCostDTO {
    private BigDecimal basePrice;
    private BigDecimal distancePrice;
    private BigDecimal totalCost;
    private BigDecimal surgeFactor;
    private BigDecimal surgeAmount;
    private BigDecimal discountAmount;
    private BigDecimal finalCost;
    private Double distanceKm;
    private Long vehicleTypeId;
    private String vehicleTypeName;
    private String priceBreakdown;
    
    public RideCostDTO(BigDecimal basePrice, BigDecimal distancePrice, BigDecimal totalCost, Double distanceKm) {
        this.basePrice = basePrice;
        this.distancePrice = distancePrice;
        this.totalCost = totalCost;
        this.finalCost = totalCost;
        this.distanceKm = distanceKm;
        this.surgeFactor = BigDecimal.ONE;
        this.surgeAmount = BigDecimal.ZERO;
        this.discountAmount = BigDecimal.ZERO;
    }
}
