package com.niyat.ride.features.admin.ride_management.dtos;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.Map;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class RideSummaryDTO {
    private Long totalRidesCount;
    private Long completedRidesCount;
    private Long cancelledRidesCount;
    private Long inProgressRidesCount;
    private Long requestedRidesCount;
    
    private BigDecimal totalRevenue;
    private BigDecimal averageRideValue;
    private Double averageDistance;
    private Double averageDuration;
    
    private Map<String, BigDecimal> revenueByPeriod; // day, week, month
    private Map<String, Long> ridesByStatus;
    private Map<String, Long> ridesByVehicleType;
}
