package com.niyat.ride.features.admin.ride_management.dtos;

import com.niyat.ride.enums.RideStatus;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class RideResponseDTO {
    private Long id;
    private Long passengerId;
    private String passengerName;
    private Long driverId;
    private String driverName;
    private Long vehicleTypeId;
    private String vehicleTypeName;
    
    private Double pickupLatitude;
    private Double pickupLongitude;
    private String pickupAddress;
    
    private Double dropoffLatitude;
    private Double dropoffLongitude;
    private String dropoffAddress;
    
    private RideStatus status;
    private BigDecimal estimatedCost;
    private BigDecimal finalCost;
    private Double distanceKm;
    private Integer estimatedDurationMin;
    
    private LocalDateTime requestedAt;
    private LocalDateTime acceptedAt;
    private LocalDateTime startedAt;
    private LocalDateTime completedAt;
    private LocalDateTime cancelledAt;
    
    private String cancellationReason;
    private String notes;
}
