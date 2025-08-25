package com.niyat.ride.features.admin.ride_management.services;

import com.niyat.ride.enums.RideStatus;
import com.niyat.ride.features.admin.ride_management.dtos.RideResponseDTO;
import com.niyat.ride.features.admin.ride_management.dtos.RideSummaryDTO;
import org.springframework.data.domain.Page;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public interface RideManagementService {
    Page<RideResponseDTO> getAllRides(Integer page, Integer size, String sortBy, String sortDirection,
                                     RideStatus status, Long driverId, Long customerId,
                                     LocalDateTime fromDate, LocalDateTime toDate,
                                     BigDecimal minAmount, BigDecimal maxAmount);
    
    Page<RideResponseDTO> getAllRideRequests(Integer page, Integer size, String sortBy, String sortDirection,
                                           RideStatus status, Long driverId, Long customerId,
                                           LocalDateTime fromDate, LocalDateTime toDate,
                                           BigDecimal minAmount, BigDecimal maxAmount);
    
    RideSummaryDTO getRidesSummary();
    
    RideResponseDTO getRideById(Long id);
}
