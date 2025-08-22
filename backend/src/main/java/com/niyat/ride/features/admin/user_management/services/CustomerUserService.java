package com.niyat.ride.features.admin.user_management.services;

import com.niyat.ride.enums.AccountStatus;
import com.niyat.ride.features.admin.user_management.dtos.CustomerUserResponseDTO;
import org.springframework.data.domain.Page;

import java.time.LocalDateTime;

public interface CustomerUserService {
    Page<CustomerUserResponseDTO> getAllCustomers(Integer page, Integer size, String sortBy, String sortDirection,
                                                String search, AccountStatus status, 
                                                LocalDateTime createdAtFrom, LocalDateTime createdAtTo);
    
    CustomerUserResponseDTO getCustomerById(Long id);
    
    CustomerUserResponseDTO updateCustomerStatus(Long id, AccountStatus status);
}
