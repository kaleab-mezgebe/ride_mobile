package com.niyat.ride.customer.mappers;

import com.niyat.ride.customer.dtos.CustomerResponseDTO;
import com.niyat.ride.customer.dtos.CustomerSignupDTO;
import com.niyat.ride.customer.models.Customer;
import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;


@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface CustomerMapper {

    Customer toEntity(CustomerSignupDTO dto);
    CustomerResponseDTO toResponseDTO(Customer customer);
}