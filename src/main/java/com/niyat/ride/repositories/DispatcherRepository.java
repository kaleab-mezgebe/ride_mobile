package com.niyat.ride.repositories;

import com.niyat.ride.models.Customer;
import com.niyat.ride.models.Dispatcher;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface DispatcherRepository extends JpaRepository<Dispatcher, Long> {
    Optional<Customer> findByPhoneNumber(String PhoneNumber);
    Optional<Dispatcher> findByEmail(String email);
}