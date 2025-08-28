package com.niyat.ride.dispatcher.controllers;

import com.niyat.ride.dispatcher.dtos.DispatcherResponseDTO;
import com.niyat.ride.dispatcher.services.DispatcherService;
import com.niyat.ride.dispatcher.dtos.DispatcherSignupDTO;
import com.niyat.ride.dispatcher.dtos.DispatcherUpdateDTO;
import io.swagger.v3.oas.annotations.Operation;
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
    @Operation(summary = "Register a new dispatcher")
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