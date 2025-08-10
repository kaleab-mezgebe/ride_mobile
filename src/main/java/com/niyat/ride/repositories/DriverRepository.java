package com.niyat.ride.repositories;

import com.niyat.ride.models.Customer;
import com.niyat.ride.models.Driver;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface DriverRepository extends JpaRepository<Driver, Long> {
    Optional<Customer> findByPhoneNumber(String PhoneNumber);
    Optional<Driver> findByEmail(String email);
}
