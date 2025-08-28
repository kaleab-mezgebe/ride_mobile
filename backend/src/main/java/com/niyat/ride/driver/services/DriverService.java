package com.niyat.ride.driver.services;

import com.niyat.ride.driver.dtos.DriverResponseDTO;
import com.niyat.ride.driver.dtos.DriverSignupDTO;
import com.niyat.ride.driver.dtos.DriverUpdateDTO;

public interface DriverService {
    DriverResponseDTO signUpDriver(DriverSignupDTO driverSignupDTO);
    DriverResponseDTO updateDriver(Long driverId, DriverUpdateDTO updateDTO);
    void checkIfDriverExists(String phoneNumber);
    DriverResponseDTO getDriverByPhoneNumber(String phoneNumber);


}