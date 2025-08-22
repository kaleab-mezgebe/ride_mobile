package com.niyat.ride.features.dispatcher.ride_creation.services;

import com.niyat.ride.features.dispatcher.ride_creation.dtos.DispatcherRideRequestDTO;
import com.niyat.ride.features.dispatcher.ride_creation.dtos.DispatcherRideResponseDTO;
import org.springframework.data.domain.Page;

public interface DispatcherRideService {
    
    DispatcherRideResponseDTO createRide(DispatcherRideRequestDTO request, Long dispatcherId);
    
    DispatcherRideResponseDTO assignDriverToRide(Long rideId, Long driverId);
    
    Page<DispatcherRideResponseDTO> getDispatcherRides(Long dispatcherId, Integer page, Integer size, String sortBy, String sortDirection);
    
    DispatcherRideResponseDTO getRideById(Long rideId);
}
