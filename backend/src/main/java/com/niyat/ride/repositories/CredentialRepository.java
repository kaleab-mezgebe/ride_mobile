package com.niyat.ride.repositories;



import com.niyat.ride.models.Credential;
import org.springframework.data.jpa.repository.JpaRepository;


import java.util.Optional;

public interface CredentialRepository extends JpaRepository<Credential, Long> {
    Optional<Credential> findByEmail(String usernameOrEmail);

    Optional<Credential> findByUserId(Long adminId);
}

