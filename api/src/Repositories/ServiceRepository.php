<?php

namespace Chapel\Repositories;

use Chapel\Exceptions\DatabaseException;

/**
 * ServiceRepository
 *
 * Handles database operations for chapel services
 */
class ServiceRepository extends BaseRepository
{
    protected string $table = 'services';

    /**
     * Find a service by date
     *
     * @param string $date Date in Y-m-d format
     * @return array<string, mixed>|null
     * @throws DatabaseException
     */
    public function findByDate(string $date): ?array
    {
        return $this->queryOne("SELECT * FROM {$this->table} WHERE service_date = ? LIMIT 1", [$date]);
    }

    /**
     * Find services by date range
     *
     * @param string $startDate
     * @param string $endDate
     * @return array<int, array<string, mixed>>
     * @throws DatabaseException
     */
    public function findByDateRange(string $startDate, string $endDate): array
    {
        return $this->query(
            "SELECT * FROM {$this->table}
             WHERE service_date BETWEEN ? AND ?
             ORDER BY service_date DESC",
            [$startDate, $endDate]
        );
    }

    /**
     * Find services by pastor
     *
     * @param string $pastorId
     * @return array<int, array<string, mixed>>
     * @throws DatabaseException
     */
    public function findByPastor(string $pastorId): array
    {
        return $this->query(
            "SELECT * FROM {$this->table}
             WHERE pastor_id = ?
             ORDER BY service_date DESC",
            [$pastorId]
        );
    }

    /**
     * Get services with pastor details
     *
     * @param int $limit
     * @param int $offset
     * @return array<int, array<string, mixed>>
     * @throws DatabaseException
     */
    public function getWithPastorDetails(int $limit = 50, int $offset = 0): array
    {
        return $this->query(
            "SELECT s.*,
                    p.name as pastor_name,
                    p.code as pastor_code
             FROM {$this->table} s
             LEFT JOIN pastors p ON s.pastor_id = p.id
             ORDER BY s.service_date DESC
             LIMIT ? OFFSET ?",
            [$limit, $offset]
        );
    }

    /**
     * Get service with full details (pastor and attendance count)
     *
     * @param string $id
     * @return array<string, mixed>|null
     * @throws DatabaseException
     */
    public function getWithDetails(string $id): ?array
    {
        return $this->queryOne(
            "SELECT s.*,
                    p.name as pastor_name,
                    p.code as pastor_code,
                    COUNT(DISTINCT a.id) as total_attendance,
                    SUM(CASE WHEN a.status = 'PRESENT' THEN 1 ELSE 0 END) as present_count,
                    SUM(CASE WHEN a.status = 'ABSENT' THEN 1 ELSE 0 END) as absent_count
             FROM {$this->table} s
             LEFT JOIN pastors p ON s.pastor_id = p.id
             LEFT JOIN attendance a ON a.service_id = s.id
             WHERE s.id = ?
             GROUP BY s.id",
            [$id]
        );
    }

    /**
     * Get upcoming services
     *
     * @param int $limit
     * @return array<int, array<string, mixed>>
     * @throws DatabaseException
     */
    public function getUpcoming(int $limit = 10): array
    {
        return $this->query(
            "SELECT s.*,
                    p.name as pastor_name,
                    p.code as pastor_code
             FROM {$this->table} s
             LEFT JOIN pastors p ON s.pastor_id = p.id
             WHERE s.service_date >= CURDATE()
             ORDER BY s.service_date ASC
             LIMIT ?",
            [$limit]
        );
    }

    /**
     * Get past services
     *
     * @param int $limit
     * @param int $offset
     * @return array<int, array<string, mixed>>
     * @throws DatabaseException
     */
    public function getPast(int $limit = 50, int $offset = 0): array
    {
        return $this->query(
            "SELECT s.*,
                    p.name as pastor_name,
                    p.code as pastor_code
             FROM {$this->table} s
             LEFT JOIN pastors p ON s.pastor_id = p.id
             WHERE s.service_date < CURDATE()
             ORDER BY s.service_date DESC
             LIMIT ? OFFSET ?",
            [$limit, $offset]
        );
    }

    /**
     * Check if service date exists
     *
     * @param string $date
     * @param string|null $excludeId
     * @return bool
     * @throws DatabaseException
     */
    public function dateExists(string $date, ?string $excludeId = null): bool
    {
        if ($excludeId) {
            $result = $this->queryOne(
                "SELECT 1 FROM {$this->table} WHERE service_date = ? AND id != ? LIMIT 1",
                [$date, $excludeId]
            );
        } else {
            $result = $this->queryOne(
                "SELECT 1 FROM {$this->table} WHERE service_date = ? LIMIT 1",
                [$date]
            );
        }

        return $result !== null;
    }

    /**
     * Get services for a semester
     *
     * @param string $semesterId
     * @return array<int, array<string, mixed>>
     * @throws DatabaseException
     */
    public function getBySemester(string $semesterId): array
    {
        return $this->query(
            "SELECT s.*,
                    p.name as pastor_name,
                    p.code as pastor_code
             FROM {$this->table} s
             LEFT JOIN pastors p ON s.pastor_id = p.id
             INNER JOIN semesters sem ON s.service_date BETWEEN sem.start_date AND sem.end_date
             WHERE sem.id = ?
             ORDER BY s.service_date DESC",
            [$semesterId]
        );
    }
}
