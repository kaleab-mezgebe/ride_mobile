package com.niyat.ride.features.admin.pricing_management.config;

import com.niyat.ride.features.admin.pricing_management.services.BasePriceService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;

@Slf4j
@Component
@RequiredArgsConstructor
public class BasePriceDataSeeder implements CommandLineRunner {
    
    private final BasePriceService basePriceService;
    
    @Override
    public void run(String... args) throws Exception {
        log.info("Checking if base price initialization is needed...");
        
        try {
            // Try to get current base price - will throw exception if none exists
            basePriceService.getCurrentBasePrice();
            log.info("Base price already exists, skipping initialization");
        } catch (RuntimeException e) {
            // Initialize default base price of 100 ETB
            log.info("Initializing default base price...");
            basePriceService.initializeDefaultBasePriceIfNeeded(new BigDecimal("100.00"));
            log.info("Default base price initialization completed");
        }
    }
}
