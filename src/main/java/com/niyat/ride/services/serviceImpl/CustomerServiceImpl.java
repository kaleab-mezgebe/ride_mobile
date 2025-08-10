package com.niyat.ride.services.serviceImpl;

import com.niyat.ride.dtos.CustomerResponseDTO;
import com.niyat.ride.dtos.CustomerSignupDTO;
import com.niyat.ride.dtos.CustomerUpdateDTO;
import com.niyat.ride.enums.AccountStatus;
import com.niyat.ride.enums.Role;
import com.niyat.ride.exceptions.CustomerAlreadyExistsException;
import com.niyat.ride.exceptions.CustomerDoesNotExistException;
import com.niyat.ride.mappers.CustomerMapper;
import com.niyat.ride.models.Customer;
import com.niyat.ride.repositories.CustomerRepository;
import com.niyat.ride.services.CustomerService;
import com.niyat.ride.utils.Helpers;
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
        customerRepository.findByPhoneNumber(customerSignupDTO.getPhoneNumber())
                .ifPresent(c -> {
                    throw new CustomerAlreadyExistsException(
                            "Customer with phone number " + c.getPhoneNumber() + " already exists");
                });

        Customer customer = customerMapper.toEntity(customerSignupDTO);
        customer.setPassword(Helpers.encryptPassword(customerSignupDTO.getPassword()));
        customer.setRole(Role.CUSTOMER);
        customer.setPhoneNumber(customerSignupDTO.getPhoneNumber());
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
}