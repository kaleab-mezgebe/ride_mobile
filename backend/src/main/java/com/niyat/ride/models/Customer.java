package com.niyat.ride.models;
import com.niyat.ride.enums.AccountStatus;
import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name = "customers")
public class Customer extends User {
}
