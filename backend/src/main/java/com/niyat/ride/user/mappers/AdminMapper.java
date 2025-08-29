package com.niyat.ride.user.mappers;

import com.niyat.ride.user.dtos.AdminResponseDTO;
import com.niyat.ride.user.dtos.AdminSignupDTO;
import com.niyat.ride.user.models.Admin;
import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface AdminMapper {
    Admin toEntity(AdminSignupDTO dto);
    AdminResponseDTO toResponseDTO(Admin admin);
}