package com.niyat.ride.dispatcher.repositories;

import com.niyat.ride.dispatcher.models.Dispatcher;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface DispatcherRepository extends JpaRepository<Dispatcher, Long> {
    Optional<Dispatcher> findByPhoneNumber(String phoneNumber);
    Optional<Dispatcher> findByEmail(String email);
}