package com.niyat.ride.dtos;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class CustomerUpdateDTO {

    @NotBlank(message = "full name is required")
    private String fullName;

    @Email(message = "Email should be valid")
    private String email;

}