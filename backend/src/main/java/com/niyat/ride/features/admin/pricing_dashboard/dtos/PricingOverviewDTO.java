package com.niyat.ride.features.admin.pricing_dashboard.dtos;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class PricingOverviewDTO {
    private List<VehicleTypePricingDTO> vehicleTypePricing;
    private BigDecimal averageBasePrice;
    private BigDecimal averagePricePerKm;
    private BigDecimal lowestBasePrice;
    private BigDecimal highestBasePrice;
    private Integer totalActiveVehicleTypes;
    private Integer totalInactiveVehicleTypes;
    
    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    public static class VehicleTypePricingDTO {
        private Long id;
        private String name;
        private BigDecimal basePrice;
        private BigDecimal pricePerKm;
        private Boolean isActive;
        private Integer ridesCount;
        private BigDecimal totalRevenue;
    }
}
