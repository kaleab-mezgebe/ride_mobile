package com.niyat.ride.features.admin.user_management.dtos;

import com.niyat.ride.shared.dtos.BaseUserResponseDTO;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
public class AdminUserResponseDTO extends BaseUserResponseDTO {
    // Admin-specific fields can be added here if needed
}
