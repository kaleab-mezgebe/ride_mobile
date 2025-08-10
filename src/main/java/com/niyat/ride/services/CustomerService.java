package com.niyat.ride.services;

import com.niyat.ride.dtos.CustomerResponseDTO;
import com.niyat.ride.dtos.CustomerSignupDTO;
import com.niyat.ride.dtos.CustomerUpdateDTO;

public interface CustomerService {
    CustomerResponseDTO signUpCustomer(CustomerSignupDTO customerSignupDTO);
    CustomerResponseDTO updateCustomer(Long customerId, CustomerUpdateDTO updateDTO);


}
