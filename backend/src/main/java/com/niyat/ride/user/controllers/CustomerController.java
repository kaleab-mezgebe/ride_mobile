package com.niyat.ride.user.controllers;

import com.niyat.ride.user.dtos.CustomerResponseDTO;
import com.niyat.ride.user.services.CustomerService;
import com.niyat.ride.user.dtos.CustomerSignupDTO;
import com.niyat.ride.user.dtos.CustomerUpdateDTO;
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
@RequestMapping("/api/customers")
@RequiredArgsConstructor
@Tag(name = "Customer Management", description = "Endpoints for passenger operations")
public class CustomerController {

    private final CustomerService customerService;
    private final OtpService otpService;

    // Temporary storage for pending signups
    private final Map<String, CustomerSignupDTO> tempSignupStorage = new ConcurrentHashMap<>();

    @PostMapping("/signup/request-otp")
    @Operation(summary = "Request OTP for customer signup")
    public ResponseEntity<String> requestSignupOtp(@Valid @RequestBody CustomerSignupDTO signupDTO) {
        customerService.checkIfCustomerExists(signupDTO.getPhoneNumber());
        otpService.sendOtp(signupDTO.getPhoneNumber());
        tempSignupStorage.put(signupDTO.getPhoneNumber(), signupDTO);
        return ResponseEntity.ok("OTP sent to " + signupDTO.getPhoneNumber());
    }

    @PostMapping("/signup/verify-otp")
    @Operation(summary = "Verify OTP and complete customer signup")
    public ResponseEntity<CustomerResponseDTO> verifySignupOtp(
            @RequestParam String phoneNumber,
            @RequestParam String otp) {

        if (!otpService.verifyOtp(phoneNumber, otp)) {
            return ResponseEntity.badRequest().body(null);
        }

        CustomerSignupDTO signupDTO = tempSignupStorage.get(phoneNumber);
        if (signupDTO == null) {
            return ResponseEntity.badRequest().body(null);
        }

        CustomerResponseDTO response = customerService.signUpCustomer(signupDTO);
        otpService.clearOtp(phoneNumber);
        tempSignupStorage.remove(phoneNumber);

        return ResponseEntity.created(URI.create("/api/customers/" + response.getId()))
                .body(response);
    }


    @PostMapping("/login/request-otp")
    @Operation(summary = "Request OTP for customer login")
    public ResponseEntity<String> requestLoginOtp(@RequestParam String phoneNumber) {
        customerService.getCustomerByPhoneNumber(phoneNumber);
        otpService.sendOtp(phoneNumber);
        return ResponseEntity.ok("OTP sent to " + phoneNumber);
    }

    @PostMapping("/login/verify-otp")
    @Operation(summary = "Verify OTP and log in customer")
    public ResponseEntity<CustomerResponseDTO> verifyLoginOtp(
            @RequestParam String phoneNumber,
            @RequestParam String otp) {

        if (!otpService.verifyOtp(phoneNumber, otp)) {
            return ResponseEntity.badRequest().body(null);
        }

        CustomerResponseDTO response = customerService.getCustomerByPhoneNumber(phoneNumber);
        otpService.clearOtp(phoneNumber);

        return ResponseEntity.ok(response);
    }

    @PatchMapping("/updateCustomer/{customerId}")
    @Operation(summary = "Update customer details")
    public ResponseEntity<CustomerResponseDTO> updateCustomer(
            @PathVariable Long customerId,
            @Valid @RequestBody CustomerUpdateDTO updateDTO) {

        CustomerResponseDTO response = customerService.updateCustomer(customerId, updateDTO);
        return ResponseEntity.ok(response);
    }
}
