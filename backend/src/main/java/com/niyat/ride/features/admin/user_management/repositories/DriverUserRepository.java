package com.niyat.ride.features.admin.user_management.repositories;

import com.niyat.ride.enums.AccountStatus;
import com.niyat.ride.driver.models.Driver;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;

@Repository
public interface DriverUserRepository extends JpaRepository<Driver, Long>, JpaSpecificationExecutor<Driver> {
    
    @Query("SELECT d FROM Driver d WHERE " +
           "(:search IS NULL OR " +
           "LOWER(d.firstName) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
           "LOWER(d.lastName) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
           "LOWER(d.email) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
           "LOWER(d.phoneNumber) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
           "LOWER(d.licenseNumber) LIKE LOWER(CONCAT('%', :search, '%'))) AND " +
           "(:status IS NULL OR d.status = :status) AND " +
           "(:createdAtFrom IS NULL OR d.createdAt >= :createdAtFrom) AND " +
           "(:createdAtTo IS NULL OR d.createdAt <= :createdAtTo)")
    Page<Driver> findWithFilters(@Param("search") String search,
                               @Param("status") AccountStatus status,
                               @Param("createdAtFrom") LocalDateTime createdAtFrom,
                               @Param("createdAtTo") LocalDateTime createdAtTo,
                               Pageable pageable);
}
