package com.niyat.ride.features.admin.user_management.dtos;

import com.niyat.ride.shared.dtos.BaseUserResponseDTO;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
public class DispatcherUserResponseDTO extends BaseUserResponseDTO {
    private String assignedRegion;
}
