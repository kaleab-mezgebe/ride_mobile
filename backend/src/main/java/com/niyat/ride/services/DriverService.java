package com.niyat.ride.services;

import com.niyat.ride.dtos.DriverResponseDTO;
import com.niyat.ride.dtos.DriverSignupDTO;
import com.niyat.ride.dtos.DriverUpdateDTO;

public interface DriverService {
    DriverResponseDTO signUpDriver(DriverSignupDTO driverSignupDTO);
    DriverResponseDTO updateDriver(Long driverId, DriverUpdateDTO updateDTO);
    void checkIfDriverExists(String phoneNumber);
}