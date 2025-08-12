package com.niyat.ride.controllers;

import com.niyat.ride.dtos.DispatcherResponseDTO;
import com.niyat.ride.dtos.DispatcherSignupDTO;
import com.niyat.ride.dtos.DispatcherUpdateDTO;
import com.niyat.ride.services.DispatcherService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URI;

@RestController
@RequestMapping("/api/dispatchers")
@RequiredArgsConstructor
@Tag(name = "Dispatcher Management", description = "Endpoints for dispatcher operations")
public class DispatcherController {

    private final DispatcherService dispatcherService;

    @PostMapping("/signup")
    @Operation(
            summary = "Register a new dispatcher",
            description = "Creates a new dispatcher account with the provided signup details.",
            responses = {
                    @ApiResponse(responseCode = "201", description = "Dispatcher created successfully"),
                    @ApiResponse(responseCode = "400", description = "Validation error"),
                    @ApiResponse(responseCode = "409", description = "Dispatcher already exists"),
                    @ApiResponse(responseCode = "500", description = "Internal server error")
            }
    )
    public ResponseEntity<DispatcherResponseDTO> signUpDispatcher(
            @Valid @RequestBody DispatcherSignupDTO dispatcherSignupDTO) {

        DispatcherResponseDTO response = dispatcherService.signUpDispatcher(dispatcherSignupDTO);
        return ResponseEntity.created(URI.create("/api/dispatchers/" + response.getId()))
                .body(response);
    }

    @PatchMapping("/updateDispatcher/{dispatcherId}")
    @Operation(summary = "Update dispatcher details")
    public ResponseEntity<DispatcherResponseDTO> updateDispatcher(
            @PathVariable Long dispatcherId,
            @Valid @RequestBody DispatcherUpdateDTO updateDTO) {

        DispatcherResponseDTO response = dispatcherService.updateDispatcher(dispatcherId, updateDTO);
        return ResponseEntity.ok(response);
    }
}