package com.niyat.ride.shared.exceptions;

/**
 * Exception thrown when location validation fails
 */
public class LocationValidationException extends RuntimeException {
    
    public LocationValidationException(String message) {
        super(message);
    }
    
    public LocationValidationException(String message, Throwable cause) {
        super(message, cause);
    }
}
