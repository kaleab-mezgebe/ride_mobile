package com.niyat.ride.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .csrf(csrf -> csrf.disable())
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/api/customers/**").permitAll()
                        .requestMatchers("/api/drivers/**").permitAll()
                        .requestMatchers("/api/dispatchers/**").permitAll()
                        .requestMatchers("/api/admins/**").permitAll()
                        .requestMatchers("/swagger-ui/**", "/v3/api-docs/**", "/v3/api-docs/public").permitAll()

                        .anyRequest().authenticated()
                );
        return http.build();
    }
}