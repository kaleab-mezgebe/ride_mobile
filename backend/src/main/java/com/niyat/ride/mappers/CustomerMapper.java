package com.niyat.ride.mappers;

import com.niyat.ride.dtos.CustomerResponseDTO;
import com.niyat.ride.dtos.CustomerSignupDTO;
import com.niyat.ride.models.Customer;
import org.mapstruct.Mapper;


@Mapper(componentModel = "spring")
public interface CustomerMapper {

    Customer toEntity(CustomerSignupDTO dto);
    CustomerResponseDTO toResponseDTO(Customer customer);
}