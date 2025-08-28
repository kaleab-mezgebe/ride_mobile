package com.niyat.ride.dispatcher.services;

import com.niyat.ride.dispatcher.dtos.DispatcherResponseDTO;
import com.niyat.ride.dispatcher.dtos.DispatcherSignupDTO;
import com.niyat.ride.dispatcher.dtos.DispatcherUpdateDTO;

public interface DispatcherService {
    DispatcherResponseDTO signUpDispatcher(DispatcherSignupDTO dispatcherSignupDTO);
    DispatcherResponseDTO updateDispatcher(Long dispatcherId, DispatcherUpdateDTO updateDTO);
}