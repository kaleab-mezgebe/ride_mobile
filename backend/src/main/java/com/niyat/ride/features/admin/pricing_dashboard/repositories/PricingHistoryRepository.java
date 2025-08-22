package com.niyat.ride.features.admin.pricing_dashboard.repositories;

import com.niyat.ride.features.admin.pricing_dashboard.models.PricingHistory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface PricingHistoryRepository extends JpaRepository<PricingHistory, Long> {
    
    @Query("SELECT ph FROM PricingHistory ph ORDER BY ph.createdAt DESC")
    Page<PricingHistory> findAllOrderByCreatedAtDesc(Pageable pageable);
    
    @Query("SELECT ph FROM PricingHistory ph WHERE ph.vehicleType.id = :vehicleTypeId ORDER BY ph.createdAt DESC")
    List<PricingHistory> findByVehicleTypeIdOrderByCreatedAtDesc(@Param("vehicleTypeId") Long vehicleTypeId);
    
    @Query("SELECT ph FROM PricingHistory ph WHERE ph.createdAt >= :fromDate ORDER BY ph.createdAt DESC")
    List<PricingHistory> findRecentChanges(@Param("fromDate") LocalDateTime fromDate);
}
