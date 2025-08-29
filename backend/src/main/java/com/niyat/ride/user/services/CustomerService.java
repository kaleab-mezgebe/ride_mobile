package com.niyat.ride.user.services;

import com.niyat.ride.user.dtos.CustomerResponseDTO;
import com.niyat.ride.user.dtos.CustomerSignupDTO;
import com.niyat.ride.user.dtos.CustomerUpdateDTO;

public interface CustomerService {
    CustomerResponseDTO signUpCustomer(CustomerSignupDTO customerSignupDTO);
    CustomerResponseDTO updateCustomer(Long customerId, CustomerUpdateDTO updateDTO);
    void checkIfCustomerExists(String phoneNumber);
    CustomerResponseDTO getCustomerByPhoneNumber(String phoneNumber);


}
