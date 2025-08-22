package com.niyat.ride.repositories;

import com.niyat.ride.models.RideRequest;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import com.niyat.ride.enums.RideStatus;
import java.util.List;

public interface RideRequestRepository extends JpaRepository<RideRequest, Long> {
    List<RideRequest> findByDriverIdAndStatusIn(Long driverId, List<RideStatus> statuses);
    
    // For dispatcher ride management - filter by dispatcher region or assigned dispatcher
    Page<RideRequest> findByDispatcherId(Long dispatcherId, Pageable pageable);
}
