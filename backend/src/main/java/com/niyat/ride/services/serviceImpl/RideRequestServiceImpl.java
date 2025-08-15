package com.niyat.ride.services.serviceImpl;

import com.niyat.ride.models.RideRequest;
import com.niyat.ride.repositories.RideRequestRepository;
import com.niyat.ride.services.RideRequestService;
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
