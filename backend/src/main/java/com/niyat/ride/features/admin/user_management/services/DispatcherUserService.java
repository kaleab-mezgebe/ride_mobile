package com.niyat.ride.features.admin.user_management.services;

import com.niyat.ride.enums.AccountStatus;
import com.niyat.ride.features.admin.user_management.dtos.DispatcherUserResponseDTO;
import org.springframework.data.domain.Page;

import java.time.LocalDateTime;

public interface DispatcherUserService {
    Page<DispatcherUserResponseDTO> getAllDispatchers(Integer page, Integer size, String sortBy, String sortDirection,
                                                    String search, AccountStatus status, 
                                                    LocalDateTime createdAtFrom, LocalDateTime createdAtTo);
    
    DispatcherUserResponseDTO getDispatcherById(Long id);
    
    DispatcherUserResponseDTO updateDispatcherStatus(Long id, AccountStatus status);
}
