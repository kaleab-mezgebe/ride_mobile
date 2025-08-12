package com.niyat.ride.repositories;

import com.niyat.ride.models.Dispatcher;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface DispatcherRepository extends JpaRepository<Dispatcher, Long> {
    Optional<Dispatcher> findByPhoneNumber(String phoneNumber);
    Optional<Dispatcher> findByEmail(String email);
}