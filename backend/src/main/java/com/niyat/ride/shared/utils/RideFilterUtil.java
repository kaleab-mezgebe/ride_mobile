package com.niyat.ride.shared.utils;

import com.niyat.ride.enums.RideStatus;
import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.Predicate;
import jakarta.persistence.criteria.Root;
import org.springframework.util.StringUtils;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class RideFilterUtil {

    public static List<Predicate> buildRideFilters(CriteriaBuilder cb, Root<?> root,
                                                  RideStatus status, Long driverId, Long customerId,
                                                  LocalDateTime fromDate, LocalDateTime toDate,
                                                  BigDecimal minAmount, BigDecimal maxAmount) {
        List<Predicate> predicates = new ArrayList<>();

        if (status != null) {
            predicates.add(cb.equal(root.get("status"), status));
        }

        if (driverId != null) {
            predicates.add(cb.equal(root.get("driverId"), driverId));
        }

        if (customerId != null) {
            predicates.add(cb.equal(root.get("passengerId"), customerId));
        }

        if (fromDate != null) {
            predicates.add(cb.greaterThanOrEqualTo(root.get("requestedAt"), fromDate));
        }

        if (toDate != null) {
            predicates.add(cb.lessThanOrEqualTo(root.get("requestedAt"), toDate));
        }

        if (minAmount != null) {
            predicates.add(cb.greaterThanOrEqualTo(root.get("finalCost"), minAmount));
        }

        if (maxAmount != null) {
            predicates.add(cb.lessThanOrEqualTo(root.get("finalCost"), maxAmount));
        }

        return predicates;
    }
}
