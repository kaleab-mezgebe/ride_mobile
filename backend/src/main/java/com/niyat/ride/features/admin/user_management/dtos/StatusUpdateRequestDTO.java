package com.niyat.ride.features.admin.user_management.dtos;

import com.niyat.ride.enums.AccountStatus;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class StatusUpdateRequestDTO {
    @NotNull(message = "Status is required")
    private AccountStatus status;
}
