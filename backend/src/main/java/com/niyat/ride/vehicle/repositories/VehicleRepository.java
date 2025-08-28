package com.niyat.ride.vehicle.repositories;

import com.niyat.ride.vehicle.models.Vehicle;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface VehicleRepository extends JpaRepository<Vehicle, Long> {
    Optional<Vehicle> findByPlateNumber(String plateNumber);
}
