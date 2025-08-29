package com.niyat.ride.user.services;

import com.niyat.ride.user.dtos.DriverResponseDTO;
import com.niyat.ride.user.dtos.DriverSignupDTO;
import com.niyat.ride.user.dtos.DriverUpdateDTO;

public interface DriverService {
    DriverResponseDTO signUpDriver(DriverSignupDTO driverSignupDTO);
    DriverResponseDTO updateDriver(Long driverId, DriverUpdateDTO updateDTO);
    void checkIfDriverExists(String phoneNumber);
    DriverResponseDTO getDriverByPhoneNumber(String phoneNumber);


}