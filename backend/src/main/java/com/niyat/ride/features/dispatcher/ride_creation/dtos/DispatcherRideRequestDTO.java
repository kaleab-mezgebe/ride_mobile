package com.niyat.ride.features.dispatcher.ride_creation.dtos;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class DispatcherRideRequestDTO {
    
    @NotNull(message = "Dispatcher ID is required")
    private Long dispatcherId;
    
    @Valid
    @NotNull(message = "Customer information is required")
    private CustomerInfoDTO customerInfo;
    
    @Valid
    @NotNull(message = "Pickup location is required")
    private LocationDTO pickupLocation;
    
    @Valid
    @NotNull(message = "Dropoff location is required") 
    private LocationDTO dropoffLocation;
    
    private Long vehicleTypePreference; // Optional vehicle type preference
    
    @Positive(message = "Estimated distance must be positive")
    private Double estimatedDistance; // in km
    
    @Positive(message = "Estimated duration must be positive")
    private Integer estimatedDuration; // in minutes
    
    @Size(max = 1000, message = "Notes must not exceed 1000 characters")
    private String notes;
}
