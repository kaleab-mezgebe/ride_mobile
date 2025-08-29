package com.niyat.ride.user.controllers;

import com.niyat.ride.user.dtos.AdminResponseDTO;
import com.niyat.ride.user.services.AdminService;
import com.niyat.ride.user.dtos.AdminSignupDTO;
import com.niyat.ride.user.dtos.AdminUpdateDTO;
import io.swagger.v3.oas.annotations.Operation;
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
    @Operation(summary = "Register a new admin")

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