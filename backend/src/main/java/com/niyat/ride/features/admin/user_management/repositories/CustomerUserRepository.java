package com.niyat.ride.features.admin.user_management.repositories;

import com.niyat.ride.enums.AccountStatus;
import com.niyat.ride.models.Customer;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;

@Repository
public interface CustomerUserRepository extends JpaRepository<Customer, Long>, JpaSpecificationExecutor<Customer> {
    
    @Query("SELECT c FROM Customer c WHERE " +
           "(:search IS NULL OR " +
           "LOWER(c.firstName) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
           "LOWER(c.lastName) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
           "LOWER(c.email) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
           "LOWER(c.phoneNumber) LIKE LOWER(CONCAT('%', :search, '%'))) AND " +
           "(:status IS NULL OR c.status = :status) AND " +
           "(:createdAtFrom IS NULL OR c.createdAt >= :createdAtFrom) AND " +
           "(:createdAtTo IS NULL OR c.createdAt <= :createdAtTo)")
    Page<Customer> findWithFilters(@Param("search") String search,
                                 @Param("status") AccountStatus status,
                                 @Param("createdAtFrom") LocalDateTime createdAtFrom,
                                 @Param("createdAtTo") LocalDateTime createdAtTo,
                                 Pageable pageable);
}
