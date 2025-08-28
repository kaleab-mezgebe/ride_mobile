package com.niyat.ride.admin.mappers;

import com.niyat.ride.admin.dtos.AdminResponseDTO;
import com.niyat.ride.admin.dtos.AdminSignupDTO;
import com.niyat.ride.admin.models.Admin;
import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface AdminMapper {
    Admin toEntity(AdminSignupDTO dto);
    AdminResponseDTO toResponseDTO(Admin admin);
}