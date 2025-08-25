package com.niyat.ride.features.admin.vehicle_type_management.dtos;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class VehicleTypeStatusDTO {
    @NotNull(message = "Status is required")
    private Boolean isActive;
}
