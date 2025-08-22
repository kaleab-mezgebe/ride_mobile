package com.niyat.ride.features.dispatcher.ride_creation.services;

import com.niyat.ride.features.dispatcher.ride_creation.dtos.LocationDTO;

public interface LocationValidationService {
    
    /**
     * Validate if coordinates are within serviceable areas
     * 
     * @param locationDTO Location to validate
     * @return true if location is serviceable, false otherwise
     */
    boolean isLocationServiceable(LocationDTO locationDTO);
    
    /**
     * Validate coordinate values are within valid ranges
     * 
     * @param latitude Latitude value
     * @param longitude Longitude value
     * @throws IllegalArgumentException if coordinates are invalid
     */
    void validateCoordinates(Double latitude, Double longitude);
    
    /**
     * Standardize and format address string
     * 
     * @param rawAddress Raw address input
     * @return Formatted address
     */
    String standardizeAddress(String rawAddress);
    
    /**
     * Calculate distance between two locations in kilometers
     * 
     * @param lat1 First location latitude
     * @param lon1 First location longitude
     * @param lat2 Second location latitude
     * @param lon2 Second location longitude
     * @return Distance in kilometers
     */
    double calculateDistance(Double lat1, Double lon1, Double lat2, Double lon2);
    
    /**
     * Check if location is within Addis Ababa metropolitan area
     * 
     * @param latitude Latitude
     * @param longitude Longitude
     * @return true if within Addis Ababa area
     */
    boolean isWithinAddisAbabaArea(Double latitude, Double longitude);
    
    /**
     * Validate complete location information
     * 
     * @param locationDTO Location to validate
     * @throws IllegalArgumentException if validation fails
     */
    void validateLocationInfo(LocationDTO locationDTO);
}
