package com.niyat.ride.user.repositories;

import com.niyat.ride.user.models.Customer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface CustomerRepository extends JpaRepository<Customer, Long> {
      Optional<Customer> findByPhoneNumber(String PhoneNumber);
      Optional<Customer> findByEmail(String email);
}
