package com.niyat.ride.features.admin.pricing_dashboard.services;

import com.niyat.ride.features.admin.pricing_dashboard.dtos.PricingAnalyticsDTO;
import com.niyat.ride.features.admin.pricing_dashboard.dtos.PricingOverviewDTO;
import com.niyat.ride.features.admin.pricing_dashboard.dtos.PriceIncreaseRequestDTO;
import com.niyat.ride.features.admin.pricing_dashboard.models.PricingHistory;
import com.niyat.ride.features.admin.pricing_dashboard.repositories.PricingHistoryRepository;
import com.niyat.ride.features.admin.ride_management.repositories.RideManagementRepository;
import com.niyat.ride.features.admin.vehicle_type_management.repositories.VehicleTypeRepository;
import com.niyat.ride.models.VehicleType;
import com.niyat.ride.repositories.AdminRepository;
import com.niyat.ride.features.admin.pricing_management.services.BasePriceService;
import com.niyat.ride.features.admin.pricing_management.dtos.BasePriceUpdateDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class PricingDashboardServiceImpl implements PricingDashboardService {

    private final VehicleTypeRepository vehicleTypeRepository;
    private final RideManagementRepository rideManagementRepository;
    private final PricingHistoryRepository pricingHistoryRepository;
    private final AdminRepository adminRepository;
    private final BasePriceService basePriceService;

    @Override
    public PricingOverviewDTO getPricingOverview() {
        List<VehicleType> allVehicleTypes = vehicleTypeRepository.findAll();
        List<VehicleType> activeTypes = allVehicleTypes.stream()
                .filter(vt -> vt.getDeletedAt() == null && vt.getIsActive())
                .collect(Collectors.toList());

        List<PricingOverviewDTO.VehicleTypePricingDTO> vehicleTypePricing = activeTypes.stream()
                .map(this::mapToVehicleTypePricingDTO)
                .collect(Collectors.toList());

        PricingOverviewDTO overview = new PricingOverviewDTO();
        overview.setVehicleTypePricing(vehicleTypePricing);
        overview.setTotalActiveVehicleTypes(activeTypes.size());
        overview.setTotalInactiveVehicleTypes((int) allVehicleTypes.stream()
                .filter(vt -> vt.getDeletedAt() == null && !vt.getIsActive()).count());

        if (!activeTypes.isEmpty()) {
            // Base price is global now; set overview metrics to the current global base price
            BigDecimal currentBasePrice = basePriceService.getCurrentBasePriceAmount();
            overview.setAverageBasePrice(currentBasePrice);
            overview.setLowestBasePrice(currentBasePrice);
            overview.setHighestBasePrice(currentBasePrice);

            overview.setAveragePricePerKm(activeTypes.stream()
                    .map(VehicleType::getPricePerKm)
                    .reduce(BigDecimal.ZERO, BigDecimal::add)
                    .divide(BigDecimal.valueOf(activeTypes.size()), 2, RoundingMode.HALF_UP));
        }

        return overview;
    }

    @Override
    public PricingAnalyticsDTO getPricingAnalytics() {
        LocalDateTime thirtyDaysAgo = LocalDateTime.now().minusDays(30);
        
        PricingAnalyticsDTO analytics = new PricingAnalyticsDTO();

        // Get recent pricing changes
        List<PricingHistory> recentChanges = pricingHistoryRepository.findRecentChanges(thirtyDaysAgo);
        List<PricingAnalyticsDTO.PricingChangeHistoryDTO> changeHistory = recentChanges.stream()
                .map(this::mapToPricingChangeHistoryDTO)
                .collect(Collectors.toList());
        analytics.setRecentPricingChanges(changeHistory);

        // Calculate revenue analytics
        analytics.setTotalRevenueLast30Days(rideManagementRepository.calculateTotalRevenue());
        analytics.setTotalRidesLast30Days(rideManagementRepository.countTotalRides());
        analytics.setAverageRevenuePerRide(rideManagementRepository.calculateAverageRideValue());

        // Mock data for vehicle type analytics (would need proper ride queries)
        analytics.setAverageRideCostByVehicleType(new HashMap<>());
        analytics.setMostPopularVehicleTypes(new HashMap<>());
        analytics.setRevenueByVehicleType(new HashMap<>());

        return analytics;
    }

    @Override
    @Transactional
    public List<String> applyPriceIncrease(PriceIncreaseRequestDTO request, Long adminId) {
        List<String> results = new ArrayList<>();
        List<VehicleType> vehicleTypes;

        if (request.getVehicleTypeIds() != null && !request.getVehicleTypeIds().isEmpty()) {
            vehicleTypes = vehicleTypeRepository.findAllById(request.getVehicleTypeIds());
        } else {
            vehicleTypes = vehicleTypeRepository.findAllActiveTypes();
        }

        BigDecimal increaseMultiplier = BigDecimal.ONE.add(
                request.getPercentageIncrease().divide(BigDecimal.valueOf(100), 4, RoundingMode.HALF_UP)
        );

        // Handle global base price increase once, if requested
        if (Boolean.TRUE.equals(request.getApplyToBasePrice())) {
            try {
                BigDecimal currentBase = basePriceService.getCurrentBasePriceAmount();
                BigDecimal newBase = currentBase.multiply(increaseMultiplier).setScale(2, RoundingMode.HALF_UP);
                BasePriceUpdateDTO updateDTO = new BasePriceUpdateDTO();
                updateDTO.setAmount(newBase);
                updateDTO.setChangeReason(Optional.ofNullable(request.getReason()).orElse("Bulk percentage increase"));
                basePriceService.updateBasePrice(updateDTO, adminId);
                results.add("Successfully updated global base price");
            } catch (Exception e) {
                results.add("Failed to update global base price: " + e.getMessage());
            }
        }

        for (VehicleType vehicleType : vehicleTypes) {
            try {
                // Create pricing history record
                PricingHistory history = new PricingHistory();
                history.setVehicleType(vehicleType);
                history.setOldPricePerKm(vehicleType.getPricePerKm());
                history.setChangeReason(request.getReason());
                history.setChangedByAdminId(adminId);
                history.setChangePercentage(request.getPercentageIncrease());

                // Apply price increases
                if (request.getApplyToPricePerKm()) {
                    BigDecimal newPricePerKm = vehicleType.getPricePerKm()
                            .multiply(increaseMultiplier)
                            .setScale(2, RoundingMode.HALF_UP);
                    vehicleType.setPricePerKm(newPricePerKm);
                    history.setNewPricePerKm(newPricePerKm);
                }

                vehicleType.setUpdatedAt(LocalDateTime.now());

                vehicleTypeRepository.save(vehicleType);
                pricingHistoryRepository.save(history);

                results.add("Successfully updated pricing for " + vehicleType.getName());

            } catch (Exception e) {
                results.add("Failed to update pricing for " + vehicleType.getName() + ": " + e.getMessage());
            }
        }

        return results;
    }

    private PricingOverviewDTO.VehicleTypePricingDTO mapToVehicleTypePricingDTO(VehicleType vehicleType) {
        // This would typically involve querying for ride statistics
        return new PricingOverviewDTO.VehicleTypePricingDTO(
                vehicleType.getId(),
                vehicleType.getName(),
                vehicleType.getPricePerKm(),
                vehicleType.getIsActive(),
                0, // ridesCount - would need proper query
                BigDecimal.ZERO // totalRevenue - would need proper query
        );
    }

    private PricingAnalyticsDTO.PricingChangeHistoryDTO mapToPricingChangeHistoryDTO(PricingHistory history) {
        PricingAnalyticsDTO.PricingChangeHistoryDTO dto = new PricingAnalyticsDTO.PricingChangeHistoryDTO();
        dto.setId(history.getId());
        dto.setVehicleTypeName(history.getVehicleType().getName());
        dto.setOldBasePrice(history.getOldBasePrice());
        dto.setNewBasePrice(history.getNewBasePrice());
        dto.setOldPricePerKm(history.getOldPricePerKm());
        dto.setNewPricePerKm(history.getNewPricePerKm());
        dto.setChangePercentage(history.getChangePercentage());
        dto.setChangeReason(history.getChangeReason());
        dto.setCreatedAt(history.getCreatedAt());

        // Set admin name
        adminRepository.findById(history.getChangedByAdminId())
                .ifPresent(admin -> dto.setChangedByAdminName(
                        admin.getFirstName() + " " + admin.getLastName()));

        return dto;
    }
}
