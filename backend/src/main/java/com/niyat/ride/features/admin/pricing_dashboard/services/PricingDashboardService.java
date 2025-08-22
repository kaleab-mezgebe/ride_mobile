package com.niyat.ride.features.admin.pricing_dashboard.services;

import com.niyat.ride.features.admin.pricing_dashboard.dtos.PricingAnalyticsDTO;
import com.niyat.ride.features.admin.pricing_dashboard.dtos.PricingOverviewDTO;
import com.niyat.ride.features.admin.pricing_dashboard.dtos.PriceIncreaseRequestDTO;

import java.util.List;

public interface PricingDashboardService {
    
    PricingOverviewDTO getPricingOverview();
    
    PricingAnalyticsDTO getPricingAnalytics();
    
    List<String> applyPriceIncrease(PriceIncreaseRequestDTO request, Long adminId);
}
