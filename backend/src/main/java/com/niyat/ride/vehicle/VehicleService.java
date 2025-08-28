package com.niyat.ride.vehicle;

public interface VehicleService {
    Vehicle createVehicle(Vehicle vehicle);
    Vehicle assignDriverToVehicle(Long vehicleId, Long driverId);
    Vehicle unassignDriver(Long vehicleId);
}

