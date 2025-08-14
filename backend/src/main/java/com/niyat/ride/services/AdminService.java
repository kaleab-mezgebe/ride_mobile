package com.niyat.ride.services;

import com.niyat.ride.dtos.AdminResponseDTO;
import com.niyat.ride.dtos.AdminSignupDTO;
import com.niyat.ride.dtos.AdminUpdateDTO;

public interface AdminService {
    AdminResponseDTO signUpAdmin(AdminSignupDTO adminSignupDTO);
    AdminResponseDTO updateAdmin(Long adminId, AdminUpdateDTO updateDTO);

}