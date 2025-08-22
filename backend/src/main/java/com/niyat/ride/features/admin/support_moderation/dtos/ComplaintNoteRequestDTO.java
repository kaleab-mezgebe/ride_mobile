package com.niyat.ride.features.admin.support_moderation.dtos;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class ComplaintNoteRequestDTO {
    @NotBlank(message = "Note content is required")
    private String content;
    
    private Boolean isInternal = true;
}
