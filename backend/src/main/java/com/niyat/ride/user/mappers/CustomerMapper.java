package com.niyat.ride.user.mappers;

import com.niyat.ride.user.dtos.CustomerResponseDTO;
import com.niyat.ride.user.dtos.CustomerSignupDTO;
import com.niyat.ride.user.models.Customer;
import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;


@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface CustomerMapper {

    Customer toEntity(CustomerSignupDTO dto);
    CustomerResponseDTO toResponseDTO(Customer customer);
}