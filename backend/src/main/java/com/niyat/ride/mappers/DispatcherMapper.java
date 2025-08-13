package com.niyat.ride.mappers;

import com.niyat.ride.dtos.DispatcherResponseDTO;
import com.niyat.ride.dtos.DispatcherSignupDTO;
import com.niyat.ride.models.Dispatcher;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface DispatcherMapper {
    Dispatcher toEntity(DispatcherSignupDTO dto);
    DispatcherResponseDTO toResponseDTO(Dispatcher dispatcher);
}