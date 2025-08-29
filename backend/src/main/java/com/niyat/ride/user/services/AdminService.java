package com.niyat.ride.user.services;

import com.niyat.ride.user.dtos.AdminResponseDTO;
import com.niyat.ride.user.dtos.AdminSignupDTO;
import com.niyat.ride.user.dtos.AdminUpdateDTO;

public interface AdminService {
    AdminResponseDTO signUpAdmin(AdminSignupDTO adminSignupDTO);
    AdminResponseDTO updateAdmin(Long adminId, AdminUpdateDTO updateDTO);

}