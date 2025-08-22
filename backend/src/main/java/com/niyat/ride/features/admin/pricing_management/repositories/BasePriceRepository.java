package com.niyat.ride.features.admin.pricing_management.repositories;

import com.niyat.ride.features.admin.pricing_management.models.BasePrice;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface BasePriceRepository extends JpaRepository<BasePrice, Long> {
    
    @Query("SELECT bp FROM BasePrice bp WHERE bp.isActive = true ORDER BY bp.createdAt DESC")
    Optional<BasePrice> findActiveBasePrice();
    
    @Query("SELECT COUNT(bp) > 0 FROM BasePrice bp WHERE bp.isActive = true")
    boolean existsActiveBasePrice();

    // Methods expected by tests
    Optional<BasePrice> findByIsActiveTrue();
    boolean existsByIsActiveTrue();
}
