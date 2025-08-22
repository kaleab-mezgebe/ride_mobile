package com.niyat.ride.shared.dtos;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class NearbyDriverDTO {
    private Long driverId;
    private String firstName;
    private String lastName;
    private String phoneNumber;
    private BigDecimal rating;
    private Double distanceKm;
    private Integer estimatedArrivalMinutes;
    private VehicleInfoDTO vehicle;
    private String status;
    private Double currentLatitude;
    private Double currentLongitude;
    
    @Data
    public static class VehicleInfoDTO {
        private String vehicleType;
        private String vehicleModel;
        private String plateNumber;
        private Integer capacity;
        private String color;
    }
}
