-- Food Waste Management Professional - Database Schema
-- MySQL 8.0+

CREATE DATABASE IF NOT EXISTS food_waste_db;
USE food_waste_db;

-- Food Items Table
CREATE TABLE IF NOT EXISTS food_items (
    item_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    item_name VARCHAR(255) NOT NULL,
    category VARCHAR(100) NOT NULL,
    quantity DECIMAL(10, 2) NOT NULL,
    unit VARCHAR(50) NOT NULL,
    expiry_date DATETIME,
    added_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    location VARCHAR(255),
    status ENUM('AVAILABLE', 'RESERVED', 'DISTRIBUTED', 'DISPOSED') DEFAULT 'AVAILABLE',
    description TEXT,
    quality ENUM('GOOD', 'FAIR', 'POOR'),
    estimated_value DECIMAL(10, 2),
    donor VARCHAR(255),
    last_updated DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_status (status),
    INDEX idx_category (category),
    INDEX idx_expiry_date (expiry_date),
    INDEX idx_added_date (added_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Distribution Centers Table
CREATE TABLE IF NOT EXISTS distribution_centers (
    center_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    center_name VARCHAR(255) NOT NULL UNIQUE,
    address VARCHAR(500) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(255),
    contact_person VARCHAR(255),
    capacity DECIMAL(10, 2),
    location_latitude DECIMAL(10, 8),
    location_longitude DECIMAL(11, 8),
    status ENUM('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Distributions Table
CREATE TABLE IF NOT EXISTS distributions (
    distribution_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    item_id BIGINT NOT NULL,
    center_id BIGINT NOT NULL,
    quantity_distributed DECIMAL(10, 2) NOT NULL,
    distribution_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    recipient_name VARCHAR(255),
    notes TEXT,
    status ENUM('PENDING', 'COMPLETED', 'CANCELLED') DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (item_id) REFERENCES food_items(item_id) ON DELETE CASCADE,
    FOREIGN KEY (center_id) REFERENCES distribution_centers(center_id) ON DELETE RESTRICT,
    INDEX idx_item_id (item_id),
    INDEX idx_center_id (center_id),
    INDEX idx_distribution_date (distribution_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Donors Table
CREATE TABLE IF NOT EXISTS donors (
    donor_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    donor_name VARCHAR(255) NOT NULL UNIQUE,
    contact_person VARCHAR(255),
    phone VARCHAR(20),
    email VARCHAR(255),
    address VARCHAR(500),
    donor_type ENUM('RESTAURANT', 'SUPERMARKET', 'FARM', 'INDIVIDUAL', 'OTHER') NOT NULL,
    status ENUM('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_status (status),
    INDEX idx_donor_type (donor_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Activity Log Table
CREATE TABLE IF NOT EXISTS activity_log (
    log_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    action VARCHAR(100) NOT NULL,
    entity_type VARCHAR(50) NOT NULL,
    entity_id BIGINT,
    user_name VARCHAR(255),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_action (action),
    INDEX idx_entity_type (entity_type),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Reports Table
CREATE TABLE IF NOT EXISTS reports (
    report_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    report_type VARCHAR(100) NOT NULL,
    report_date DATE NOT NULL,
    total_items BIGINT,
    total_quantity DECIMAL(15, 2),
    total_value DECIMAL(15, 2),
    distributed_quantity DECIMAL(15, 2),
    disposed_quantity DECIMAL(15, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_report_type (report_type),
    INDEX idx_report_date (report_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;