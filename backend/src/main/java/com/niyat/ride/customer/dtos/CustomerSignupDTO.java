package com.niyat.ride.customer.dtos;


import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class CustomerSignupDTO {

    @NotBlank(message = "Phone number is required")
    private String phoneNumber;
}
