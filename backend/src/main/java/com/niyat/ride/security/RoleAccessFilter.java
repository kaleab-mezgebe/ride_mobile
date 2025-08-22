package com.niyat.ride.security;

import com.fasterxml.jackson.databind.ObjectMapper;
import io.jsonwebtoken.JwtException;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.util.AntPathMatcher;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

@Component
public class RoleAccessFilter extends OncePerRequestFilter {

    private final JwtUtil jwtUtil;
    private final AntPathMatcher matcher = new AntPathMatcher();
    private final ObjectMapper mapper = new ObjectMapper();

    public RoleAccessFilter(JwtUtil jwtUtil) {
        this.jwtUtil = jwtUtil;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {

        String path = request.getRequestURI();

        // Unprotected routes
        if (isUnprotected(path)) {
            filterChain.doFilter(request, response);
            return;
        }

        // Require Authorization header
        String authHeader = request.getHeader("Authorization");
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            writeError(response, HttpStatus.UNAUTHORIZED, "Missing authentication token");
            return;
        }

        String token = authHeader.substring(7);
        String role;
        try {
            // Validate by parsing (JwtUtil will throw on invalid/expired)
            role = jwtUtil.extractRole(token);
            jwtUtil.extractUserId(token); // ensures subject is valid
        } catch (JwtException | IllegalArgumentException ex) {
            writeError(response, HttpStatus.UNAUTHORIZED, "Invalid or expired token");
            return;
        }

        // Role-based checks by path prefix
        if (startsWith(path, "/api/admins/")) {
            if (!"Admin".equals(role)) { // enum name used in project
                writeError(response, HttpStatus.FORBIDDEN, "Forbidden: requires Admin role");
                return;
            }
        } else if (startsWith(path, "/api/dispatchers/")) {
            if (!"DISPATCHER".equals(role)) {
                writeError(response, HttpStatus.FORBIDDEN, "Forbidden: requires DISPATCHER role");
                return;
            }
        } else if (startsWith(path, "/api/customers/")) {
            if (!"CUSTOMER".equals(role)) {
                writeError(response, HttpStatus.FORBIDDEN, "Forbidden: requires CUSTOMER role");
                return;
            }
        } else if (startsWith(path, "/api/drivers/")) {
            if (!"DRIVER".equals(role)) {
                writeError(response, HttpStatus.FORBIDDEN, "Forbidden: requires DRIVER role");
                return;
            }
        } else {
            // Default to 403 for other api paths
            writeError(response, HttpStatus.FORBIDDEN, "Forbidden");
            return;
        }

        filterChain.doFilter(request, response);
    }

    private boolean isUnprotected(String path) {
        return matcher.match("/api/auth/**", path)
                || matcher.match("/swagger-ui/**", path)
                || matcher.match("/v3/api-docs/**", path)
                || matcher.match("/actuator/health", path);
    }

    private boolean startsWith(String path, String prefix) {
        return path != null && path.startsWith(prefix);
    }

    private void writeError(HttpServletResponse response, HttpStatus status, String message) throws IOException {
        response.setStatus(status.value());
        response.setContentType("application/json");
        response.setCharacterEncoding(StandardCharsets.UTF_8.name());
        Map<String, Object> body = new HashMap<>();
        body.put("status", status.value());
        body.put("message", message);
        response.getWriter().write(mapper.writeValueAsString(body));
    }
}
