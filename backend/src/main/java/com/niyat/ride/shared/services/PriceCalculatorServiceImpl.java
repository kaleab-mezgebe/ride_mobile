package com.niyat.ride.shared.services;

import com.niyat.ride.features.ride_management.dtos.RideCostDTO;
import com.niyat.ride.models.VehicleType;
import com.niyat.ride.features.admin.vehicle_type_management.repositories.VehicleTypeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;

@Service
@RequiredArgsConstructor
public class PriceCalculatorServiceImpl implements PriceCalculatorService {

    private final VehicleTypeRepository vehicleTypeRepository;

    @Override
    public RideCostDTO calculateEstimatedCost(Long vehicleTypeId, Double estimatedDistanceKm) {
        VehicleType vehicleType = getVehicleTypePricing(vehicleTypeId);
        
        BigDecimal basePrice = vehicleType.getBasePrice();
        BigDecimal distancePrice = vehicleType.getPricePerKm()
                .multiply(BigDecimal.valueOf(estimatedDistanceKm))
                .setScale(2, RoundingMode.HALF_UP);
        
        BigDecimal totalCost = basePrice.add(distancePrice);
        
        RideCostDTO rideCost = new RideCostDTO(basePrice, distancePrice, totalCost, estimatedDistanceKm);
        rideCost.setVehicleTypeId(vehicleTypeId);
        rideCost.setVehicleTypeName(vehicleType.getName());
        rideCost.setPriceBreakdown(buildPriceBreakdown(rideCost));
        
        return rideCost;
    }

    @Override
    public RideCostDTO calculateFinalCost(Long vehicleTypeId, Double actualDistanceKm, BigDecimal surgeFactor) {
        if (surgeFactor == null) {
            surgeFactor = BigDecimal.ONE;
        }
        
        RideCostDTO baseCost = calculateEstimatedCost(vehicleTypeId, actualDistanceKm);
        
        if (surgeFactor.compareTo(BigDecimal.ONE) > 0) {
            return calculateWithSurge(vehicleTypeId, actualDistanceKm, surgeFactor);
        }
        
        return baseCost;
    }

    @Override
    public RideCostDTO calculateWithSurge(Long vehicleTypeId, Double distanceKm, BigDecimal surgeFactor) {
        RideCostDTO baseCost = calculateEstimatedCost(vehicleTypeId, distanceKm);
        
        BigDecimal surgeAmount = baseCost.getTotalCost()
                .multiply(surgeFactor.subtract(BigDecimal.ONE))
                .setScale(2, RoundingMode.HALF_UP);
        
        BigDecimal finalCost = baseCost.getTotalCost().add(surgeAmount);
        
        baseCost.setSurgeFactor(surgeFactor);
        baseCost.setSurgeAmount(surgeAmount);
        baseCost.setFinalCost(finalCost);
        baseCost.setPriceBreakdown(buildPriceBreakdown(baseCost));
        
        return baseCost;
    }

    @Override
    public RideCostDTO applyDiscount(RideCostDTO originalCost, BigDecimal discountPercentage) {
        BigDecimal discountAmount = originalCost.getFinalCost()
                .multiply(discountPercentage.divide(BigDecimal.valueOf(100)))
                .setScale(2, RoundingMode.HALF_UP);
        
        BigDecimal finalCostAfterDiscount = originalCost.getFinalCost().subtract(discountAmount);
        
        originalCost.setDiscountAmount(discountAmount);
        originalCost.setFinalCost(finalCostAfterDiscount);
        originalCost.setPriceBreakdown(buildPriceBreakdown(originalCost));
        
        return originalCost;
    }

    @Override
    public VehicleType getVehicleTypePricing(Long vehicleTypeId) {
        return vehicleTypeRepository.findById(vehicleTypeId)
                .orElseThrow(() -> new RuntimeException("Vehicle type not found with id: " + vehicleTypeId));
    }

    private String buildPriceBreakdown(RideCostDTO rideCost) {
        StringBuilder breakdown = new StringBuilder();
        
        breakdown.append("Base Price: $").append(rideCost.getBasePrice());
        breakdown.append(", Distance (").append(rideCost.getDistanceKm()).append("km): $")
                .append(rideCost.getDistancePrice());
        
        if (rideCost.getSurgeAmount() != null && rideCost.getSurgeAmount().compareTo(BigDecimal.ZERO) > 0) {
            breakdown.append(", Surge (").append(rideCost.getSurgeFactor()).append("x): $")
                    .append(rideCost.getSurgeAmount());
        }
        
        if (rideCost.getDiscountAmount() != null && rideCost.getDiscountAmount().compareTo(BigDecimal.ZERO) > 0) {
            breakdown.append(", Discount: -$").append(rideCost.getDiscountAmount());
        }
        
        breakdown.append(", Total: $").append(rideCost.getFinalCost());
        
        return breakdown.toString();
    }
}
