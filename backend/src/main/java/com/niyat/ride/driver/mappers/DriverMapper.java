package com.niyat.ride.driver.mappers;

import com.niyat.ride.driver.dtos.DriverResponseDTO;
import com.niyat.ride.driver.dtos.DriverSignupDTO;
import com.niyat.ride.driver.models.Driver;
import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface DriverMapper {
    Driver toEntity(DriverSignupDTO dto);
    DriverResponseDTO toResponseDTO(Driver driver);
}