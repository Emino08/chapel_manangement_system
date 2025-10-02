<?php

namespace Chapel\Repositories;

use Chapel\Exceptions\DatabaseException;

/**
 * SemesterRepository
 *
 * Handles database operations for semesters
 */
class SemesterRepository extends BaseRepository
{
    protected string $table = 'semesters';

    /**
     * Get the active semester
     *
     * @return array<string, mixed>|null
     * @throws DatabaseException
     */
    public function getActiveSemester(): ?array
    {
        return $this->queryOne("SELECT * FROM {$this->table} WHERE active = 1 LIMIT 1");
    }

    /**
     * Set a semester as active (and deactivate others)
     *
     * @param string $id
     * @return bool
     * @throws DatabaseException
     */
    public function setActive(string $id): bool
    {
        try {
            $this->beginTransaction();

            // Deactivate all semesters
            $this->query("UPDATE {$this->table} SET active = 0");

            // Activate the specified semester
            $result = $this->update($id, ['active' => 1]);

            $this->commit();

            return $result;
        } catch (\Exception $e) {
            $this->rollback();
            throw new DatabaseException("Error setting active semester: " . $e->getMessage(), $e);
        }
    }

    /**
     * Find semesters by date range
     *
     * @param string $date Date in Y-m-d format
     * @return array<int, array<string, mixed>>
     * @throws DatabaseException
     */
    public function findByDate(string $date): array
    {
        return $this->query(
            "SELECT * FROM {$this->table} WHERE ? BETWEEN start_date AND end_date",
            [$date]
        );
    }

    /**
     * Get current semester (based on today's date)
     *
     * @return array<string, mixed>|null
     * @throws DatabaseException
     */
    public function getCurrentSemester(): ?array
    {
        return $this->queryOne(
            "SELECT * FROM {$this->table} WHERE CURDATE() BETWEEN start_date AND end_date LIMIT 1"
        );
    }

    /**
     * Check if date range overlaps with existing semesters
     *
     * @param string $startDate
     * @param string $endDate
     * @param string|null $excludeId
     * @return bool
     * @throws DatabaseException
     */
    public function hasOverlap(string $startDate, string $endDate, ?string $excludeId = null): bool
    {
        $sql = "SELECT 1 FROM {$this->table}
                WHERE (
                    (start_date BETWEEN ? AND ?)
                    OR (end_date BETWEEN ? AND ?)
                    OR (? BETWEEN start_date AND end_date)
                    OR (? BETWEEN start_date AND end_date)
                )";

        $params = [$startDate, $endDate, $startDate, $endDate, $startDate, $endDate];

        if ($excludeId) {
            $sql .= " AND id != ?";
            $params[] = $excludeId;
        }

        $sql .= " LIMIT 1";

        $result = $this->queryOne($sql, $params);

        return $result !== null;
    }

    /**
     * Get semesters ordered by start date (most recent first)
     *
     * @param int $limit
     * @return array<int, array<string, mixed>>
     * @throws DatabaseException
     */
    public function getRecentSemesters(int $limit = 10): array
    {
        return $this->query(
            "SELECT * FROM {$this->table} ORDER BY start_date DESC LIMIT ?",
            [$limit]
        );
    }

    /**
     * Get semester with service count
     *
     * @param string $id
     * @return array<string, mixed>|null
     * @throws DatabaseException
     */
    public function getWithServiceCount(string $id): ?array
    {
        return $this->queryOne(
            "SELECT s.*, COUNT(srv.id) as service_count
             FROM {$this->table} s
             LEFT JOIN services srv ON srv.service_date BETWEEN s.start_date AND s.end_date
             WHERE s.id = ?
             GROUP BY s.id",
            [$id]
        );
    }
}
