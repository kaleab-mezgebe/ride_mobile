package com.niyat.ride.features.admin.support_moderation.dtos;

import com.niyat.ride.enums.ComplaintStatus;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class ComplaintStatusDTO {
    @NotNull(message = "Status is required")
    private ComplaintStatus status;
    
    private String resolution;
}
