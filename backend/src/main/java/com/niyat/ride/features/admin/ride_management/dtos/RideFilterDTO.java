package com.niyat.ride.features.admin.ride_management.dtos;

import com.niyat.ride.enums.RideStatus;
import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class RideFilterDTO {
    private RideStatus status;
    private Long driverId;
    private Long customerId;
    
    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
    private LocalDateTime fromDate;
    
    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
    private LocalDateTime toDate;
    
    private BigDecimal minAmount;
    private BigDecimal maxAmount;
}
