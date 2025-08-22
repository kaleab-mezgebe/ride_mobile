package com.niyat.ride.features.dispatcher.ride_creation.dtos;

import com.niyat.ride.enums.RideStatus;
import com.niyat.ride.features.dispatcher.ride_creation.dtos.LocationDTO;
import com.niyat.ride.shared.dtos.NearbyDriverDTO;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class DispatcherRideResponseDTO {
    
    private Long id;
    private Long customerId;
    private String customerName;
    private String customerPhoneNumber;
    private Long driverId;
    private String driverName;
    private Long vehicleTypeId;
    private String vehicleTypeName;
    
    // Location details
    private LocationDTO pickupLocation;
    private LocationDTO dropoffLocation;
    
    // Ride details
    private RideStatus status;
    private BigDecimal estimatedCost;
    private BigDecimal finalCost;
    private Double distanceKm;
    private Integer estimatedDurationMin;
    
    // Nearby drivers for assignment
    private List<NearbyDriverDTO> nearbyDrivers;
    
    // Pricing details
    private BigDecimal basePrice;
    private BigDecimal distancePrice;
    private String priceBreakdown;
    
    // Timestamps
    private LocalDateTime requestedAt;
    private LocalDateTime acceptedAt;
    private LocalDateTime startedAt;
    private LocalDateTime completedAt;
    private LocalDateTime cancelledAt;
    
    private String cancellationReason;
    private String notes;
    
    // Dispatcher information
    private Long dispatcherId;
    private String dispatcherName;
}
