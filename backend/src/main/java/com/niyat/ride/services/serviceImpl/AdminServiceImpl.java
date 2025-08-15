package com.niyat.ride.services.serviceImpl;

import com.niyat.ride.dtos.AdminResponseDTO;
import com.niyat.ride.dtos.AdminSignupDTO;
import com.niyat.ride.dtos.AdminUpdateDTO;
import com.niyat.ride.enums.Role;
import com.niyat.ride.mappers.AdminMapper;
import com.niyat.ride.models.Admin;
import com.niyat.ride.repositories.AdminRepository;
import com.niyat.ride.services.AdminService;
import com.niyat.ride.utils.Helpers;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class AdminServiceImpl implements AdminService {

    private final AdminRepository adminRepository;
    private final AdminMapper adminMapper;

    @Override
    @Transactional
    public AdminResponseDTO signUpAdmin(AdminSignupDTO adminSignupDTO) {
        adminRepository.findByPhoneNumber(adminSignupDTO.getPhoneNumber())
                .ifPresent(a -> {
                    throw new RuntimeException(
                            "Admin with phone number " + a.getPhoneNumber() + " already exists");
                });

        Admin admin = adminMapper.toEntity(adminSignupDTO);
        admin.setRole(Role.Admin);
        admin.setPhoneNumber(adminSignupDTO.getPhoneNumber());
        admin.setCreatedAt(LocalDateTime.now());
        admin.setUpdatedAt(LocalDateTime.now());
        Admin savedAdmin = adminRepository.save(admin);

        return adminMapper.toResponseDTO(savedAdmin);
    }

    @Override
    @Transactional
    public AdminResponseDTO updateAdmin(Long adminId, AdminUpdateDTO updateDTO) {
        Admin admin = adminRepository.findById(adminId)
                .orElseThrow(() -> new RuntimeException("Admin not found with id: " + adminId));

        admin.setName(updateDTO.getFirstName());
        admin.setEmail(updateDTO.getEmail());
        admin.setUpdatedAt(LocalDateTime.now());

        Admin updatedAdmin = adminRepository.save(admin);
        return adminMapper.toResponseDTO(updatedAdmin);
    }
}