package com.niyat.ride.vehicle.services;

import com.niyat.ride.vehicle.models.Vehicle;

public interface VehicleService {
    Vehicle createVehicle(Vehicle vehicle);
    Vehicle assignDriverToVehicle(Long vehicleId, Long driverId);
    Vehicle unassignDriver(Long vehicleId);
}

