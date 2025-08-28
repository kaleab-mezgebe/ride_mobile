package com.niyat.ride.features.admin.user_management.repositories;

import com.niyat.ride.enums.AccountStatus;
import com.niyat.ride.dispatcher.models.Dispatcher;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;

@Repository
public interface DispatcherUserRepository extends JpaRepository<Dispatcher, Long>, JpaSpecificationExecutor<Dispatcher> {
    
    @Query("SELECT d FROM Dispatcher d WHERE " +
           "(:search IS NULL OR " +
           "LOWER(d.firstName) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
           "LOWER(d.lastName) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
           "LOWER(d.email) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
           "LOWER(d.phoneNumber) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
           "LOWER(d.assignedRegion) LIKE LOWER(CONCAT('%', :search, '%'))) AND " +
           "(:status IS NULL OR d.status = :status) AND " +
           "(:createdAtFrom IS NULL OR d.createdAt >= :createdAtFrom) AND " +
           "(:createdAtTo IS NULL OR d.createdAt <= :createdAtTo)")
    Page<Dispatcher> findWithFilters(@Param("search") String search,
                                   @Param("status") AccountStatus status,
                                   @Param("createdAtFrom") LocalDateTime createdAtFrom,
                                   @Param("createdAtTo") LocalDateTime createdAtTo,
                                   Pageable pageable);
}
