package com.niyat.ride.dispatcher.models;

import com.niyat.ride.user.models.User;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@Entity
@Table(name = "dispatchers")
public class Dispatcher extends User {


    private String assignedRegion;
}