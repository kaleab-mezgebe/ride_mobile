package com.niyat.ride.user.services;

import com.niyat.ride.user.dtos.CustomerResponseDTO;
import com.niyat.ride.user.dtos.CustomerSignupDTO;
import com.niyat.ride.user.dtos.CustomerUpdateDTO;
import com.niyat.ride.user.mappers.CustomerMapper;
import com.niyat.ride.user.models.Customer;
import com.niyat.ride.user.repositories.CustomerRepository;
import com.niyat.ride.enums.AccountStatus;
import com.niyat.ride.enums.Role;
import com.niyat.ride.exceptions.CustomerAlreadyExistsException;
import com.niyat.ride.exceptions.CustomerDoesNotExistException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class CustomerServiceImpl implements CustomerService {

    private final CustomerRepository customerRepository;
    private final CustomerMapper customerMapper;

    @Override
    @Transactional
    public CustomerResponseDTO signUpCustomer(CustomerSignupDTO customerSignupDTO) {
        checkIfCustomerExists(customerSignupDTO.getPhoneNumber());

        Customer customer = customerMapper.toEntity(customerSignupDTO);
        customer.setRole(Role.CUSTOMER);
        customer.setPhoneNumber(customerSignupDTO.getPhoneNumber());
        customer.setIsVerified(true);
        customer.setVerifiedAt(LocalDateTime.now());
        customer.setStatus(AccountStatus.ACTIVE);
        customer.setCreatedAt(LocalDateTime.now());
        customer.setUpdatedAt(LocalDateTime.now());
        Customer savedCustomer = customerRepository.save(customer);

        return customerMapper.toResponseDTO(savedCustomer);
    }


    @Override
    @Transactional
    public CustomerResponseDTO updateCustomer(Long customerId, CustomerUpdateDTO updateDTO) {
        Customer customer = customerRepository.findById(customerId)
                .orElseThrow(() -> new CustomerDoesNotExistException("Customer not found with id: " + customerId));

        customer.setFirstName(updateDTO.getFirstName());
        customer.setLastName(updateDTO.getLastName());
        customer.setEmail(updateDTO.getEmail());
        customer.setUpdatedAt(LocalDateTime.now());

        Customer updatedCustomer = customerRepository.save(customer);
        return customerMapper.toResponseDTO(updatedCustomer);
    }

    @Override
    public void checkIfCustomerExists(String phoneNumber) {
        customerRepository.findByPhoneNumber(phoneNumber)
                .ifPresent(c -> {
                    throw new CustomerAlreadyExistsException(
                            "Customer with phone number " + phoneNumber + " already exists"
                    );
                });
    }

    @Override
    public CustomerResponseDTO getCustomerByPhoneNumber(String phoneNumber) {
        Customer customer = customerRepository.findByPhoneNumber(phoneNumber)
                .orElseThrow(() -> new RuntimeException("Customer not found with phone: " + phoneNumber));
        return customerMapper.toResponseDTO(customer);
    }

}