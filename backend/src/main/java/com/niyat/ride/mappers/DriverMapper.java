package com.niyat.ride.mappers;

import com.niyat.ride.dtos.DriverResponseDTO;
import com.niyat.ride.dtos.DriverSignupDTO;
import com.niyat.ride.models.Driver;
import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface DriverMapper {
    Driver toEntity(DriverSignupDTO dto);
    DriverResponseDTO toResponseDTO(Driver driver);
}