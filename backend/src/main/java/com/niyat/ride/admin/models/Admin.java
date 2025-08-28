package com.niyat.ride.admin.models;

import com.niyat.ride.shared.models.User;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@Entity
@Table(name = "admins")
public class Admin extends User {

}