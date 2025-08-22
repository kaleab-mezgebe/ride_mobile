-- Enable PostGIS extension for spatial data support
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS postgis_topology;

-- Create spatial indexes for performance optimization
-- These will be created automatically when the tables are created by Hibernate
