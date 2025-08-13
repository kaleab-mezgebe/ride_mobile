package com.niyat.ride.services.serviceImpl;

import com.niyat.ride.dtos.DriverResponseDTO;
import com.niyat.ride.dtos.DriverSignupDTO;
import com.niyat.ride.dtos.DriverUpdateDTO;
import com.niyat.ride.enums.AccountStatus;
import com.niyat.ride.enums.Role;
import com.niyat.ride.mappers.DriverMapper;
import com.niyat.ride.models.Driver;
import com.niyat.ride.repositories.DriverRepository;
import com.niyat.ride.services.DriverService;
import com.niyat.ride.utils.Helpers;
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
    @Transactional
    public DriverResponseDTO signUpDriver(DriverSignupDTO driverSignupDTO) {
        driverRepository.findByPhoneNumber(driverSignupDTO.getPhoneNumber())
                .ifPresent(d -> {
                    throw new RuntimeException(
                            "Driver with phone number " + d.getPhoneNumber() + " already exists");
                });

        driverRepository.findByLicenseNumber(driverSignupDTO.getLicenseNumber())
                .ifPresent(d -> {
                    throw new RuntimeException(
                            "Driver with license number " + d.getLicenseNumber() + " already exists");
                });

        Driver driver = driverMapper.toEntity(driverSignupDTO);
        driver.setPassword(Helpers.encryptPassword(driverSignupDTO.getPassword()));
        driver.setRole(Role.DRIVER);
        driver.setPhoneNumber(driverSignupDTO.getPhoneNumber());
        driver.setStatus(AccountStatus.ACTIVE);
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

        driver.setFirstName(updateDTO.getFirstName());
        driver.setLastName(updateDTO.getLastName());
        driver.setEmail(updateDTO.getEmail());
        if (updateDTO.getVehicleType() != null) {
            driver.setVehicleType(updateDTO.getVehicleType());
        }
        if (updateDTO.getVehiclePlateNumber() != null) {
            driver.setVehiclePlateNumber(updateDTO.getVehiclePlateNumber());
        }
        driver.setUpdatedAt(LocalDateTime.now());

        Driver updatedDriver = driverRepository.save(driver);
        return driverMapper.toResponseDTO(updatedDriver);
    }
}