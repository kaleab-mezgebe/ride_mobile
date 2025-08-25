package com.niyat.ride.shared.utils;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;

import java.util.Map;

public class PaginationUtil {

    private static final int DEFAULT_PAGE = 0;
    private static final int DEFAULT_SIZE = 20;
    private static final int MAX_SIZE = 100;

    public static Pageable createPageable(Integer page, Integer size, String sortBy, String sortDirection) {
        int validPage = page != null && page >= 0 ? page : DEFAULT_PAGE;
        int validSize = size != null && size > 0 && size <= MAX_SIZE ? size : DEFAULT_SIZE;
        
        Sort sort = Sort.unsorted();
        if (sortBy != null && !sortBy.trim().isEmpty()) {
            Sort.Direction direction = "desc".equalsIgnoreCase(sortDirection) ? 
                Sort.Direction.DESC : Sort.Direction.ASC;
            sort = Sort.by(direction, sortBy);
        }
        
        return PageRequest.of(validPage, validSize, sort);
    }

    public static <T> Map<String, Object> createPageResponse(Page<T> page) {
        return Map.of(
            "content", page.getContent(),
            "page", Map.of(
                "number", page.getNumber(),
                "size", page.getSize(),
                "totalElements", page.getTotalElements(),
                "totalPages", page.getTotalPages(),
                "first", page.isFirst(),
                "last", page.isLast(),
                "numberOfElements", page.getNumberOfElements()
            )
        );
    }

    public static Map<String, Object> createPageResponse(Page<?> page, Object transformedContent) {
        return Map.of(
            "content", transformedContent,
            "page", Map.of(
                "number", page.getNumber(),
                "size", page.getSize(),
                "totalElements", page.getTotalElements(),
                "totalPages", page.getTotalPages(),
                "first", page.isFirst(),
                "last", page.isLast(),
                "numberOfElements", page.getNumberOfElements()
            )
        );
    }
}
