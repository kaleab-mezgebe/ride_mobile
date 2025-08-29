package com.niyat.ride.features.admin.support_moderation.services;

import com.niyat.ride.enums.ComplaintPriority;
import com.niyat.ride.enums.ComplaintStatus;
import com.niyat.ride.features.admin.support_moderation.dtos.*;
import com.niyat.ride.features.admin.support_moderation.models.Complaint;
import com.niyat.ride.features.admin.support_moderation.models.ComplaintNote;
import com.niyat.ride.features.admin.support_moderation.repositories.ComplaintRepository;
import com.niyat.ride.ride.models.RideRequest;
import com.niyat.ride.user.models.User;
import com.niyat.ride.user.repositories.AdminRepository;
import com.niyat.ride.ride.repositories.RideRequestRepository;
import com.niyat.ride.shared.repositories.UserRepository;
import com.niyat.ride.shared.utils.PaginationUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ComplaintServiceImpl implements ComplaintService {

    private final ComplaintRepository complaintRepository;
    private final UserRepository userRepository;
    private final AdminRepository adminRepository;
    private final RideRequestRepository rideRequestRepository;

    @Override
    public Page<ComplaintResponseDTO> getAllComplaints(Integer page, Integer size, String sortBy, String sortDirection,
                                                     ComplaintStatus status, ComplaintPriority priority, 
                                                     LocalDateTime fromDate, LocalDateTime toDate,
                                                     Long assignedToAdminId) {
        Pageable pageable = PaginationUtil.createPageable(page, size, sortBy, sortDirection);
        Page<Complaint> complaintsPage = complaintRepository.findWithFilters(
                status, priority, fromDate, toDate, assignedToAdminId, pageable);
        
        return complaintsPage.map(this::mapToResponseDTO);
    }

    @Override
    @Transactional
    public ComplaintResponseDTO createComplaint(ComplaintRequestDTO request) {
        User complainant = userRepository.findById(request.getComplainantId())
                .orElseThrow(() -> new RuntimeException("Complainant not found with id: " + request.getComplainantId()));

        Complaint complaint = new Complaint();
        complaint.setComplainant(complainant);
        complaint.setTitle(request.getTitle());
        complaint.setDescription(request.getDescription());
        complaint.setPriority(request.getPriority());
        complaint.setAssignedToAdminId(request.getAssignedToAdminId());

        if (request.getRideRequestId() != null) {
            RideRequest rideRequest = rideRequestRepository.findById(request.getRideRequestId())
                    .orElseThrow(() -> new RuntimeException("Ride request not found with id: " + request.getRideRequestId()));
            complaint.setRideRequest(rideRequest);
        }

        Complaint savedComplaint = complaintRepository.save(complaint);
        return mapToResponseDTO(savedComplaint);
    }

    @Override
    public ComplaintResponseDTO getComplaintById(Long id) {
        Complaint complaint = complaintRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Complaint not found with id: " + id));
        return mapToResponseDTO(complaint);
    }

    @Override
    @Transactional
    public ComplaintResponseDTO updateComplaintStatus(Long id, ComplaintStatusDTO statusDTO) {
        Complaint complaint = complaintRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Complaint not found with id: " + id));

        complaint.setStatus(statusDTO.getStatus());
        complaint.setUpdatedAt(LocalDateTime.now());

        if (statusDTO.getStatus() == ComplaintStatus.RESOLVED || statusDTO.getStatus() == ComplaintStatus.CLOSED) {
            complaint.setResolvedAt(LocalDateTime.now());
            if (statusDTO.getResolution() != null) {
                complaint.setResolution(statusDTO.getResolution());
            }
        }

        Complaint updatedComplaint = complaintRepository.save(complaint);
        return mapToResponseDTO(updatedComplaint);
    }

    @Override
    @Transactional
    public ComplaintResponseDTO updateComplaintPriority(Long id, ComplaintPriority priority) {
        Complaint complaint = complaintRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Complaint not found with id: " + id));

        complaint.setPriority(priority);
        complaint.setUpdatedAt(LocalDateTime.now());

        Complaint updatedComplaint = complaintRepository.save(complaint);
        return mapToResponseDTO(updatedComplaint);
    }

    @Override
    @Transactional
    public ComplaintNoteDTO addComplaintNote(Long complaintId, ComplaintNoteRequestDTO noteRequest, Long adminId) {
        Complaint complaint = complaintRepository.findById(complaintId)
                .orElseThrow(() -> new RuntimeException("Complaint not found with id: " + complaintId));

        ComplaintNote note = new ComplaintNote();
        note.setComplaint(complaint);
        note.setAdminId(adminId);
        note.setContent(noteRequest.getContent());
        note.setIsInternal(noteRequest.getIsInternal());

        complaint.getNotes().add(note);
        complaint.setUpdatedAt(LocalDateTime.now());
        
        complaintRepository.save(complaint);

        return mapNoteToDTO(note);
    }

    private ComplaintResponseDTO mapToResponseDTO(Complaint complaint) {
        ComplaintResponseDTO dto = new ComplaintResponseDTO();
        dto.setId(complaint.getId());
        dto.setComplainantId(complaint.getComplainant().getId());
        dto.setComplainantName(complaint.getComplainant().getFirstName() + " " + complaint.getComplainant().getLastName());
        dto.setTitle(complaint.getTitle());
        dto.setDescription(complaint.getDescription());
        dto.setStatus(complaint.getStatus());
        dto.setPriority(complaint.getPriority());
        dto.setAssignedToAdminId(complaint.getAssignedToAdminId());
        dto.setCreatedAt(complaint.getCreatedAt());
        dto.setUpdatedAt(complaint.getUpdatedAt());
        dto.setResolvedAt(complaint.getResolvedAt());
        dto.setResolution(complaint.getResolution());

        // Set assigned admin name
        if (complaint.getAssignedToAdminId() != null) {
            adminRepository.findById(complaint.getAssignedToAdminId())
                    .ifPresent(admin -> dto.setAssignedToAdminName(
                            admin.getFirstName() + " " + admin.getLastName()));
        }

        // Set ride information
        if (complaint.getRideRequest() != null) {
            dto.setRideRequestId(complaint.getRideRequest().getId());
            dto.setRideStatus(complaint.getRideRequest().getStatus().name());
            dto.setRideDate(complaint.getRideRequest().getRequestedAt());
            dto.setRideDetails(String.format("Ride from %s to %s", 
                    complaint.getRideRequest().getPickupAddress() != null ? complaint.getRideRequest().getPickupAddress() : "Unknown",
                    complaint.getRideRequest().getDropoffAddress() != null ? complaint.getRideRequest().getDropoffAddress() : "Unknown"));
        }

        // Map notes
        List<ComplaintNoteDTO> noteDTOs = complaint.getNotes().stream()
                .map(this::mapNoteToDTO)
                .collect(Collectors.toList());
        dto.setNotes(noteDTOs);

        return dto;
    }

    private ComplaintNoteDTO mapNoteToDTO(ComplaintNote note) {
        ComplaintNoteDTO dto = new ComplaintNoteDTO();
        dto.setId(note.getId());
        dto.setAdminId(note.getAdminId());
        dto.setContent(note.getContent());
        dto.setIsInternal(note.getIsInternal());
        dto.setCreatedAt(note.getCreatedAt());

        // Set admin name
        adminRepository.findById(note.getAdminId())
                .ifPresent(admin -> dto.setAdminName(admin.getFirstName() + " " + admin.getLastName()));

        return dto;
    }
}
