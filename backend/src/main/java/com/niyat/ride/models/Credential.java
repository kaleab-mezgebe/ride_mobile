package com.niyat.ride.models;

import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@Entity
@Table(name = "credentials",
        uniqueConstraints = {
                @UniqueConstraint(name = "uk_credential_email", columnNames = "email"),
                @UniqueConstraint(name = "uk_credential_user", columnNames = "user_id")
        })
public class Credential {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String email;

    @Column(nullable = false)
    private String passwordHash;

    @OneToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    private LocalDateTime passwordChangedAt = LocalDateTime.now();

    @Column(nullable = false)
    private Boolean active = true;
}
