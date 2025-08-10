package com.niyat.ride.repositories;

import com.niyat.ride.models.Admin;
import com.niyat.ride.models.Customer;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface AdminRepository extends JpaRepository<Admin, Long> {
    Optional<Customer> findByPhoneNumber(String PhoneNumber);
    Optional<Admin> findByEmail(String email);
}