package com.niyat.ride.admin.services;

import com.niyat.ride.admin.dtos.AdminResponseDTO;
import com.niyat.ride.admin.dtos.AdminSignupDTO;
import com.niyat.ride.admin.dtos.AdminUpdateDTO;

public interface AdminService {
    AdminResponseDTO signUpAdmin(AdminSignupDTO adminSignupDTO);
    AdminResponseDTO updateAdmin(Long adminId, AdminUpdateDTO updateDTO);

}