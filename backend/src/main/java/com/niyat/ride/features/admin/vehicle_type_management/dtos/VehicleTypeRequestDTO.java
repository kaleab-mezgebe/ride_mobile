package com.niyat.ride.features.admin.vehicle_type_management.dtos;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Data;

import java.math.BigDecimal;

@Data
public class VehicleTypeRequestDTO {
    @NotBlank(message = "Vehicle type name is required")
    private String name;

    private String description;
    private String image;

    @NotNull(message = "Price per km is required")
    @DecimalMin(value = "0.0", inclusive = false, message = "Price per km must be positive")
    private BigDecimal pricePerKm;

    @Positive(message = "Capacity must be positive")
    private Integer capacity;

    private String features;
}
