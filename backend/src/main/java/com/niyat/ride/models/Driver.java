package com.niyat.ride.models;

import com.niyat.ride.enums.AccountStatus;
import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name = "drivers")
public class Driver extends User {
    private AccountStatus status;
    private String licenseNumber;
    private String vehicleType;
    private String vehiclePlateNumber;
}