package com.niyat.ride.shared.dtos;

import com.niyat.ride.enums.AccountStatus;
import com.niyat.ride.enums.Role;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class BaseUserResponseDTO {
    private Long id;
    private String firstName;
    private String lastName;
    private String phoneNumber;
    private String email;
    private Boolean isVerified;
    private LocalDateTime verifiedAt;
    private Role role;
    private AccountStatus status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
