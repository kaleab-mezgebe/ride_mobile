package com.niyat.ride.shared.exceptions;

/**
 * Exception thrown when driver discovery operations fail
 */
public class DriverDiscoveryException extends RuntimeException {
    
    public DriverDiscoveryException(String message) {
        super(message);
    }
    
    public DriverDiscoveryException(String message, Throwable cause) {
        super(message, cause);
    }
}
