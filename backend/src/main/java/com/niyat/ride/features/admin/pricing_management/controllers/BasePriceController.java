package com.niyat.ride.features.admin.pricing_management.controllers;

import com.niyat.ride.features.admin.pricing_management.dtos.BasePriceResponseDTO;
import com.niyat.ride.features.admin.pricing_management.dtos.BasePriceUpdateDTO;
import com.niyat.ride.features.admin.pricing_management.services.BasePriceService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/admin/pricing/base-price")
@RequiredArgsConstructor
@Tag(name = "Base Price Management", description = "Admin endpoints for managing base ride price")
public class BasePriceController {
    
    private final BasePriceService basePriceService;
    
    @GetMapping
    @Operation(summary = "Get current base price", description = "Retrieve the current active base price with details")
    public ResponseEntity<BasePriceResponseDTO> getCurrentBasePrice() {
        BasePriceResponseDTO basePrice = basePriceService.getCurrentBasePriceDetails();
        return ResponseEntity.ok(basePrice);
    }
    
    @PutMapping
    @Operation(summary = "Update base price", description = "Update the base price for all rides")
    public ResponseEntity<BasePriceResponseDTO> updateBasePrice(
            @Valid @RequestBody BasePriceUpdateDTO updateDTO,
            @RequestParam Long adminId) {
        
        BasePriceResponseDTO updatedPrice = basePriceService.updateBasePrice(updateDTO, adminId);
        return ResponseEntity.ok(updatedPrice);
    }
}
