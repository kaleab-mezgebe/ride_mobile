package com.niyat.ride.features.admin.support_moderation.dtos;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class ComplaintNoteDTO {
    private Long id;
    private Long adminId;
    private String adminName;
    private String content;
    private Boolean isInternal;
    private LocalDateTime createdAt;
}
