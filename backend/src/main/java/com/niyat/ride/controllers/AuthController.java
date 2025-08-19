package com.niyat.ride.controllers;

import com.niyat.ride.dtos.AuthResponseDTO;
import com.niyat.ride.dtos.LoginRequestDTO;
import com.niyat.ride.services.AuthService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    @PostMapping("/login")
    public ResponseEntity<AuthResponseDTO> login(@RequestBody LoginRequestDTO request) {
        return ResponseEntity.ok(authService.loginWithPassword(request));
    }

}
