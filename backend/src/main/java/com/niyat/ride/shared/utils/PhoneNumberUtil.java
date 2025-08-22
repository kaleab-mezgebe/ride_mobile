package com.niyat.ride.shared.utils;

import lombok.extern.slf4j.Slf4j;

import java.util.regex.Pattern;

@Slf4j
public class PhoneNumberUtil {
    
    // Ethiopian phone number patterns
    private static final Pattern ETH_MOBILE_PATTERN = Pattern.compile("^\\+251[79]\\d{8}$");
    private static final Pattern ETH_MOBILE_WITHOUT_PREFIX = Pattern.compile("^0[79]\\d{8}$");
    private static final Pattern ETH_MOBILE_SHORT = Pattern.compile("^[79]\\d{8}$");
    
    /**
     * Normalize Ethiopian phone number to international format (+251XXXXXXXXX)
     * 
     * @param phoneNumber Raw phone number input
     * @return Normalized phone number in +251 format
     * @throws IllegalArgumentException if phone number is invalid
     */
    public static String normalizeEthiopianPhoneNumber(String phoneNumber) {
        if (phoneNumber == null || phoneNumber.trim().isEmpty()) {
            throw new IllegalArgumentException("Phone number cannot be null or empty");
        }
        
        // Remove all spaces and special characters except +
        String cleaned = phoneNumber.replaceAll("[\\s\\-\\(\\)]", "");
        
        // Already in international format
        if (ETH_MOBILE_PATTERN.matcher(cleaned).matches()) {
            return cleaned;
        }
        
        // Local format with leading 0 (e.g., 0911234567)
        if (ETH_MOBILE_WITHOUT_PREFIX.matcher(cleaned).matches()) {
            return "+251" + cleaned.substring(1);
        }
        
        // Short format without leading 0 (e.g., 911234567)
        if (ETH_MOBILE_SHORT.matcher(cleaned).matches()) {
            return "+251" + cleaned;
        }
        
        throw new IllegalArgumentException("Invalid Ethiopian phone number format: " + phoneNumber);
    }
    
    /**
     * Validate if phone number is a valid Ethiopian mobile number
     * 
     * @param phoneNumber Phone number to validate
     * @return true if valid, false otherwise
     */
    public static boolean isValidEthiopianPhoneNumber(String phoneNumber) {
        try {
            normalizeEthiopianPhoneNumber(phoneNumber);
            return true;
        } catch (IllegalArgumentException e) {
            log.debug("Invalid phone number: {}", phoneNumber);
            return false;
        }
    }
    
    /**
     * Extract display format for phone number (0XXXXXXXXX)
     * 
     * @param normalizedPhoneNumber Phone number in +251 format
     * @return Display format starting with 0
     */
    public static String getDisplayFormat(String normalizedPhoneNumber) {
        if (normalizedPhoneNumber != null && normalizedPhoneNumber.startsWith("+251")) {
            return "0" + normalizedPhoneNumber.substring(4);
        }
        return normalizedPhoneNumber;
    }
}
