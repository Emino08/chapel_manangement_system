-- Update semester names to First and Second Semester
-- Remove existing semester and create standard semesters

-- Delete the old semester
DELETE FROM semesters WHERE name LIKE '%Fall%' OR name LIKE '%Spring%';

-- Insert First Semester and Second Semester
INSERT INTO semesters (id, name, start_date, end_date, active) VALUES
    (UUID(), 'First Semester', '2025-09-01', '2025-12-20', 1),
    (UUID(), 'Second Semester', '2026-01-15', '2026-05-15', 0);
