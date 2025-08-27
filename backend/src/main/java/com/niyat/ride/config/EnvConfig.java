package com.niyat.ride.config;

import io.github.cdimascio.dotenv.Dotenv;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.Environment;

import jakarta.annotation.PostConstruct;

@Configuration
public class EnvConfig {

    private final Environment springEnvironment;

    public EnvConfig(Environment springEnvironment) {
        this.springEnvironment = springEnvironment;
    }

    @PostConstruct
    public void loadEnv() {
        // Load .env file (only in development, not in production)
        if (!isProduction()) {
            Dotenv dotenv = Dotenv.configure().load();

            // Set system properties from .env file
            dotenv.entries().forEach(entry -> {
                System.setProperty(entry.getKey(), entry.getValue());
            });
        }
    }

    private boolean isProduction() {
        String[] activeProfiles = springEnvironment.getActiveProfiles();
        for (String profile : activeProfiles) {
            if ("prod".equals(profile) || "production".equals(profile)) {
                return true;
            }
        }
        return false;
    }
}