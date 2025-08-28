package com.niyat.ride.customer.models;
import com.niyat.ride.shared.models.User;
import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@Entity
@Table(name = "customers")
@EqualsAndHashCode(callSuper = false)
public class Customer extends User {
}
