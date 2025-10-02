-- Create lecturers table for chapel attendance tracking
-- Similar structure to students but for academic staff

CREATE TABLE IF NOT EXISTS lecturers (
    id CHAR(36) PRIMARY KEY,
    lecturer_no VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    department VARCHAR(255) NOT NULL,
    faculty VARCHAR(255) NULL,
    phone VARCHAR(20) NULL UNIQUE,
    email VARCHAR(255) NULL,
    position VARCHAR(100) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_lecturer_no (lecturer_no),
    INDEX idx_phone (phone),
    INDEX idx_department (department),
    INDEX idx_faculty (faculty)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create lecturer_attendance table
CREATE TABLE IF NOT EXISTS lecturer_attendance (
    id CHAR(36) PRIMARY KEY,
    service_id CHAR(36) NOT NULL,
    lecturer_id CHAR(36) NOT NULL,
    status ENUM('PRESENT', 'ABSENT') NOT NULL,
    marked_by CHAR(36) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE CASCADE,
    FOREIGN KEY (lecturer_id) REFERENCES lecturers(id) ON DELETE CASCADE,
    FOREIGN KEY (marked_by) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY unique_service_lecturer (service_id, lecturer_id),
    INDEX idx_service (service_id),
    INDEX idx_lecturer (lecturer_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert sample lecturers
INSERT INTO lecturers (id, lecturer_no, name, department, faculty, phone, email, position) VALUES
    (UUID(), 'LEC2025001', 'Dr. Mohamed Kamara', 'Computer Science', 'Engineering & Technology', '+232-78-111111', 'mkamara@university.sl', 'Senior Lecturer'),
    (UUID(), 'LEC2025002', 'Prof. Fatmata Sesay', 'Business Administration', 'Business & Economics', '+232-78-222222', 'fsesay@university.sl', 'Professor'),
    (UUID(), 'LEC2025003', 'Dr. Ibrahim Koroma', 'Civil Engineering', 'Engineering & Technology', '+232-78-333333', 'ikoroma@university.sl', 'Associate Professor'),
    (UUID(), 'LEC2025004', 'Ms. Aminata Bangura', 'Nursing', 'Health Sciences', '+232-78-444444', 'abangura@university.sl', 'Lecturer'),
    (UUID(), 'LEC2025005', 'Dr. Joseph Jalloh', 'Law', 'Law & Political Science', '+232-78-555555', 'jjalloh@university.sl', 'Senior Lecturer');
