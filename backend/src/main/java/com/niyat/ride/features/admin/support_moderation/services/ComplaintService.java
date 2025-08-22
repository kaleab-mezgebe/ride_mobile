package com.niyat.ride.features.admin.support_moderation.services;

import com.niyat.ride.enums.ComplaintPriority;
import com.niyat.ride.enums.ComplaintStatus;
import com.niyat.ride.features.admin.support_moderation.dtos.*;
import org.springframework.data.domain.Page;

import java.time.LocalDateTime;

public interface ComplaintService {
    Page<ComplaintResponseDTO> getAllComplaints(Integer page, Integer size, String sortBy, String sortDirection,
                                              ComplaintStatus status, ComplaintPriority priority, 
                                              LocalDateTime fromDate, LocalDateTime toDate,
                                              Long assignedToAdminId);
    
    ComplaintResponseDTO createComplaint(ComplaintRequestDTO request);
    
    ComplaintResponseDTO getComplaintById(Long id);
    
    ComplaintResponseDTO updateComplaintStatus(Long id, ComplaintStatusDTO statusDTO);
    
    ComplaintResponseDTO updateComplaintPriority(Long id, ComplaintPriority priority);
    
    ComplaintNoteDTO addComplaintNote(Long complaintId, ComplaintNoteRequestDTO noteRequest, Long adminId);
}
