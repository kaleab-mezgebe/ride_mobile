package com.niyat.ride.features.admin.support_moderation.dtos;

import com.niyat.ride.enums.ComplaintPriority;
import com.niyat.ride.enums.ComplaintStatus;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
public class ComplaintResponseDTO {
    private Long id;
    private Long complainantId;
    private String complainantName;
    private Long rideRequestId;
    private String title;
    private String description;
    private ComplaintStatus status;
    private ComplaintPriority priority;
    private Long assignedToAdminId;
    private String assignedToAdminName;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private LocalDateTime resolvedAt;
    private String resolution;
    private List<ComplaintNoteDTO> notes;
    
    // Ride information if available
    private String rideDetails;
    private String rideStatus;
    private LocalDateTime rideDate;
}
