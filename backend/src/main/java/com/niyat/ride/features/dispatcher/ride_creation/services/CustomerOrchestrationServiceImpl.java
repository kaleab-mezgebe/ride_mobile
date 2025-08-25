package com.niyat.ride.features.dispatcher.ride_creation.services;

import com.niyat.ride.enums.AccountStatus;
import com.niyat.ride.enums.Role;
import com.niyat.ride.features.dispatcher.ride_creation.dtos.CustomerInfoDTO;
import com.niyat.ride.models.Customer;
import com.niyat.ride.repositories.CustomerRepository;
import com.niyat.ride.shared.utils.PhoneNumberUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Slf4j
@Service
@RequiredArgsConstructor
public class CustomerOrchestrationServiceImpl implements CustomerOrchestrationService {
    
    private final CustomerRepository customerRepository;
    
    @Override
    @Transactional
    public Customer findOrCreateCustomer(CustomerInfoDTO customerInfo) {
        validateCustomerInfo(customerInfo);
        
        String normalizedPhone = PhoneNumberUtil.normalizeEthiopianPhoneNumber(customerInfo.getPhoneNumber());
        
        // If customer ID is provided, validate it matches the phone number
        if (customerInfo.getCustomerId() != null) {
            Customer existingCustomer = customerRepository.findById(customerInfo.getCustomerId())
                    .orElseThrow(() -> new RuntimeException("Customer not found with id: " + customerInfo.getCustomerId()));
            
            if (!normalizedPhone.equals(existingCustomer.getPhoneNumber())) {
                throw new IllegalArgumentException("Customer ID does not match the provided phone number");
            }
            
            log.info("Found existing customer by ID: {}", customerInfo.getCustomerId());
            return existingCustomer;
        }
        
        // Try to find by phone number
        Customer existingCustomer = findCustomerByPhoneNumber(normalizedPhone);
        if (existingCustomer != null) {
            log.info("Found existing customer by phone: {}", normalizedPhone);
            return existingCustomer;
        }
        
        // Create new customer if none found
        if (Boolean.TRUE.equals(customerInfo.getIsNewCustomer())) {
            log.info("Creating new customer with phone: {}", normalizedPhone);
            return createMinimalCustomer(customerInfo);
        }
        
        throw new RuntimeException("Customer not found with phone number: " + normalizedPhone);
    }
    
    @Override
    public Customer findCustomerByPhoneNumber(String phoneNumber) {
        String normalizedPhone = PhoneNumberUtil.normalizeEthiopianPhoneNumber(phoneNumber);
        return customerRepository.findByPhoneNumber(normalizedPhone).orElse(null);
    }
    
    @Override
    @Transactional
    public Customer createMinimalCustomer(CustomerInfoDTO customerInfo) {
        String normalizedPhone = PhoneNumberUtil.normalizeEthiopianPhoneNumber(customerInfo.getPhoneNumber());
        
        // Check if customer already exists
        if (customerRepository.findByPhoneNumber(normalizedPhone).isPresent()) {
            throw new RuntimeException("Customer already exists with phone number: " + normalizedPhone);
        }
        
        Customer customer = new Customer();
        customer.setFirstName(customerInfo.getFirstName());
        customer.setLastName(customerInfo.getLastName());
        customer.setPhoneNumber(normalizedPhone);
        customer.setEmail(customerInfo.getEmail());
        customer.setRole(Role.CUSTOMER);
        customer.setStatus(AccountStatus.ACTIVE); // Auto-activate for dispatcher-created customers
        customer.setIsVerified(false); // Will be verified later if needed
        customer.setCreatedAt(LocalDateTime.now());
        
        Customer savedCustomer = customerRepository.save(customer);
        log.info("Created new customer with ID: {} and phone: {}", savedCustomer.getId(), normalizedPhone);
        
        return savedCustomer;
    }
    
    @Override
    public void validateCustomerInfo(CustomerInfoDTO customerInfo) {
        if (customerInfo == null) {
            throw new IllegalArgumentException("Customer information is required");
        }
        
        // Validate phone number format
        if (!PhoneNumberUtil.isValidEthiopianPhoneNumber(customerInfo.getPhoneNumber())) {
            throw new IllegalArgumentException("Invalid Ethiopian phone number format");
        }
        
        // If it's a new customer, ensure basic info is provided
        if (Boolean.TRUE.equals(customerInfo.getIsNewCustomer())) {
            if (customerInfo.getFirstName() == null || customerInfo.getFirstName().trim().isEmpty()) {
                throw new IllegalArgumentException("First name is required for new customers");
            }
            if (customerInfo.getLastName() == null || customerInfo.getLastName().trim().isEmpty()) {
                throw new IllegalArgumentException("Last name is required for new customers");
            }
        }
        
        // If customer ID is provided but marked as new customer, that's inconsistent
        if (customerInfo.getCustomerId() != null && Boolean.TRUE.equals(customerInfo.getIsNewCustomer())) {
            throw new IllegalArgumentException("Cannot provide customer ID for new customer creation");
        }
    }
}
