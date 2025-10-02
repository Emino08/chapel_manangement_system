-- Chapel Management System Database Schema
-- MySQL Schema for Chapel Attendance System
-- Port: 4306

-- Drop existing tables if they exist
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS services;
DROP TABLE IF EXISTS semesters;
DROP TABLE IF EXISTS pastors;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS users;
SET FOREIGN_KEY_CHECKS = 1;

-- Users table (Admin, HR, SUO roles)
CREATE TABLE users (
    id CHAR(36) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    role ENUM('ADMIN', 'HR', 'SUO') NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Students table
CREATE TABLE students (
    id CHAR(36) PRIMARY KEY,
    student_no VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    program VARCHAR(255) NOT NULL,
    faculty VARCHAR(255) NULL,
    phone VARCHAR(20) NULL UNIQUE,
    level VARCHAR(50) NULL,
    student_id_card VARCHAR(50) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_student_no (student_no),
    INDEX idx_phone (phone),
    INDEX idx_program (program),
    INDEX idx_faculty (faculty)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Pastors table
CREATE TABLE pastors (
    id CHAR(36) PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    program VARCHAR(255) NULL,
    phone VARCHAR(20) NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_code (code),
    INDEX idx_phone (phone)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Semesters table
CREATE TABLE semesters (
    id CHAR(36) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    active TINYINT(1) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_dates (start_date, end_date),
    INDEX idx_active (active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Services table (Chapel services - default Wednesdays 09:00-12:00)
CREATE TABLE services (
    id CHAR(36) PRIMARY KEY,
    service_date DATE NOT NULL UNIQUE,
    start_time TIME NOT NULL DEFAULT '09:00:00',
    end_time TIME NOT NULL DEFAULT '12:00:00',
    theme VARCHAR(500) NULL,
    pastor_id CHAR(36) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (pastor_id) REFERENCES pastors(id) ON DELETE SET NULL,
    INDEX idx_service_date (service_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Attendance table
CREATE TABLE attendance (
    id CHAR(36) PRIMARY KEY,
    service_id CHAR(36) NOT NULL,
    student_id CHAR(36) NOT NULL,
    status ENUM('PRESENT', 'ABSENT') NOT NULL,
    marked_by CHAR(36) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (marked_by) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY unique_service_student (service_id, student_id),
    INDEX idx_service (service_id),
    INDEX idx_student (student_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Seed initial Admin user
-- Password: Admin#12345 (hashed with PASSWORD_DEFAULT)
-- Note: This hash is for 'Admin#12345'. If you need to reset it, run: php api/bin/fix-admin-password.php
INSERT INTO users (id, name, email, role, password_hash) VALUES (
    UUID(),
    'System Administrator',
    'admin@chapel.local',
    'ADMIN',
    '$2y$10$brnV56BFT5wXMjQuM73YlOkxqv2tPQ5tU7hIuhWh9V/7hk.mLOnc2'
);

-- Create a sample semester covering current date (adjust dates as needed)
INSERT INTO semesters (id, name, start_date, end_date, active) VALUES (
    UUID(),
    'Fall 2025 Semester',
    '2025-09-01',
    '2025-12-20',
    1
);

-- Get the semester ID for service insertion
SET @semester_id = (SELECT id FROM semesters WHERE name = 'Fall 2025 Semester');

-- Insert sample pastors
INSERT INTO pastors (id, code, name, program, phone) VALUES
    (UUID(), 'PST001', 'Rev. John Wesley', 'Theology & Missions', '+232-76-123456'),
    (UUID(), 'PST002', 'Pastor Sarah Johnson', 'Biblical Studies', '+232-76-234567'),
    (UUID(), 'PST003', 'Rev. Michael Brown', 'Church Leadership', '+232-76-345678');

-- Get a sample pastor ID
SET @pastor_id = (SELECT id FROM pastors WHERE code = 'PST001' LIMIT 1);

-- Insert a sample Wednesday service for current/upcoming week
INSERT INTO services (id, service_date, start_time, end_time, theme, pastor_id) VALUES (
    UUID(),
    '2025-10-01',
    '09:00:00',
    '12:00:00',
    'Faith and Excellence in Academic Life',
    @pastor_id
);

-- Insert sample students
INSERT INTO students (id, student_no, name, program, faculty, phone, level) VALUES
    (UUID(), 'S2025001', 'Abdul Rahman Kamara', 'Computer Science', 'Engineering & Technology', '+232-77-111111', 'Year 2'),
    (UUID(), 'S2025002', 'Mariama Sesay', 'Business Administration', 'Business & Economics', '+232-77-222222', 'Year 1'),
    (UUID(), 'S2025003', 'Ibrahim Koroma', 'Civil Engineering', 'Engineering & Technology', '+232-77-333333', 'Year 3'),
    (UUID(), 'S2025004', 'Fatmata Bangura', 'Nursing', 'Health Sciences', '+232-77-444444', 'Year 2'),
    (UUID(), 'S2025005', 'Mohamed Jalloh', 'Law', 'Law & Political Science', '+232-77-555555', 'Year 1'),
    (UUID(), 'S2025006', 'Aminata Conteh', 'Mass Communication', 'Arts & Humanities', '+232-77-666666', 'Year 2'),
    (UUID(), 'S2025007', 'Joseph Mansaray', 'Electrical Engineering', 'Engineering & Technology', '+232-77-777777', 'Year 3'),
    (UUID(), 'S2025008', 'Hawa Turay', 'Economics', 'Business & Economics', '+232-77-888888', 'Year 1'),
    (UUID(), 'S2025009', 'Sahr Kamanda', 'Computer Science', 'Engineering & Technology', '+232-77-999999', 'Year 2'),
    (UUID(), 'S2025010', 'Jenneh Koroma', 'Public Health', 'Health Sciences', '+232-76-111222', 'Year 1'),
    (UUID(), 'S2025011', 'Abubakarr Barrie', 'Accounting', 'Business & Economics', '+232-76-222333', 'Year 3'),
    (UUID(), 'S2025012', 'Isatu Kargbo', 'Social Work', 'Arts & Humanities', '+232-76-333444', 'Year 2'),
    (UUID(), 'S2025013', 'Brima Dumbuya', 'Mechanical Engineering', 'Engineering & Technology', '+232-76-444555', 'Year 3'),
    (UUID(), 'S2025014', 'Kadiatu Bangura', 'Psychology', 'Arts & Humanities', '+232-76-555666', 'Year 1'),
    (UUID(), 'S2025015', 'Alimamy Koroma', 'Information Technology', 'Engineering & Technology', '+232-76-666777', 'Year 2'),
    (UUID(), 'S2025016', 'Zainab Sesay', 'International Relations', 'Law & Political Science', '+232-76-777888', 'Year 1'),
    (UUID(), 'S2025017', 'Foday Mansaray', 'Banking & Finance', 'Business & Economics', '+232-76-888999', 'Year 3'),
    (UUID(), 'S2025018', 'Adama Jalloh', 'Biology', 'Natural Sciences', '+232-76-999000', 'Year 2'),
    (UUID(), 'S2025019', 'Musa Kamara', 'Architecture', 'Engineering & Technology', '+232-75-111222', 'Year 3'),
    (UUID(), 'S2025020', 'Fatu Koroma', 'Mathematics', 'Natural Sciences', '+232-75-222333', 'Year 1');

-- Insert sample attendance records for the service
SET @service_id = (SELECT id FROM services WHERE service_date = '2025-10-01' LIMIT 1);
SET @admin_id = (SELECT id FROM users WHERE email = 'admin@chapel.local' LIMIT 1);

INSERT INTO attendance (id, service_id, student_id, status, marked_by)
SELECT
    UUID(),
    @service_id,
    id,
    IF(RAND() > 0.3, 'PRESENT', 'ABSENT'),
    @admin_id
FROM students
LIMIT 15;

-- Create view for semester attendance reports
CREATE OR REPLACE VIEW v_semester_attendance AS
SELECT
    s.id as semester_id,
    s.name as semester_name,
    st.id as student_id,
    st.student_no,
    st.name as student_name,
    st.program,
    st.faculty,
    st.level,
    COUNT(DISTINCT CASE WHEN a.status = 'PRESENT' THEN srv.id END) as times_attended,
    COUNT(DISTINCT srv.id) as total_services
FROM semesters s
CROSS JOIN students st
LEFT JOIN services srv ON srv.service_date BETWEEN s.start_date AND s.end_date
LEFT JOIN attendance a ON a.service_id = srv.id AND a.student_id = st.id
GROUP BY s.id, s.name, st.id, st.student_no, st.name, st.program, st.faculty, st.level;

-- Verification queries (commented out - for testing)
-- SELECT * FROM users;
-- SELECT * FROM semesters;
-- SELECT * FROM services;
-- SELECT * FROM students LIMIT 10;
-- SELECT * FROM pastors;
-- SELECT * FROM attendance LIMIT 10;
-- SELECT * FROM v_semester_attendance WHERE semester_name = 'Fall 2025 Semester' LIMIT 10;
