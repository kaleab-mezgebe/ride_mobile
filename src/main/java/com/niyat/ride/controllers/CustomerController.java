package com.niyat.ride.controllers;

import com.niyat.ride.dtos.CustomerResponseDTO;
import com.niyat.ride.dtos.CustomerSignupDTO;
import com.niyat.ride.dtos.CustomerUpdateDTO;
import com.niyat.ride.services.CustomerService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URI;


@RestController
@RequestMapping("/api/customers")
@RequiredArgsConstructor
@Tag(name = "Customer Management", description = "Endpoints for customer operations")
public class CustomerController {

    private final CustomerService customerService;

    @PostMapping("/signup")
    @Operation(
            summary = "Register a new customer",
            description = "Creates a new customer account with the provided signup details.",
            responses = {
                    @ApiResponse(responseCode = "201", description = "Customer created successfully"),
                    @ApiResponse(responseCode = "400", description = "Validation error"),
                    @ApiResponse(responseCode = "409", description = "Customer already exists"),
                    @ApiResponse(responseCode = "500", description = "Internal server error")
            }
    )
    public ResponseEntity<CustomerResponseDTO> signUpCustomer(
            @Valid @RequestBody CustomerSignupDTO customerSignupDTO) {

        CustomerResponseDTO response = customerService.signUpCustomer(customerSignupDTO);
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