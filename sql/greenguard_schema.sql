-- ============================================================
-- GreenGuard - Citizen Environmental Monitoring Network
-- Database Schema (MySQL)
-- ============================================================

CREATE DATABASE IF NOT EXISTS greenguard_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE greenguard_db;

-- ============================================================
-- USERS
-- ============================================================
CREATE TABLE users (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    full_name     VARCHAR(100)  NOT NULL,
    email         VARCHAR(150)  NOT NULL UNIQUE,
    phone         VARCHAR(20),
    password_hash VARCHAR(64)   NOT NULL,   -- SHA-256 hex
    role          ENUM('CITIZEN','AUTHORITY','ADMIN') NOT NULL DEFAULT 'CITIZEN',
    status        ENUM('PENDING','ACTIVE','SUSPENDED') NOT NULL DEFAULT 'PENDING',
    avatar_url    VARCHAR(255),
    created_at    DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Seed admin account (password: Admin@1234)
INSERT INTO users (full_name, email, password_hash, role, status)
VALUES ('System Admin', 'admin@greenguard.np',
        'a4e8b2c1f3d6e9a0b2c5d8f1e4a7b0c3d6e9f2a5b8c1d4e7f0a3b6c9d2e5f8a1', 'ADMIN', 'ACTIVE');

-- ============================================================
-- VIOLATIONS
-- ============================================================
CREATE TABLE violations (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    reporter_id   INT           NOT NULL,
    type          ENUM('ILLEGAL_DUMPING','WATER_POLLUTION','AIR_POLLUTION',
                       'DEFORESTATION','NOISE_POLLUTION','SOIL_CONTAMINATION','OTHER') NOT NULL,
    title         VARCHAR(200)  NOT NULL,
    description   TEXT          NOT NULL,
    location_name VARCHAR(255)  NOT NULL,
    latitude      DECIMAL(10,7),
    longitude     DECIMAL(10,7),
    photo_url     VARCHAR(255),
    severity      ENUM('LOW','MEDIUM','HIGH','CRITICAL') NOT NULL DEFAULT 'MEDIUM',
    status        ENUM('SUBMITTED','UNDER_REVIEW','IN_PROGRESS','RESOLVED','CLOSED','REJECTED') NOT NULL DEFAULT 'SUBMITTED',
    is_hotspot    TINYINT(1)    NOT NULL DEFAULT 0,
    created_at    DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (reporter_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ============================================================
-- ENFORCEMENT CASES
-- ============================================================
CREATE TABLE enforcement_cases (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    violation_id  INT           NOT NULL,
    authority_id  INT           NOT NULL,
    status        ENUM('ASSIGNED','INVESTIGATING','ACTION_TAKEN','RESOLVED','ESCALATED') NOT NULL DEFAULT 'ASSIGNED',
    notes         TEXT,
    action_taken  TEXT,
    assigned_at   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    resolved_at   DATETIME,
    FOREIGN KEY (violation_id) REFERENCES violations(id) ON DELETE CASCADE,
    FOREIGN KEY (authority_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ============================================================
-- CASE TIMELINE
-- ============================================================
CREATE TABLE case_timeline (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    case_id       INT           NOT NULL,
    actor_id      INT           NOT NULL,
    action        VARCHAR(200)  NOT NULL,
    details       TEXT,
    created_at    DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (case_id)  REFERENCES enforcement_cases(id) ON DELETE CASCADE,
    FOREIGN KEY (actor_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ============================================================
-- GREEN MONITOR APPLICATIONS
-- ============================================================
CREATE TABLE monitor_applications (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    user_id       INT           NOT NULL UNIQUE,
    motivation    TEXT          NOT NULL,
    experience    TEXT,
    status        ENUM('PENDING','APPROVED','REJECTED') NOT NULL DEFAULT 'PENDING',
    reviewed_by   INT,
    review_notes  TEXT,
    applied_at    DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    reviewed_at   DATETIME,
    FOREIGN KEY (user_id)     REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (reviewed_by) REFERENCES users(id) ON DELETE SET NULL
);

-- ============================================================
-- CERTIFIED MONITORS
-- ============================================================
CREATE TABLE certified_monitors (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    user_id       INT           NOT NULL UNIQUE,
    tier          ENUM('BRONZE','SILVER','GOLD') NOT NULL DEFAULT 'BRONZE',
    report_count  INT           NOT NULL DEFAULT 0,
    certified_at  DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ============================================================
-- WATCHLIST AREAS
-- ============================================================
CREATE TABLE watchlist_areas (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    user_id       INT           NOT NULL,
    area_name     VARCHAR(200)  NOT NULL,
    latitude      DECIMAL(10,7) NOT NULL,
    longitude     DECIMAL(10,7) NOT NULL,
    radius_km     DECIMAL(5,2)  NOT NULL DEFAULT 5.00,
    created_at    DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY uq_user_area (user_id, area_name)
);

-- ============================================================
-- NOTIFICATIONS
-- ============================================================
CREATE TABLE notifications (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    user_id       INT           NOT NULL,
    title         VARCHAR(200)  NOT NULL,
    message       TEXT          NOT NULL,
    is_read       TINYINT(1)    NOT NULL DEFAULT 0,
    link_url      VARCHAR(255),
    created_at    DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ============================================================
-- INDEXES
-- ============================================================
CREATE INDEX idx_violations_status    ON violations(status);
CREATE INDEX idx_violations_type      ON violations(type);
CREATE INDEX idx_violations_reporter  ON violations(reporter_id);
CREATE INDEX idx_violations_hotspot   ON violations(is_hotspot);
CREATE INDEX idx_cases_authority      ON enforcement_cases(authority_id);
CREATE INDEX idx_cases_violation      ON enforcement_cases(violation_id);
CREATE INDEX idx_notifications_user   ON notifications(user_id, is_read);
