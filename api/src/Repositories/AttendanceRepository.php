<?php

namespace Chapel\Repositories;

use Chapel\Exceptions\DatabaseException;

/**
 * AttendanceRepository
 *
 * Handles database operations for attendance records
 */
class AttendanceRepository extends BaseRepository
{
    protected string $table = 'attendance';

    /**
     * Find attendance by service and student
     *
     * @param string $serviceId
     * @param string $studentId
     * @return array<string, mixed>|null
     * @throws DatabaseException
     */
    public function findByServiceAndStudent(string $serviceId, string $studentId): ?array
    {
        return $this->queryOne(
            "SELECT * FROM {$this->table} WHERE service_id = ? AND student_id = ? LIMIT 1",
            [$serviceId, $studentId]
        );
    }

    /**
     * Get all attendance for a service
     *
     * @param string $serviceId
     * @return array<int, array<string, mixed>>
     * @throws DatabaseException
     */
    public function getByService(string $serviceId): array
    {
        return $this->query(
            "SELECT a.*,
                    s.name as student_name,
                    s.student_no,
                    s.program,
                    s.faculty,
                    s.level
             FROM {$this->table} a
             INNER JOIN students s ON a.student_id = s.id
             WHERE a.service_id = ?
             ORDER BY s.name",
            [$serviceId]
        );
    }

    /**
     * Get all attendance for a student
     *
     * @param string $studentId
     * @return array<int, array<string, mixed>>
     * @throws DatabaseException
     */
    public function getByStudent(string $studentId): array
    {
        return $this->query(
            "SELECT a.*,
                    srv.service_date,
                    srv.theme,
                    p.name as pastor_name
             FROM {$this->table} a
             INNER JOIN services srv ON a.service_id = srv.id
             LEFT JOIN pastors p ON srv.pastor_id = p.id
             WHERE a.student_id = ?
             ORDER BY srv.service_date DESC",
            [$studentId]
        );
    }

    /**
     * Get attendance statistics for a service
     *
     * @param string $serviceId
     * @return array<string, mixed>
     * @throws DatabaseException
     */
    public function getServiceStats(string $serviceId): array
    {
        $result = $this->queryOne(
            "SELECT
                COUNT(*) as total,
                SUM(CASE WHEN status = 'PRESENT' THEN 1 ELSE 0 END) as present,
                SUM(CASE WHEN status = 'ABSENT' THEN 1 ELSE 0 END) as absent
             FROM {$this->table}
             WHERE service_id = ?",
            [$serviceId]
        );

        return $result ?? [
            'total' => 0,
            'present' => 0,
            'absent' => 0,
        ];
    }

    /**
     * Get attendance statistics for a student
     *
     * @param string $studentId
     * @param string|null $semesterId
     * @return array<string, mixed>
     * @throws DatabaseException
     */
    public function getStudentStats(string $studentId, ?string $semesterId = null): array
    {
        if ($semesterId) {
            $result = $this->queryOne(
                "SELECT
                    COUNT(*) as total,
                    SUM(CASE WHEN a.status = 'PRESENT' THEN 1 ELSE 0 END) as present,
                    SUM(CASE WHEN a.status = 'ABSENT' THEN 1 ELSE 0 END) as absent
                 FROM {$this->table} a
                 INNER JOIN services srv ON a.service_id = srv.id
                 INNER JOIN semesters sem ON srv.service_date BETWEEN sem.start_date AND sem.end_date
                 WHERE a.student_id = ? AND sem.id = ?",
                [$studentId, $semesterId]
            );
        } else {
            $result = $this->queryOne(
                "SELECT
                    COUNT(*) as total,
                    SUM(CASE WHEN status = 'PRESENT' THEN 1 ELSE 0 END) as present,
                    SUM(CASE WHEN status = 'ABSENT' THEN 1 ELSE 0 END) as absent
                 FROM {$this->table}
                 WHERE student_id = ?",
                [$studentId]
            );
        }

        return $result ?? [
            'total' => 0,
            'present' => 0,
            'absent' => 0,
        ];
    }

    /**
     * Mark attendance for multiple students
     *
     * @param string $serviceId
     * @param array<int, array{student_id: string, status: string}> $attendanceRecords
     * @param string $markedBy
     * @return int Number of records created/updated
     * @throws DatabaseException
     */
    public function bulkMarkAttendance(string $serviceId, array $attendanceRecords, string $markedBy): int
    {
        if (empty($attendanceRecords)) {
            return 0;
        }

        try {
            $this->beginTransaction();

            $count = 0;
            foreach ($attendanceRecords as $record) {
                $existing = $this->findByServiceAndStudent($serviceId, $record['student_id']);

                if ($existing) {
                    $this->update($existing['id'], [
                        'status' => $record['status'],
                        'marked_by' => $markedBy,
                    ]);
                } else {
                    $this->create([
                        'id' => \Ramsey\Uuid\Uuid::uuid4()->toString(),
                        'service_id' => $serviceId,
                        'student_id' => $record['student_id'],
                        'status' => $record['status'],
                        'marked_by' => $markedBy,
                    ]);
                }
                $count++;
            }

            $this->commit();

            return $count;
        } catch (\Exception $e) {
            $this->rollback();
            throw new DatabaseException("Bulk attendance marking failed: " . $e->getMessage(), $e);
        }
    }

    /**
     * Get semester attendance report
     *
     * @param string $semesterId
     * @return array<int, array<string, mixed>>
     * @throws DatabaseException
     */
    public function getSemesterReport(string $semesterId): array
    {
        return $this->query(
            "SELECT * FROM v_semester_attendance WHERE semester_id = ? ORDER BY student_name",
            [$semesterId]
        );
    }

    /**
     * Get attendance by program for a service
     *
     * @param string $serviceId
     * @return array<int, array<string, mixed>>
     * @throws DatabaseException
     */
    public function getServiceAttendanceByProgram(string $serviceId): array
    {
        return $this->query(
            "SELECT
                s.program,
                COUNT(*) as total,
                SUM(CASE WHEN a.status = 'PRESENT' THEN 1 ELSE 0 END) as present,
                SUM(CASE WHEN a.status = 'ABSENT' THEN 1 ELSE 0 END) as absent
             FROM {$this->table} a
             INNER JOIN students s ON a.student_id = s.id
             WHERE a.service_id = ?
             GROUP BY s.program
             ORDER BY s.program",
            [$serviceId]
        );
    }

    /**
     * Get attendance by faculty for a service
     *
     * @param string $serviceId
     * @return array<int, array<string, mixed>>
     * @throws DatabaseException
     */
    public function getServiceAttendanceByFaculty(string $serviceId): array
    {
        return $this->query(
            "SELECT
                s.faculty,
                COUNT(*) as total,
                SUM(CASE WHEN a.status = 'PRESENT' THEN 1 ELSE 0 END) as present,
                SUM(CASE WHEN a.status = 'ABSENT' THEN 1 ELSE 0 END) as absent
             FROM {$this->table} a
             INNER JOIN students s ON a.student_id = s.id
             WHERE a.service_id = ?
             GROUP BY s.faculty
             ORDER BY s.faculty",
            [$serviceId]
        );
    }

    /**
     * Check if attendance exists for service and student
     *
     * @param string $serviceId
     * @param string $studentId
     * @return bool
     * @throws DatabaseException
     */
    public function attendanceExists(string $serviceId, string $studentId): bool
    {
        $result = $this->queryOne(
            "SELECT 1 FROM {$this->table} WHERE service_id = ? AND student_id = ? LIMIT 1",
            [$serviceId, $studentId]
        );

        return $result !== null;
    }
}
