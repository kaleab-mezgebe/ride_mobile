package com.niyat.ride.features.admin.pricing_dashboard.dtos;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class PricingAnalyticsDTO {
    private Map<String, BigDecimal> averageRideCostByVehicleType;
    private Map<String, Long> mostPopularVehicleTypes;
    private Map<String, BigDecimal> revenueByVehicleType;
    private List<PricingChangeHistoryDTO> recentPricingChanges;
    private BigDecimal totalRevenueLast30Days;
    private BigDecimal averageRevenuePerRide;
    private Long totalRidesLast30Days;
    
    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    public static class PricingChangeHistoryDTO {
        private Long id;
        private String vehicleTypeName;
        private BigDecimal oldBasePrice;
        private BigDecimal newBasePrice;
        private BigDecimal oldPricePerKm;
        private BigDecimal newPricePerKm;
        private BigDecimal changePercentage;
        private String changeReason;
        private String changedByAdminName;
        private LocalDateTime createdAt;
    }
}
