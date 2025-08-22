-- Create spatial indexes for optimal geospatial query performance

-- Index for driver current locations
CREATE INDEX IF NOT EXISTS idx_drivers_current_location 
ON drivers USING GIST (current_location);

-- Index for ride pickup locations
CREATE INDEX IF NOT EXISTS idx_ride_requests_pickup_location 
ON ride_requests USING GIST (pickup_location);

-- Index for ride dropoff locations
CREATE INDEX IF NOT EXISTS idx_ride_requests_dropoff_location 
ON ride_requests USING GIST (dropoff_location);

-- Composite indexes for common queries
CREATE INDEX IF NOT EXISTS idx_drivers_online_location 
ON drivers (is_online) 
WHERE is_online = true;

CREATE INDEX IF NOT EXISTS idx_ride_requests_status_driver 
ON ride_requests (status, driver_id);

-- Service area boundary (Addis Ababa approximate polygon)
-- This creates a polygon covering Addis Ababa for service area validation
CREATE TABLE IF NOT EXISTS service_areas (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    boundary GEOMETRY(POLYGON, 4326) NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert Addis Ababa service area
INSERT INTO service_areas (name, boundary) VALUES (
    'Addis Ababa',
    ST_GeomFromText('POLYGON((38.6 8.8, 39.0 8.8, 39.0 9.2, 38.6 9.2, 38.6 8.8))', 4326)
) ON CONFLICT DO NOTHING;
