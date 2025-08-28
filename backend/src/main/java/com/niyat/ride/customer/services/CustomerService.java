package com.niyat.ride.customer.services;

import com.niyat.ride.customer.dtos.CustomerResponseDTO;
import com.niyat.ride.customer.dtos.CustomerSignupDTO;
import com.niyat.ride.customer.dtos.CustomerUpdateDTO;

public interface CustomerService {
    CustomerResponseDTO signUpCustomer(CustomerSignupDTO customerSignupDTO);
    CustomerResponseDTO updateCustomer(Long customerId, CustomerUpdateDTO updateDTO);
    void checkIfCustomerExists(String phoneNumber);
    CustomerResponseDTO getCustomerByPhoneNumber(String phoneNumber);


}
