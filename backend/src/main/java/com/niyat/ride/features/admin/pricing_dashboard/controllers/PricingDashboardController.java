package com.niyat.ride.features.admin.pricing_dashboard.controllers;

import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

/**
 * DEPRECATED: Pricing Dashboard Controller
 * 
 * This controller has been deprecated in favor of the new Base Price Management system.
 * The old vehicle type pricing system has been replaced with:
 * - Base Price Management: /api/admin/pricing/base-price
 * - Vehicle Type Management: /api/admin/vehicle-types
 * 
 * This class is kept for reference but endpoints are removed.
 * Consider removing this entire package in future cleanup.
 */
@RestController
@RequestMapping("/api/admin/pricing/deprecated")
@RequiredArgsConstructor
@Tag(name = "Deprecated Pricing Dashboard", description = "DEPRECATED - Use Base Price Management instead")
public class PricingDashboardController {

    // All endpoints have been removed - use Base Price Management instead
    // New endpoints:
    // - GET /api/admin/pricing/base-price - Get current base price
    // - PUT /api/admin/pricing/base-price - Update base price
    // - Vehicle type pricing is now handled via /api/admin/vehicle-types
}
