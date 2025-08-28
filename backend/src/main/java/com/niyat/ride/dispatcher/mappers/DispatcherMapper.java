package com.niyat.ride.dispatcher.mappers;

import com.niyat.ride.dispatcher.dtos.DispatcherResponseDTO;
import com.niyat.ride.dispatcher.dtos.DispatcherSignupDTO;
import com.niyat.ride.dispatcher.models.Dispatcher;
import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface DispatcherMapper {
    Dispatcher toEntity(DispatcherSignupDTO dto);
    DispatcherResponseDTO toResponseDTO(Dispatcher dispatcher);
}