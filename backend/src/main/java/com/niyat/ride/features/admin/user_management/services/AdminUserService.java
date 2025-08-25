package com.niyat.ride.features.admin.user_management.services;

import com.niyat.ride.enums.AccountStatus;
import com.niyat.ride.features.admin.user_management.dtos.AdminUserResponseDTO;
import org.springframework.data.domain.Page;

import java.time.LocalDateTime;

public interface AdminUserService {
    Page<AdminUserResponseDTO> getAllAdmins(Integer page, Integer size, String sortBy, String sortDirection,
                                          String search, AccountStatus status, 
                                          LocalDateTime createdAtFrom, LocalDateTime createdAtTo);
    
    AdminUserResponseDTO getAdminById(Long id);
    
    AdminUserResponseDTO updateAdminStatus(Long id, AccountStatus status);
}
