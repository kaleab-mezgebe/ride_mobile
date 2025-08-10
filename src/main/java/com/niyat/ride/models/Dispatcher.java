package com.niyat.ride.models;

import jakarta.persistence.Entity;
import jakarta.persistence.Table;

@Entity
@Table(name = "dispatchers")
public class Dispatcher extends User {
    private String assignedRegion;
}
