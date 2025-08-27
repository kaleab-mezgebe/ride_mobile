package com.niyat.ride.services;

import com.niyat.ride.models.Vehicle;

public interface VehicleService {
    Vehicle createVehicle(Vehicle vehicle);
    Vehicle assignDriverToVehicle(Long vehicleId, Long driverId);
    Vehicle unassignDriver(Long vehicleId);
}

