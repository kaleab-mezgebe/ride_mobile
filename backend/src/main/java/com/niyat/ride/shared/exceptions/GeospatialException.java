package com.niyat.ride.shared.exceptions;

/**
 * Custom exception for geospatial operation errors
 */
public class GeospatialException extends RuntimeException {
    
    public GeospatialException(String message) {
        super(message);
    }
    
    public GeospatialException(String message, Throwable cause) {
        super(message, cause);
    }
}
