package com.niyat.ride.driver.services;

import com.niyat.ride.driver.dtos.DriverResponseDTO;
import com.niyat.ride.driver.dtos.DriverSignupDTO;
import com.niyat.ride.driver.dtos.DriverUpdateDTO;
import com.niyat.ride.driver.mappers.DriverMapper;
import com.niyat.ride.driver.models.Driver;
import com.niyat.ride.driver.repositories.DriverRepository;
import com.niyat.ride.enums.AccountStatus;
import com.niyat.ride.enums.Role;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class DriverServiceImpl implements DriverService {

    private final DriverRepository driverRepository;
    private final DriverMapper driverMapper;

    @Override
    public void checkIfDriverExists(String phoneNumber) {
          driverRepository.findByPhoneNumber(phoneNumber)
                .ifPresent(d -> {
                    throw new RuntimeException(
                            "Driver with phone number " + phoneNumber + " already exists"
                    );
                });
    }

    @Override
    public DriverResponseDTO getDriverByPhoneNumber(String phoneNumber) {
        Driver driver = driverRepository.findByPhoneNumber(phoneNumber)
                .orElseThrow(() -> new RuntimeException("Driver not found with phone: " + phoneNumber));
        return driverMapper.toResponseDTO(driver);
    }


    @Override
    @Transactional
    public DriverResponseDTO signUpDriver(DriverSignupDTO driverSignupDTO) {
        checkIfDriverExists(driverSignupDTO.getPhoneNumber());

        driverRepository.findByLicenseNumber(driverSignupDTO.getLicenseNumber())
                .ifPresent(d -> {
                    throw new RuntimeException(
                            "Driver with license number " + d.getLicenseNumber() + " already exists");
                });

        Driver driver = driverMapper.toEntity(driverSignupDTO);
        driver.setFirstName(driverSignupDTO.getFirstName());
        driver.setLastName(driverSignupDTO.getLastName());
        driver.setRole(Role.DRIVER);
        driver.setPhoneNumber(driverSignupDTO.getPhoneNumber());
        driver.setStatus(AccountStatus.ACTIVE);
        driver.setIsVerified(true);
        driver.setVerifiedAt(LocalDateTime.now());
        driver.setCreatedAt(LocalDateTime.now());
        driver.setUpdatedAt(LocalDateTime.now());
        Driver savedDriver = driverRepository.save(driver);

        return driverMapper.toResponseDTO(savedDriver);
    }

    @Override
    @Transactional
    public DriverResponseDTO updateDriver(Long driverId, DriverUpdateDTO updateDTO) {
        Driver driver = driverRepository.findById(driverId)
                .orElseThrow(() -> new RuntimeException("Driver not found with id: " + driverId));

        driver.setEmail(updateDTO.getEmail());
        driver.setUpdatedAt(LocalDateTime.now());

        Driver updatedDriver = driverRepository.save(driver);
        return driverMapper.toResponseDTO(updatedDriver);
    }

}