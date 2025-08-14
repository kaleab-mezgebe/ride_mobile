package com.niyat.ride.controllers;

import com.niyat.ride.dtos.DriverResponseDTO;
import com.niyat.ride.dtos.DriverSignupDTO;
import com.niyat.ride.dtos.DriverUpdateDTO;
import com.niyat.ride.services.DriverService;
import com.niyat.ride.services.OtpService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@RestController
@RequestMapping("/api/drivers")
@RequiredArgsConstructor
@Tag(name = "Driver Management", description = "Endpoints for driver operations")
public class DriverController {

    private final DriverService driverService;
    private final OtpService otpService;


    private final Map<String, DriverSignupDTO> tempSignupStorage = new ConcurrentHashMap<>();

    @PostMapping("/signup/request-otp")
    @Operation(summary = "Request OTP for driver signup")
    public ResponseEntity<String> requestOtp(@Valid @RequestBody DriverSignupDTO driverSignupDTO) {
        driverService.checkIfDriverExists(driverSignupDTO.getPhoneNumber());
        otpService.sendOtp(driverSignupDTO.getPhoneNumber());
        tempSignupStorage.put(driverSignupDTO.getPhoneNumber(), driverSignupDTO);
        return ResponseEntity.ok("OTP sent to " + driverSignupDTO.getPhoneNumber());
    }

    @PostMapping("/signup/verify-otp")
    @Operation(summary = "Verify OTP and complete driver signup")
    public ResponseEntity<DriverResponseDTO> verifyOtp(@RequestParam String phoneNumber,
                                                       @RequestParam String otp) {
        if (!otpService.verifyOtp(phoneNumber, otp)) {
            return ResponseEntity.badRequest().build();
        }

        DriverSignupDTO signupDTO = tempSignupStorage.get(phoneNumber);
        if (signupDTO == null) {
            return ResponseEntity.badRequest().build();
        }

        DriverResponseDTO response = driverService.signUpDriver(signupDTO);
        otpService.clearOtp(phoneNumber);
        tempSignupStorage.remove(phoneNumber);

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
