package com.niyat.ride.features.admin.user_management.repositories;

import com.niyat.ride.enums.AccountStatus;
import com.niyat.ride.admin.models.Admin;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;

@Repository
public interface AdminUserRepository extends JpaRepository<Admin, Long>, JpaSpecificationExecutor<Admin> {
    
    @Query("SELECT a FROM Admin a WHERE " +
           "(:search IS NULL OR " +
           "LOWER(a.firstName) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
           "LOWER(a.lastName) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
           "LOWER(a.email) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
           "LOWER(a.phoneNumber) LIKE LOWER(CONCAT('%', :search, '%'))) AND " +
           "(:status IS NULL OR a.status = :status) AND " +
           "(:createdAtFrom IS NULL OR a.createdAt >= :createdAtFrom) AND " +
           "(:createdAtTo IS NULL OR a.createdAt <= :createdAtTo)")
    Page<Admin> findWithFilters(@Param("search") String search,
                               @Param("status") AccountStatus status,
                               @Param("createdAtFrom") LocalDateTime createdAtFrom,
                               @Param("createdAtTo") LocalDateTime createdAtTo,
                               Pageable pageable);
}
