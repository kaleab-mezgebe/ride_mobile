package com.niyat.ride.models;

import com.niyat.ride.enums.AccountStatus;
import com.niyat.ride.enums.Role;
import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@Entity
@Table(name = "users")
@Inheritance(strategy = InheritanceType.JOINED)  // <-- Joined inheritance strategy
public abstract class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String firstName;
    private String lastName;
    private String phoneNumber;

    @Column(unique = true)
    private String email;

    private String password;
    private AccountStatus status;

    @Enumerated(EnumType.STRING)
    private Role role;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

}
