package com.niyat.ride.features.admin.pricing_dashboard.models;

import com.niyat.ride.vehicle.VehicleType;
import jakarta.persistence.*;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@Entity
@Table(name = "pricing_history")
public class PricingHistory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "vehicle_type_id", nullable = false)
    private VehicleType vehicleType;

    @Column(name = "old_base_price", precision = 10, scale = 2)
    private BigDecimal oldBasePrice;

    @Column(name = "new_base_price", precision = 10, scale = 2)
    private BigDecimal newBasePrice;

    @Column(name = "old_price_per_km", precision = 10, scale = 2)
    private BigDecimal oldPricePerKm;

    @Column(name = "new_price_per_km", precision = 10, scale = 2)
    private BigDecimal newPricePerKm;

    @Column(name = "change_reason")
    private String changeReason;

    @Column(name = "changed_by_admin_id", nullable = false)
    private Long changedByAdminId;

    @Column(name = "change_percentage", precision = 5, scale = 2)
    private BigDecimal changePercentage;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt = LocalDateTime.now();
}
