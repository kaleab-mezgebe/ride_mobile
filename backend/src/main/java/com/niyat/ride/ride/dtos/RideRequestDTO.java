package com.niyat.ride.ride.dtos;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class RideRequestDTO {
    private double pickupLat;
    private double pickupLon;
    private String pickupAddress;
    private Double dropoffLat;
    private Double dropoffLon;
    private String dropoffAddress;
    private Long vehicleTypeId;
}

