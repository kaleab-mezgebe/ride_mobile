package com.niyat.ride.models;

import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.Data;

@Data
@Entity
@Table(name = "drivers")
public class Driver extends User {
    private String licenseNumber;
    private String vehicleType;
}
