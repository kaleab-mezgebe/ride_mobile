package com.niyat.ride.features.dispatcher.ride_creation.dtos;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class CustomerInfoDTO {
    
    private Long customerId; // For existing customers
    
    @NotBlank(message = "Phone number is required")
    private String phoneNumber;
    
    @Size(max = 50, message = "First name must not exceed 50 characters")
    private String firstName;
    
    @Size(max = 50, message = "Last name must not exceed 50 characters")
    private String lastName;
    
    @NotNull(message = "isNewCustomer flag is required")
    private Boolean isNewCustomer;
    
    // Additional customer details for new customers
    private String email;
    
    @Size(max = 500, message = "Notes must not exceed 500 characters")
    private String notes;
}
