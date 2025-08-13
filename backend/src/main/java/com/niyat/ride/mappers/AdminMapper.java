package com.niyat.ride.mappers;

import com.niyat.ride.dtos.AdminResponseDTO;
import com.niyat.ride.dtos.AdminSignupDTO;
import com.niyat.ride.models.Admin;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface AdminMapper {
    Admin toEntity(AdminSignupDTO dto);
    AdminResponseDTO toResponseDTO(Admin admin);
}