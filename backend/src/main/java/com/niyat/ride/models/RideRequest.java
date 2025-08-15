package com.niyat.ride.models;

import com.niyat.ride.enums.RideStatus;
import jakarta.persistence.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "ride_requests")
public class RideRequest {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private Long passengerId;
    private Long driverId;

    private Double pickupLatitude;
    private Double pickupLongitude;


    private Double dropoffLatitude;
    private Double dropoffLongitude;


    @Enumerated(EnumType.STRING)
    private RideStatus status;

    private Double fare;
    private Double distanceKm;
    private Double estimatedDurationMin;

    private LocalDateTime requestedAt;
    private LocalDateTime acceptedAt;
    private LocalDateTime startedAt;
    private LocalDateTime completedAt;


}


