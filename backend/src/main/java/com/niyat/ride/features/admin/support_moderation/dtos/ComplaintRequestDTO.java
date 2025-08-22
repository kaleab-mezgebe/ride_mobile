package com.niyat.ride.features.admin.support_moderation.dtos;

import com.niyat.ride.enums.ComplaintPriority;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class ComplaintRequestDTO {
    @NotNull(message = "Complainant ID is required")
    private Long complainantId;

    private Long rideRequestId;

    @NotBlank(message = "Title is required")
    private String title;

    @NotBlank(message = "Description is required")
    private String description;

    private ComplaintPriority priority = ComplaintPriority.MEDIUM;

    private Long assignedToAdminId;
}
