package com.niyat.ride.controllers;

import com.niyat.ride.dtos.DriverResponseDTO;
import com.niyat.ride.dtos.DriverSignupDTO;
import com.niyat.ride.dtos.DriverUpdateDTO;
import com.niyat.ride.services.DriverService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URI;

@RestController
@RequestMapping("/api/drivers")
@RequiredArgsConstructor
@Tag(name = "Driver Management", description = "Endpoints for driver operations")
public class DriverController {

    private final DriverService driverService;

    @PostMapping("/signup")
    @Operation(
            summary = "Register a new driver",
            description = "Creates a new driver account with the provided signup details.",
            responses = {
                    @ApiResponse(responseCode = "201", description = "Driver created successfully"),
                    @ApiResponse(responseCode = "400", description = "Validation error"),
                    @ApiResponse(responseCode = "409", description = "Driver already exists"),
                    @ApiResponse(responseCode = "500", description = "Internal server error")
            }
    )
    public ResponseEntity<DriverResponseDTO> signUpDriver(
            @Valid @RequestBody DriverSignupDTO driverSignupDTO) {

        DriverResponseDTO response = driverService.signUpDriver(driverSignupDTO);
        return ResponseEntity.created(URI.create("/api/drivers/" + response.getId()))
                .body(response);
    }

    @PatchMapping("/updateDriver/{driverId}")
    @Operation(summary = "Update driver details")
    public ResponseEntity<DriverResponseDTO> updateDriver(
            @PathVariable Long driverId,
            @Valid @RequestBody DriverUpdateDTO updateDTO) {

        DriverResponseDTO response = driverService.updateDriver(driverId, updateDTO);
        return ResponseEntity.ok(response);
    }
}