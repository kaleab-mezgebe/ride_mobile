package com.niyat.ride.driver.models;

import com.niyat.ride.shared.models.User;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.Data;
import lombok.EqualsAndHashCode;
import org.locationtech.jts.geom.Point;

@Data
@EqualsAndHashCode(callSuper = true)
@Entity
@Table(name = "drivers")
public class Driver extends User {
    
    @Column(unique = true, nullable = false)
    private String licenseNumber;

    @Column(name = "license_image_path")
    private String licenseImagePath;
    
    // PostGIS spatial column for current location
    @Column(name = "current_location", columnDefinition = "GEOMETRY(Point, 4326)")
    private Point currentLocation;
    
    // Backup coordinates for compatibility
    @Column(name = "current_latitude")
    private Double currentLatitude;
    
    @Column(name = "current_longitude")
    private Double currentLongitude;
    
    @Column(name = "is_online")
    private Boolean isOnline = false;
    
    @Column(name = "last_location_update")
    private java.time.LocalDateTime lastLocationUpdate;

}
