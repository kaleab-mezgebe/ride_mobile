package com.niyat.ride.mappers;

import com.niyat.ride.dtos.DriverResponseDTO;
import com.niyat.ride.dtos.DriverSignupDTO;
import com.niyat.ride.models.Driver;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface DriverMapper {
    Driver toEntity(DriverSignupDTO dto);
    DriverResponseDTO toResponseDTO(Driver driver);
}