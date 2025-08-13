package com.niyat.ride.controllers;

import com.niyat.ride.dtos.AdminResponseDTO;
import com.niyat.ride.dtos.AdminSignupDTO;
import com.niyat.ride.dtos.AdminUpdateDTO;
import com.niyat.ride.services.AdminService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URI;

@RestController
@RequestMapping("/api/admins")
@RequiredArgsConstructor
@Tag(name = "Admin Management", description = "Endpoints for admin operations")
public class AdminController {

    private final AdminService adminService;

    @PostMapping("/signup")
    @Operation(
            summary = "Register a new admin",
            description = "Creates a new admin account with the provided signup details.",
            responses = {
                    @ApiResponse(responseCode = "201", description = "Admin created successfully"),
                    @ApiResponse(responseCode = "400", description = "Validation error"),
                    @ApiResponse(responseCode = "409", description = "Admin already exists"),
                    @ApiResponse(responseCode = "500", description = "Internal server error")
            }
    )
    public ResponseEntity<AdminResponseDTO> signUpAdmin(
            @Valid @RequestBody AdminSignupDTO adminSignupDTO) {

        AdminResponseDTO response = adminService.signUpAdmin(adminSignupDTO);
        return ResponseEntity.created(URI.create("/api/admins/" + response.getId()))
                .body(response);
    }

    @PatchMapping("/updateAdmin/{adminId}")
    @Operation(summary = "Update admin details")
    public ResponseEntity<AdminResponseDTO> updateAdmin(
            @PathVariable Long adminId,
            @Valid @RequestBody AdminUpdateDTO updateDTO) {

        AdminResponseDTO response = adminService.updateAdmin(adminId, updateDTO);
        return ResponseEntity.ok(response);
    }
}