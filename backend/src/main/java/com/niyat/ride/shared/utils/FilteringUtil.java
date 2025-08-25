package com.niyat.ride.shared.utils;

import com.niyat.ride.enums.AccountStatus;
import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.Predicate;
import jakarta.persistence.criteria.Root;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class FilteringUtil {

    public static List<Predicate> buildUserFilters(CriteriaBuilder cb, Root<?> root, 
                                                  String search, AccountStatus status, 
                                                  LocalDateTime createdAtFrom, LocalDateTime createdAtTo) {
        List<Predicate> predicates = new ArrayList<>();

        if (StringUtils.hasText(search)) {
            String searchPattern = "%" + search.toLowerCase() + "%";
            Predicate firstNamePredicate = cb.like(cb.lower(root.get("firstName")), searchPattern);
            Predicate lastNamePredicate = cb.like(cb.lower(root.get("lastName")), searchPattern);
            Predicate emailPredicate = cb.like(cb.lower(root.get("email")), searchPattern);
            Predicate phoneNumberPredicate = cb.like(cb.lower(root.get("phoneNumber")), searchPattern);
            
            predicates.add(cb.or(firstNamePredicate, lastNamePredicate, emailPredicate, phoneNumberPredicate));
        }

        if (status != null) {
            predicates.add(cb.equal(root.get("status"), status));
        }

        if (createdAtFrom != null) {
            predicates.add(cb.greaterThanOrEqualTo(root.get("createdAt"), createdAtFrom));
        }

        if (createdAtTo != null) {
            predicates.add(cb.lessThanOrEqualTo(root.get("createdAt"), createdAtTo));
        }

        return predicates;
    }

    public static List<Predicate> buildRideFilters(CriteriaBuilder cb, Root<?> root,
                                                  String status, Long driverId, Long customerId,
                                                  LocalDateTime fromDate, LocalDateTime toDate,
                                                  Double minAmount, Double maxAmount) {
        List<Predicate> predicates = new ArrayList<>();

        if (StringUtils.hasText(status)) {
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
            predicates.add(cb.greaterThanOrEqualTo(root.get("fare"), minAmount));
        }

        if (maxAmount != null) {
            predicates.add(cb.lessThanOrEqualTo(root.get("fare"), maxAmount));
        }

        return predicates;
    }
}
