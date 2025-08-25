package com.niyat.ride.features.admin.support_moderation.repositories;

import com.niyat.ride.enums.ComplaintPriority;
import com.niyat.ride.enums.ComplaintStatus;
import com.niyat.ride.features.admin.support_moderation.models.Complaint;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;

@Repository
public interface ComplaintRepository extends JpaRepository<Complaint, Long>, JpaSpecificationExecutor<Complaint> {
    
    @Query("SELECT c FROM Complaint c WHERE " +
           "(:status IS NULL OR c.status = :status) AND " +
           "(:priority IS NULL OR c.priority = :priority) AND " +
           "(:fromDate IS NULL OR c.createdAt >= :fromDate) AND " +
           "(:toDate IS NULL OR c.createdAt <= :toDate) AND " +
           "(:assignedToAdminId IS NULL OR c.assignedToAdminId = :assignedToAdminId)")
    Page<Complaint> findWithFilters(@Param("status") ComplaintStatus status,
                                   @Param("priority") ComplaintPriority priority,
                                   @Param("fromDate") LocalDateTime fromDate,
                                   @Param("toDate") LocalDateTime toDate,
                                   @Param("assignedToAdminId") Long assignedToAdminId,
                                   Pageable pageable);

    @Query("SELECT COUNT(c) FROM Complaint c WHERE c.status = :status")
    Long countByStatus(@Param("status") ComplaintStatus status);

    @Query("SELECT COUNT(c) FROM Complaint c WHERE c.priority = :priority")
    Long countByPriority(@Param("priority") ComplaintPriority priority);
}
