package com.niyat.ride.services;

import com.niyat.ride.dtos.AuthResponseDTO;
import com.niyat.ride.dtos.LoginRequestDTO;

public interface AuthService {
    AuthResponseDTO loginWithPassword(LoginRequestDTO request);
}
