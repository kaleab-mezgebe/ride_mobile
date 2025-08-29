package com.niyat.ride.vehicle.models;

import com.niyat.ride.user.models.Driver;
import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name = "vehicles")
public class Vehicle {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false)
    private String plateNumber;

    @Column(nullable = false)
    private String model;

    @Column(nullable = false)
    private String color;

    @Column(nullable = false)
    private int numberOfSeats;

    @ManyToOne(optional = false)
    @JoinColumn(name = "type_id")
    private VehicleType type;

    @OneToOne
    @JoinColumn(name = "driver_id", unique = true)
    private Driver driver;
}
