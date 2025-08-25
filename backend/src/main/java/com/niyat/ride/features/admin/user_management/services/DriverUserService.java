package com.niyat.ride.features.admin.user_management.services;

import com.niyat.ride.enums.AccountStatus;
import com.niyat.ride.features.admin.user_management.dtos.DriverUserResponseDTO;
import org.springframework.data.domain.Page;

import java.time.LocalDateTime;

public interface DriverUserService {
    Page<DriverUserResponseDTO> getAllDrivers(Integer page, Integer size, String sortBy, String sortDirection,
                                            String search, AccountStatus status, 
                                            LocalDateTime createdAtFrom, LocalDateTime createdAtTo);
    
    DriverUserResponseDTO getDriverById(Long id);
    
    DriverUserResponseDTO updateDriverStatus(Long id, AccountStatus status);
}
