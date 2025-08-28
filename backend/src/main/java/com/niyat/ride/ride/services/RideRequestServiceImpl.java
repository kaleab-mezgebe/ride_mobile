package com.niyat.ride.ride.services;

import com.niyat.ride.ride.repositories.RideRequestRepository;
import com.niyat.ride.ride.models.RideRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class RideRequestServiceImpl implements RideRequestService {
    RideRequestRepository rideRequestRepository;


    @Override
    public RideRequest saveRdeRequest(RideRequest rideRequest) {
        return null;
    }
}
