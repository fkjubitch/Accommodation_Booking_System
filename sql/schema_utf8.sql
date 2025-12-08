-- Accommodation Booking System - Database Schema (UTF-8 Safe)
-- Character encoding: UTF-8 (no special characters, ASCII-safe)

-- User table
CREATE TABLE IF NOT EXISTS users (
    user_id BIGSERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    role VARCHAR(20) DEFAULT 'user',
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Site types table
CREATE TABLE IF NOT EXISTS site_types (
    type_id BIGSERIAL PRIMARY KEY,
    type_name VARCHAR(100) NOT NULL,
    base_price DECIMAL(10, 2) NOT NULL,
    max_guests INTEGER NOT NULL,
    description TEXT,
    image_url VARCHAR(255),
    status INTEGER DEFAULT 1
);

-- Sites table
CREATE TABLE IF NOT EXISTS sites (
    site_id BIGSERIAL PRIMARY KEY,
    type_id BIGINT NOT NULL,
    site_no VARCHAR(50) NOT NULL,
    status INTEGER DEFAULT 1,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (type_id) REFERENCES site_types(type_id),
    UNIQUE(type_id, site_no)
);

-- Bookings table
CREATE TABLE IF NOT EXISTS bookings (
    booking_id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    site_id BIGINT NOT NULL,
    type_id BIGINT NOT NULL,
    check_in DATE NOT NULL,
    check_out DATE NOT NULL,
    guest_name VARCHAR(100) NOT NULL,
    guest_phone VARCHAR(20) NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status INTEGER DEFAULT 0,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (site_id) REFERENCES sites(site_id),
    FOREIGN KEY (type_id) REFERENCES site_types(type_id)
);

-- Daily prices table
CREATE TABLE IF NOT EXISTS daily_prices (
    price_id BIGSERIAL PRIMARY KEY,
    site_id BIGINT NOT NULL,
    price_date DATE NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (site_id) REFERENCES sites(site_id),
    UNIQUE(site_id, price_date)
);

-- Equipment table
CREATE TABLE IF NOT EXISTS equipment (
    equip_id BIGSERIAL PRIMARY KEY,
    equip_name VARCHAR(100) NOT NULL,
    equip_desc TEXT,
    price DECIMAL(10, 2) NOT NULL
);

-- Booking equipment table
CREATE TABLE IF NOT EXISTS booking_equips (
    booking_equip_id BIGSERIAL PRIMARY KEY,
    booking_id BIGINT NOT NULL,
    equip_id BIGINT NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 1,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    FOREIGN KEY (equip_id) REFERENCES equipment(equip_id)
);

-- Create indexes for better query performance
CREATE INDEX idx_bookings_user_id ON bookings(user_id);
CREATE INDEX idx_bookings_site_id ON bookings(site_id);
CREATE INDEX idx_bookings_check_in ON bookings(check_in);
CREATE INDEX idx_sites_type_id ON sites(type_id);
