package com.niyat.ride.shared.services;

import com.niyat.ride.shared.dtos.NearbyDriverDTO;

import java.util.List;

public interface DriverDiscoveryService {
    
    /**
     * Find nearby available drivers within specified radius
     * 
     * @param pickupLatitude Pickup location latitude
     * @param pickupLongitude Pickup location longitude
     * @param radiusKm Search radius in kilometers
     * @param vehicleTypeId Optional vehicle type filter
     * @param maxResults Maximum number of results to return
     * @return List of nearby available drivers sorted by distance
     */
    List<NearbyDriverDTO> findNearbyDrivers(Double pickupLatitude, Double pickupLongitude, 
                                           Double radiusKm, Long vehicleTypeId, Integer maxResults);
    
    /**
     * Find nearby drivers with default parameters
     * 
     * @param pickupLatitude Pickup location latitude
     * @param pickupLongitude Pickup location longitude
     * @return List of nearby drivers within 5km radius, max 10 results
     */
    List<NearbyDriverDTO> findNearbyDrivers(Double pickupLatitude, Double pickupLongitude);
    
    /**
     * Check if driver is available for new rides
     * 
     * @param driverId Driver ID to check
     * @return true if driver is available, false otherwise
     */
    boolean isDriverAvailable(Long driverId);
    
    /**
     * Calculate estimated arrival time for driver to pickup location
     * 
     * @param driverLatitude Driver's current latitude
     * @param driverLongitude Driver's current longitude
     * @param pickupLatitude Pickup location latitude
     * @param pickupLongitude Pickup location longitude
     * @return Estimated arrival time in minutes
     */
    Integer calculateEstimatedArrival(Double driverLatitude, Double driverLongitude,
                                    Double pickupLatitude, Double pickupLongitude);
}
