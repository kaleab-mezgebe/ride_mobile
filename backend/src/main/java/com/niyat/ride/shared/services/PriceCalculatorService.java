package com.niyat.ride.shared.services;

import com.niyat.ride.features.ride_management.dtos.RideCostDTO;
import com.niyat.ride.models.VehicleType;

import java.math.BigDecimal;

public interface PriceCalculatorService {
    
    /**
     * Calculate estimated cost for a ride based on vehicle type and estimated distance
     */
    RideCostDTO calculateEstimatedCost(Long vehicleTypeId, Double estimatedDistanceKm);
    
    /**
     * Calculate final cost for a completed ride based on actual distance
     */
    RideCostDTO calculateFinalCost(Long vehicleTypeId, Double actualDistanceKm, BigDecimal surgeFactor);
    
    /**
     * Calculate cost with surge pricing applied
     */
    RideCostDTO calculateWithSurge(Long vehicleTypeId, Double distanceKm, BigDecimal surgeFactor);
    
    /**
     * Apply discount to calculated cost
     */
    RideCostDTO applyDiscount(RideCostDTO originalCost, BigDecimal discountPercentage);
    
    /**
     * Get vehicle type pricing details
     */
    VehicleType getVehicleTypePricing(Long vehicleTypeId);
}
