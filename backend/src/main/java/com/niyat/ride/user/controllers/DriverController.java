package com.niyat.ride.user.controllers;

import com.niyat.ride.user.dtos.DriverResponseDTO;
import com.niyat.ride.user.services.DriverService;
import com.niyat.ride.user.dtos.DriverSignupDTO;
import com.niyat.ride.user.dtos.DriverUpdateDTO;
import com.niyat.ride.otp.services.OtpService;
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

    // Temporary storage for signup data before OTP verification
    private final Map<String, DriverSignupDTO> tempSignupStorage = new ConcurrentHashMap<>();


    @PostMapping("/signup/request-otp")
    @Operation(summary = "Request OTP for driver signup")
    public ResponseEntity<String> requestSignupOtp(@Valid @RequestBody DriverSignupDTO driverSignupDTO) {
        driverService.checkIfDriverExists(driverSignupDTO.getPhoneNumber());
        otpService.sendOtp(driverSignupDTO.getPhoneNumber());
        tempSignupStorage.put(driverSignupDTO.getPhoneNumber(), driverSignupDTO);
        return ResponseEntity.ok("OTP sent to " + driverSignupDTO.getPhoneNumber());
    }

    @PostMapping("/signup/verify-otp")
    @Operation(summary = "Verify OTP and complete driver signup")
    public ResponseEntity<DriverResponseDTO> verifySignupOtp(@RequestParam String phoneNumber,
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


    @PostMapping("/login/request-otp")
    @Operation(summary = "Request OTP for driver login")
    public ResponseEntity<String> requestLoginOtp(@RequestParam String phoneNumber) {
        driverService.getDriverByPhoneNumber(phoneNumber);
        otpService.sendOtp(phoneNumber);
        return ResponseEntity.ok("OTP sent to " + phoneNumber);
    }

    @PostMapping("/login/verify-otp")
    @Operation(summary = "Verify OTP and log in driver")
    public ResponseEntity<DriverResponseDTO> verifyLoginOtp(@RequestParam String phoneNumber,
                                                            @RequestParam String otp) {
        if (!otpService.verifyOtp(phoneNumber, otp)) {
            return ResponseEntity.badRequest().build();
        }

        DriverResponseDTO driver = driverService.getDriverByPhoneNumber(phoneNumber);
        otpService.clearOtp(phoneNumber);
        return ResponseEntity.ok(driver);
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
