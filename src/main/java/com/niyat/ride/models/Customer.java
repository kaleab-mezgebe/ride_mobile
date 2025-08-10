package com.niyat.ride.models;
import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name = "customers")
public class Customer extends User {
}
