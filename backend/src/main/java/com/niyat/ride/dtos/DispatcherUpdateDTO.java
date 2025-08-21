package com.niyat.ride.dtos;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class DispatcherUpdateDTO {
    @NotBlank(message = "full name is required")
    private String firstName;

    @NotBlank(message = "full name is required")
    private String lastName;

    @NotBlank(message = "password is required")
    private String password;

    @NotBlank(message = "Email is required")
    @Email(message = "Email should be valid")
    private String email;

    private String assignedRegion;
}