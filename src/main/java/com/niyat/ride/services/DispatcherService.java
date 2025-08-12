package com.niyat.ride.services;

import com.niyat.ride.dtos.DispatcherResponseDTO;
import com.niyat.ride.dtos.DispatcherSignupDTO;
import com.niyat.ride.dtos.DispatcherUpdateDTO;

public interface DispatcherService {
    DispatcherResponseDTO signUpDispatcher(DispatcherSignupDTO dispatcherSignupDTO);
    DispatcherResponseDTO updateDispatcher(Long dispatcherId, DispatcherUpdateDTO updateDTO);
}