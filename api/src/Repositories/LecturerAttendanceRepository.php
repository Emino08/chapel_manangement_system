<?php

namespace Chapel\Repositories;

use Chapel\Exceptions\DatabaseException;

/**
 * LecturerAttendanceRepository
 *
 * Handles database operations for lecturer attendance
 */
class LecturerAttendanceRepository extends BaseRepository
{
    protected string $table = 'lecturer_attendance';

    /**
     * Find attendance by service and lecturer
     *
     * @param string $serviceId
     * @param string $lecturerId
     * @return array<string, mixed>|null
     * @throws DatabaseException
     */
    public function findByServiceAndLecturer(string $serviceId, string $lecturerId): ?array
    {
        return $this->queryOne(
            "SELECT * FROM {$this->table} WHERE service_id = ? AND lecturer_id = ? LIMIT 1",
            [$serviceId, $lecturerId]
        );
    }

    /**
     * Get all attendance records for a service
     *
     * @param string $serviceId
     * @return array<int, array<string, mixed>>
     * @throws DatabaseException
     */
    public function getByService(string $serviceId): array
    {
        return $this->query(
            "SELECT la.*, l.lecturer_no, l.name, l.department, l.faculty, l.position
             FROM {$this->table} la
             INNER JOIN lecturers l ON la.lecturer_id = l.id
             WHERE la.service_id = ?
             ORDER BY l.name",
            [$serviceId]
        );
    }

    /**
     * Get all attendance records for a lecturer
     *
     * @param string $lecturerId
     * @return array<int, array<string, mixed>>
     * @throws DatabaseException
     */
    public function getByLecturer(string $lecturerId): array
    {
        return $this->query(
            "SELECT la.*, s.service_date, s.start_time, s.end_time, s.theme
             FROM {$this->table} la
             INNER JOIN services s ON la.service_id = s.id
             WHERE la.lecturer_id = ?
             ORDER BY s.service_date DESC",
            [$lecturerId]
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
        $stats = $this->queryOne(
            "SELECT
                COUNT(*) as total,
                SUM(CASE WHEN status = 'PRESENT' THEN 1 ELSE 0 END) as present,
                SUM(CASE WHEN status = 'ABSENT' THEN 1 ELSE 0 END) as absent
             FROM {$this->table}
             WHERE service_id = ?",
            [$serviceId]
        );

        return [
            'total' => (int) ($stats['total'] ?? 0),
            'present' => (int) ($stats['present'] ?? 0),
            'absent' => (int) ($stats['absent'] ?? 0),
        ];
    }

    /**
     * Get attendance statistics for a lecturer
     *
     * @param string $lecturerId
     * @param string|null $semesterId
     * @return array<string, mixed>
     * @throws DatabaseException
     */
    public function getLecturerStats(string $lecturerId, ?string $semesterId = null): array
    {
        $query = "SELECT
                    COUNT(*) as total_services,
                    SUM(CASE WHEN status = 'PRESENT' THEN 1 ELSE 0 END) as times_attended,
                    SUM(CASE WHEN status = 'ABSENT' THEN 1 ELSE 0 END) as times_absent
                  FROM {$this->table} la
                  INNER JOIN services s ON la.service_id = s.id
                  WHERE la.lecturer_id = ?";

        $params = [$lecturerId];

        if ($semesterId) {
            $query .= " AND s.semester_id = ?";
            $params[] = $semesterId;
        }

        $stats = $this->queryOne($query, $params);

        $totalServices = (int) ($stats['total_services'] ?? 0);
        $timesAttended = (int) ($stats['times_attended'] ?? 0);

        return [
            'total_services' => $totalServices,
            'times_attended' => $timesAttended,
            'times_absent' => (int) ($stats['times_absent'] ?? 0),
            'attendance_rate' => $totalServices > 0 ? round(($timesAttended / $totalServices) * 100, 2) : 0,
        ];
    }

    /**
     * Bulk mark attendance
     *
     * @param string $serviceId
     * @param array<int, array<string, mixed>> $attendanceRecords Array of [{lecturerId, status}]
     * @param string $markedBy User ID
     * @return int Number of records processed
     * @throws DatabaseException
     */
    public function bulkMarkAttendance(string $serviceId, array $attendanceRecords, string $markedBy): int
    {
        try {
            $this->beginTransaction();

            $count = 0;
            foreach ($attendanceRecords as $record) {
                $lecturerId = $record['lecturerId'] ?? null;
                $status = $record['status'] ?? 'PRESENT';

                if (!$lecturerId) {
                    continue;
                }

                // Check if record exists
                $existing = $this->findByServiceAndLecturer($serviceId, $lecturerId);

                if ($existing) {
                    // Update
                    $this->update($existing['id'], [
                        'status' => $status,
                        'marked_by' => $markedBy,
                    ]);
                } else {
                    // Create
                    $attendanceId = \Ramsey\Uuid\Uuid::uuid4()->toString();
                    $this->create([
                        'id' => $attendanceId,
                        'service_id' => $serviceId,
                        'lecturer_id' => $lecturerId,
                        'status' => $status,
                        'marked_by' => $markedBy,
                    ]);
                }

                $count++;
            }

            $this->commit();

            return $count;
        } catch (\Exception $e) {
            $this->rollback();
            throw new DatabaseException("Bulk mark attendance failed: " . $e->getMessage(), $e);
        }
    }

    /**
     * Get semester lecturer attendance report
     *
     * @param string $semesterId
     * @return array<int, array<string, mixed>>
     * @throws DatabaseException
     */
    public function getSemesterReport(string $semesterId): array
    {
        return $this->query(
            "SELECT * FROM v_lecturer_semester_attendance WHERE semester_id = ? ORDER BY lecturer_name",
            [$semesterId]
        );
    }
}
