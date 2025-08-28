package com.niyat.ride.driver.dtos;

import com.niyat.ride.enums.Role;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class DriverResponseDTO {
    private Long id;
    private String firstName;
    private String lastName;
    private String email;
    private String phoneNumber;
    private Role role;
    private String status;
    private String licenseNumber;
    private String vehicleType;
    private String vehiclePlateNumber;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}