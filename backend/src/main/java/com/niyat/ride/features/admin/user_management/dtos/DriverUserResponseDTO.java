package com.niyat.ride.features.admin.user_management.dtos;

import com.niyat.ride.shared.dtos.BaseUserResponseDTO;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
public class DriverUserResponseDTO extends BaseUserResponseDTO {
    private String licenseNumber;
    private String licenseImagePath;
}
