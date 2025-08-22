package com.niyat.ride.features.admin.pricing_management.services;

import com.niyat.ride.features.admin.pricing_management.dtos.BasePriceResponseDTO;
import com.niyat.ride.features.admin.pricing_management.dtos.BasePriceUpdateDTO;

import java.math.BigDecimal;

public interface BasePriceService {
    
    /**
     * Get the current active base price with details
     * @return Current base price details
     */
    BasePriceResponseDTO getCurrentBasePrice();
    
    /**
     * Get detailed base price information
     * @return Base price details with metadata
     */
    BasePriceResponseDTO getCurrentBasePriceDetails();
    
    /**
     * Update the base price
     * @param updateDTO New base price information
     * @param adminId ID of the admin making the change
     * @return Updated base price details
     */
    BasePriceResponseDTO updateBasePrice(BasePriceUpdateDTO updateDTO, Long adminId);
    
    /**
     * Initialize default base price if none exists
     * @param defaultAmount Default amount to set
     */
    void initializeDefaultBasePriceIfNeeded(BigDecimal defaultAmount);

    /**
     * Get only the current base price amount (for pricing calculations)
     */
    BigDecimal getCurrentBasePriceAmount();

    /**
     * Ensure a default base price exists (used by tests)
     */
    void ensureDefaultBasePriceExists();
}
