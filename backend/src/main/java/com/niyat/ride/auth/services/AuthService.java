package com.niyat.ride.auth.services;

import com.niyat.ride.auth.dtos.AuthResponseDTO;
import com.niyat.ride.auth.dtos.LoginRequestDTO;

public interface AuthService {
    AuthResponseDTO loginWithPassword(LoginRequestDTO request);
}
