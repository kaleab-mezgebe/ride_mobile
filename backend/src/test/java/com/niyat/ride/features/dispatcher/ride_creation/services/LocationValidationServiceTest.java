package com.niyat.ride.features.dispatcher.ride_creation.services;

import com.niyat.ride.features.dispatcher.ride_creation.dtos.LocationDTO;
import com.niyat.ride.shared.exceptions.LocationValidationException;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.junit.jupiter.api.Assertions.*;

@ExtendWith(MockitoExtension.class)
class LocationValidationServiceTest {

    @InjectMocks
    private LocationValidationServiceImpl locationValidationService;

    private LocationDTO validAddisAbabaLocation;
    private LocationDTO invalidLocation;

    @BeforeEach
    void setUp() {
        validAddisAbabaLocation = new LocationDTO();
        validAddisAbabaLocation.setLatitude(9.0);
        validAddisAbabaLocation.setLongitude(38.8);
        validAddisAbabaLocation.setAddress("Bole, Addis Ababa");

        invalidLocation = new LocationDTO();
        invalidLocation.setLatitude(200.0); // Invalid latitude
        invalidLocation.setLongitude(38.8);
        invalidLocation.setAddress("Invalid Location");
    }

    @Test
    void isValidCoordinates_ShouldReturnTrueForValidCoordinates() {
        // Act & Assert
        assertTrue(locationValidationService.isValidCoordinates(9.0, 38.8));
    }

    @Test
    void isValidCoordinates_ShouldThrowExceptionForInvalidLatitude() {
        // Act & Assert
        assertThrows(LocationValidationException.class, 
            () -> locationValidationService.isValidCoordinates(200.0, 38.8));
    }

    @Test
    void isValidCoordinates_ShouldThrowExceptionForInvalidLongitude() {
        // Act & Assert
        assertThrows(LocationValidationException.class, 
            () -> locationValidationService.isValidCoordinates(9.0, 200.0));
    }

    @Test
    void isWithinServiceArea_ShouldReturnTrueForAddisAbaba() {
        // Act & Assert
        assertTrue(locationValidationService.isWithinServiceArea(9.0, 38.8));
    }

    @Test
    void isWithinServiceArea_ShouldReturnFalseForOutsideAddisAbaba() {
        // Act & Assert
        assertFalse(locationValidationService.isWithinServiceArea(10.0, 40.0));
    }

    @Test
    void standardizeAddress_ShouldTrimAndFormatAddress() {
        // Arrange
        String rawAddress = "  Bole   Addis  Ababa  ";

        // Act
        String result = locationValidationService.standardizeAddress(rawAddress);

        // Assert
        assertEquals("Bole Addis Ababa", result);
    }

    @Test
    void calculateDistance_ShouldReturnCorrectDistance() {
        // Arrange
        double lat1 = 9.0, lon1 = 38.8;
        double lat2 = 9.1, lon2 = 38.9;

        // Act
        double distance = locationValidationService.calculateDistance(lat1, lon1, lat2, lon2);

        // Assert
        assertTrue(distance > 0);
        assertTrue(distance < 20); // Should be less than 20km for nearby locations
    }

    @Test
    void validateLocationDTO_ShouldPassForValidLocation() {
        // Act & Assert
        assertDoesNotThrow(() -> locationValidationService.validateLocationDTO(validAddisAbabaLocation));
    }

    @Test
    void validateLocationDTO_ShouldThrowForInvalidLocation() {
        // Act & Assert
        assertThrows(LocationValidationException.class, 
            () -> locationValidationService.validateLocationDTO(invalidLocation));
    }
}
