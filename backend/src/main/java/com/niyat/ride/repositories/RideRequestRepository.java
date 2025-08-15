package com.niyat.ride.repositories;

import com.niyat.ride.models.RideRequest;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RideRequestRepository extends JpaRepository<RideRequest, Long> {
}
