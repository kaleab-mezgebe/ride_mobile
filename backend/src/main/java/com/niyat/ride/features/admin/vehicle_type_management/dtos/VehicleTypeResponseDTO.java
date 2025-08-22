package com.niyat.ride.features.admin.vehicle_type_management.dtos;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class VehicleTypeResponseDTO {
    private Long id;
    private String name;
    private String description;
    private String image;
    private BigDecimal pricePerKm;
    private Boolean isActive;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private Integer capacity;
    private String features;
}
