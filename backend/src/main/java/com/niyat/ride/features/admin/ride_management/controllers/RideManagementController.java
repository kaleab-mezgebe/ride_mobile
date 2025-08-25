package com.niyat.ride.features.admin.ride_management.controllers;

import com.niyat.ride.enums.RideStatus;
import com.niyat.ride.features.admin.ride_management.dtos.RideResponseDTO;
import com.niyat.ride.features.admin.ride_management.dtos.RideSummaryDTO;
import com.niyat.ride.features.admin.ride_management.services.RideManagementService;
import com.niyat.ride.shared.utils.PaginationUtil;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Map;

@RestController
@RequestMapping("/api/admin/rides")
@RequiredArgsConstructor
@Tag(name = "Ride Management", description = "Admin endpoints for managing rides and analytics")
public class RideManagementController {

    private final RideManagementService rideManagementService;

    @GetMapping
    @Operation(summary = "Get all rides with advanced filtering")
    public ResponseEntity<Map<String, Object>> getAllRides(
            @RequestParam(defaultValue = "0") Integer page,
            @RequestParam(defaultValue = "20") Integer size,
            @RequestParam(defaultValue = "requestedAt") String sortBy,
            @RequestParam(defaultValue = "desc") String sortDirection,
            @RequestParam(required = false) RideStatus status,
            @RequestParam(required = false) Long driverId,
            @RequestParam(required = false) Long customerId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime fromDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime toDate,
            @RequestParam(required = false) BigDecimal minAmount,
            @RequestParam(required = false) BigDecimal maxAmount) {

        Page<RideResponseDTO> ridesPage = rideManagementService.getAllRides(
                page, size, sortBy, sortDirection, status, driverId, customerId, fromDate, toDate, minAmount, maxAmount);

        return ResponseEntity.ok(PaginationUtil.createPageResponse(ridesPage));
    }

    @GetMapping("/requests")
    @Operation(summary = "Get all ride requests with filtering")
    public ResponseEntity<Map<String, Object>> getAllRideRequests(
            @RequestParam(defaultValue = "0") Integer page,
            @RequestParam(defaultValue = "20") Integer size,
            @RequestParam(defaultValue = "requestedAt") String sortBy,
            @RequestParam(defaultValue = "desc") String sortDirection,
            @RequestParam(required = false) RideStatus status,
            @RequestParam(required = false) Long driverId,
            @RequestParam(required = false) Long customerId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime fromDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime toDate,
            @RequestParam(required = false) BigDecimal minAmount,
            @RequestParam(required = false) BigDecimal maxAmount) {

        Page<RideResponseDTO> rideRequestsPage = rideManagementService.getAllRideRequests(
                page, size, sortBy, sortDirection, status, driverId, customerId, fromDate, toDate, minAmount, maxAmount);

        return ResponseEntity.ok(PaginationUtil.createPageResponse(rideRequestsPage));
    }

    @GetMapping("/summary")
    @Operation(summary = "Get analytics summary of rides")
    public ResponseEntity<RideSummaryDTO> getRidesSummary() {
        RideSummaryDTO summary = rideManagementService.getRidesSummary();
        return ResponseEntity.ok(summary);
    }

    @GetMapping("/{id}")
    @Operation(summary = "Get specific ride details")
    public ResponseEntity<RideResponseDTO> getRideById(@PathVariable Long id) {
        RideResponseDTO ride = rideManagementService.getRideById(id);
        return ResponseEntity.ok(ride);
    }
}
