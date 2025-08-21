package com.niyat.ride.services;

import com.niyat.ride.models.Driver;
import com.niyat.ride.models.Vehicle;
import com.niyat.ride.models.VehicleType;

public interface VehicleService {
    Vehicle createVehicle(Vehicle vehicle);
    Vehicle assignDriverToVehicle(Long vehicleId, Long driverId);
    Vehicle unassignDriver(Long vehicleId);
}

