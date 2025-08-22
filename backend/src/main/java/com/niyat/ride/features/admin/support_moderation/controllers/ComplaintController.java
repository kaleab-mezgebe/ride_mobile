package com.niyat.ride.features.admin.support_moderation.controllers;

import com.niyat.ride.enums.ComplaintPriority;
import com.niyat.ride.enums.ComplaintStatus;
import com.niyat.ride.features.admin.support_moderation.dtos.*;
import com.niyat.ride.features.admin.support_moderation.services.ComplaintService;
import com.niyat.ride.shared.utils.PaginationUtil;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.time.LocalDateTime;
import java.util.Map;

@RestController
@RequestMapping("/api/admin/complaints")
@RequiredArgsConstructor
@Tag(name = "Complaint Management", description = "Admin endpoints for managing user complaints and disputes")
public class ComplaintController {

    private final ComplaintService complaintService;

    @GetMapping
    @Operation(summary = "Get all complaints with filtering")
    public ResponseEntity<Map<String, Object>> getAllComplaints(
            @RequestParam(defaultValue = "0") Integer page,
            @RequestParam(defaultValue = "20") Integer size,
            @RequestParam(defaultValue = "createdAt") String sortBy,
            @RequestParam(defaultValue = "desc") String sortDirection,
            @RequestParam(required = false) ComplaintStatus status,
            @RequestParam(required = false) ComplaintPriority priority,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime fromDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime toDate,
            @RequestParam(required = false) Long assignedToAdminId) {

        Page<ComplaintResponseDTO> complaintsPage = complaintService.getAllComplaints(
                page, size, sortBy, sortDirection, status, priority, fromDate, toDate, assignedToAdminId);

        return ResponseEntity.ok(PaginationUtil.createPageResponse(complaintsPage));
    }

    @PostMapping
    @Operation(summary = "Create a new complaint")
    public ResponseEntity<ComplaintResponseDTO> createComplaint(
            @Valid @RequestBody ComplaintRequestDTO request) {
        ComplaintResponseDTO complaint = complaintService.createComplaint(request);
        return ResponseEntity.created(URI.create("/api/admin/complaints/" + complaint.getId()))
                .body(complaint);
    }

    @GetMapping("/{id}")
    @Operation(summary = "Get complaint details by ID")
    public ResponseEntity<ComplaintResponseDTO> getComplaintById(@PathVariable Long id) {
        ComplaintResponseDTO complaint = complaintService.getComplaintById(id);
        return ResponseEntity.ok(complaint);
    }

    @PatchMapping("/{id}/status")
    @Operation(summary = "Update complaint status")
    public ResponseEntity<ComplaintResponseDTO> updateComplaintStatus(
            @PathVariable Long id,
            @Valid @RequestBody ComplaintStatusDTO statusDTO) {
        ComplaintResponseDTO complaint = complaintService.updateComplaintStatus(id, statusDTO);
        return ResponseEntity.ok(complaint);
    }

    @PatchMapping("/{id}/priority")
    @Operation(summary = "Update complaint priority")
    public ResponseEntity<ComplaintResponseDTO> updateComplaintPriority(
            @PathVariable Long id,
            @RequestParam ComplaintPriority priority) {
        ComplaintResponseDTO complaint = complaintService.updateComplaintPriority(id, priority);
        return ResponseEntity.ok(complaint);
    }

    @PostMapping("/{id}/notes")
    @Operation(summary = "Add internal note to complaint")
    public ResponseEntity<ComplaintNoteDTO> addComplaintNote(
            @PathVariable Long id,
            @Valid @RequestBody ComplaintNoteRequestDTO noteRequest,
            @RequestParam Long adminId) {
        ComplaintNoteDTO note = complaintService.addComplaintNote(id, noteRequest, adminId);
        return ResponseEntity.ok(note);
    }
}
