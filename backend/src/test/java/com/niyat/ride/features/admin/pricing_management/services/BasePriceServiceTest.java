package com.niyat.ride.features.admin.pricing_management.services;

import com.niyat.ride.features.admin.pricing_management.dtos.BasePriceResponseDTO;
import com.niyat.ride.features.admin.pricing_management.dtos.BasePriceUpdateDTO;
import com.niyat.ride.features.admin.pricing_management.models.BasePrice;
import com.niyat.ride.features.admin.pricing_management.repositories.BasePriceRepository;
import com.niyat.ride.user.repositories.AdminRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class BasePriceServiceTest {

    @Mock
    private BasePriceRepository basePriceRepository;
    
    @Mock
    private AdminRepository adminRepository;

    @InjectMocks
    private BasePriceServiceImpl basePriceService;

    private BasePrice mockBasePrice;

    @BeforeEach
    void setUp() {
        mockBasePrice = new BasePrice();
        mockBasePrice.setId(1L);
        mockBasePrice.setAmount(new BigDecimal("100.00"));
        mockBasePrice.setCurrency("ETB");
        mockBasePrice.setIsActive(true);
    }

    @Test
    void getCurrentBasePrice_ShouldReturnActiveBasePrice() {
        // Arrange
        when(basePriceRepository.findByIsActiveTrue()).thenReturn(Optional.of(mockBasePrice));

        // Act
        BasePriceResponseDTO result = basePriceService.getCurrentBasePrice();

        // Assert
        assertNotNull(result);
        assertEquals(new BigDecimal("100.00"), result.getAmount());
        assertEquals("ETB", result.getCurrency());
        assertTrue(result.getIsActive());
    }

    @Test
    void updateBasePrice_ShouldUpdateSuccessfully() {
        // Arrange
        BasePriceUpdateDTO updateDTO = new BasePriceUpdateDTO();
        updateDTO.setAmount(new BigDecimal("120.00"));
        updateDTO.setChangeReason("Price adjustment due to market conditions");
        
        when(basePriceRepository.findByIsActiveTrue()).thenReturn(Optional.of(mockBasePrice));
        when(basePriceRepository.save(any(BasePrice.class))).thenReturn(mockBasePrice);

        // Act
        BasePriceResponseDTO result = basePriceService.updateBasePrice(updateDTO, 1L);

        // Assert
        assertNotNull(result);
        verify(basePriceRepository, times(2)).save(any(BasePrice.class));
    }

    @Test
    void ensureDefaultBasePriceExists_ShouldCreateWhenNoneExists() {
        // Arrange
        when(basePriceRepository.existsByIsActiveTrue()).thenReturn(false);
        when(basePriceRepository.save(any(BasePrice.class))).thenReturn(mockBasePrice);

        // Act
        basePriceService.ensureDefaultBasePriceExists();

        // Assert
        verify(basePriceRepository).save(any(BasePrice.class));
    }
}
