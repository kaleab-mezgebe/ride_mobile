package com.niyat.ride.controllers;

import com.niyat.ride.dtos.CustomerResponseDTO;
import com.niyat.ride.dtos.CustomerSignupDTO;
import com.niyat.ride.dtos.CustomerUpdateDTO;
import com.niyat.ride.services.CustomerService;
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
@Tag(name = "Customer Management", description = "Endpoints for customer operations")
public class CustomerController {

    private final CustomerService customerService;
    private final OtpService otpService;

    // Temporary storage for pending signups
    private final Map<String, CustomerSignupDTO> tempSignupStorage = new ConcurrentHashMap<>();

    @PostMapping("/signup/request-otp")
    @Operation(summary = "Request OTP for customer signup")
    public ResponseEntity<String> requestOtp(@Valid @RequestBody CustomerSignupDTO customerSignupDTO) {
        customerService.checkIfCustomerExists(customerSignupDTO.getPhoneNumber());
        otpService.sendOtp(customerSignupDTO.getPhoneNumber());
        tempSignupStorage.put(customerSignupDTO.getPhoneNumber(), customerSignupDTO);
        return ResponseEntity.ok("OTP sent to " + customerSignupDTO.getPhoneNumber());
    }

    @PostMapping("/signup/verify-otp")
    @Operation(summary = "Verify OTP and complete customer signup")
    public ResponseEntity<CustomerResponseDTO> verifyOtp(@RequestParam String phoneNumber,
                                                         @RequestParam String otp) {
        if (!otpService.verifyOtp(phoneNumber, otp)) {
            return ResponseEntity.badRequest().build();
        }

        CustomerSignupDTO signupDTO = tempSignupStorage.get(phoneNumber);
        if (signupDTO == null) {
            return ResponseEntity.badRequest().build();
        }

        CustomerResponseDTO response = customerService.signUpCustomer(signupDTO);
        otpService.clearOtp(phoneNumber);
        tempSignupStorage.remove(phoneNumber);

        return ResponseEntity.created(URI.create("/api/customers/" + response.getId()))
                .body(response);
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
