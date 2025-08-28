package com.niyat.ride.admin.repositories;

import com.niyat.ride.admin.models.Admin;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface AdminRepository extends JpaRepository<Admin, Long> {
    Optional<Admin> findByPhoneNumber(String phoneNumber);
    Optional<Admin> findByEmail(String email);
}