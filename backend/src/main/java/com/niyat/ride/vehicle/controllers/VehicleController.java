package com.niyat.ride.vehicle.controllers;


import com.niyat.ride.vehicle.services.VehicleService;
import com.niyat.ride.vehicle.models.Vehicle;
import io.swagger.v3.oas.annotations.parameters.RequestBody;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/vehicles")
@RequiredArgsConstructor
public class VehicleController {

    private final VehicleService vehicleService;

    @PostMapping("/register")
    public ResponseEntity<Vehicle> registerVehicle(@RequestBody Vehicle vehicle) {
        return ResponseEntity.ok(vehicleService.createVehicle(vehicle));
    }

    @PostMapping("/{vehicleId}/assign/{driverId}")
    public ResponseEntity<Vehicle> assignDriver(@PathVariable Long vehicleId,
                                                @PathVariable Long driverId) {
        return ResponseEntity.ok(vehicleService.assignDriverToVehicle(vehicleId, driverId));
    }

    @PostMapping("/{vehicleId}/unassign")
    public ResponseEntity<Vehicle> unassignDriver(@PathVariable Long vehicleId) {
        return ResponseEntity.ok(vehicleService.unassignDriver(vehicleId));
    }
}


