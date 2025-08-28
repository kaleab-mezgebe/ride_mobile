package com.niyat.ride.mappers;

import com.niyat.ride.dtos.DispatcherResponseDTO;
import com.niyat.ride.dtos.DispatcherSignupDTO;
import com.niyat.ride.models.Dispatcher;
import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface DispatcherMapper {
    Dispatcher toEntity(DispatcherSignupDTO dto);
    DispatcherResponseDTO toResponseDTO(Dispatcher dispatcher);
}