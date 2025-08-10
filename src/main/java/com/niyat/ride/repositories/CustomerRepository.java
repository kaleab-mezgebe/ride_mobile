package com.niyat.ride.repositories;

import com.niyat.ride.models.Customer;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface CustomerRepository extends JpaRepository<Customer, Long> {
      Optional<Customer> findByPhoneNumber(String PhoneNumber);

}
