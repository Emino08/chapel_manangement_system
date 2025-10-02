-- Create view for lecturer semester attendance reports
-- Similar to student attendance view but for lecturers

CREATE OR REPLACE VIEW v_lecturer_semester_attendance AS
SELECT
    s.id as semester_id,
    s.name as semester_name,
    l.id as lecturer_id,
    l.lecturer_no,
    l.name as lecturer_name,
    l.department,
    l.faculty,
    l.position,
    COUNT(DISTINCT CASE WHEN la.status = 'PRESENT' THEN srv.id END) as times_attended,
    COUNT(DISTINCT srv.id) as total_services
FROM semesters s
CROSS JOIN lecturers l
LEFT JOIN services srv ON srv.service_date BETWEEN s.start_date AND s.end_date
LEFT JOIN lecturer_attendance la ON la.service_id = srv.id AND la.lecturer_id = l.id
GROUP BY s.id, s.name, l.id, l.lecturer_no, l.name, l.department, l.faculty, l.position;
