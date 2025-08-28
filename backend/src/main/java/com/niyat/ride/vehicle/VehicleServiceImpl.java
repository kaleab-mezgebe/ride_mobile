package com.niyat.ride.vehicle;

import com.niyat.ride.driver.models.Driver;
import com.niyat.ride.driver.repositories.DriverRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class VehicleServiceImpl implements VehicleService {

    private final VehicleRepository vehicleRepository;
    private final DriverRepository driverRepository;

    @Override
    public Vehicle createVehicle(Vehicle vehicle) {
        vehicleRepository.findByPlateNumber(vehicle.getPlateNumber())
                .ifPresent(v -> { throw new RuntimeException("Plate already exists"); });
        return vehicleRepository.save(vehicle);
    }

    @Override
    @Transactional
    public Vehicle assignDriverToVehicle(Long vehicleId, Long driverId) {
        Vehicle vehicle = vehicleRepository.findById(vehicleId)
                .orElseThrow(() -> new RuntimeException("Vehicle not found"));

        if (vehicle.getDriver() != null) {
            throw new RuntimeException("Vehicle already assigned");
        }

        Driver driver = driverRepository.findById(driverId)
                .orElseThrow(() -> new RuntimeException("Driver not found"));

        vehicleRepository.findAll().stream()
                .filter(v -> v.getDriver() != null && v.getDriver().getId().equals(driverId))
                .findAny()
                .ifPresent(v -> { throw new RuntimeException("Driver already has a vehicle"); });

        vehicle.setDriver(driver);
        return vehicleRepository.save(vehicle);
    }


    @Override
    @Transactional
    public Vehicle unassignDriver(Long vehicleId) {
        Vehicle vehicle = vehicleRepository.findById(vehicleId)
                .orElseThrow(() -> new RuntimeException("Vehicle not found"));

        vehicle.setDriver(null);
        return vehicleRepository.save(vehicle);
    }
}


