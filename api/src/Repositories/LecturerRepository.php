<?php

namespace Chapel\Repositories;

use Chapel\Exceptions\DatabaseException;

/**
 * LecturerRepository
 *
 * Handles database operations for lecturers
 */
class LecturerRepository extends BaseRepository
{
    protected string $table = 'lecturers';

    /**
     * Find a lecturer by lecturer number
     *
     * @param string $lecturerNo
     * @return array<string, mixed>|null
     * @throws DatabaseException
     */
    public function findByLecturerNo(string $lecturerNo): ?array
    {
        return $this->queryOne("SELECT * FROM {$this->table} WHERE lecturer_no = ? LIMIT 1", [$lecturerNo]);
    }

    /**
     * Find a lecturer by phone number
     *
     * @param string $phone
     * @return array<string, mixed>|null
     * @throws DatabaseException
     */
    public function findByPhone(string $phone): ?array
    {
        return $this->queryOne("SELECT * FROM {$this->table} WHERE phone = ? LIMIT 1", [$phone]);
    }

    /**
     * Search lecturers by name, lecturer number, or department
     *
     * @param string $searchTerm
     * @param int $limit
     * @param int $offset
     * @return array<int, array<string, mixed>>
     * @throws DatabaseException
     */
    public function search(string $searchTerm, int $limit = 50, int $offset = 0): array
    {
        $searchPattern = '%' . $searchTerm . '%';

        return $this->query(
            "SELECT * FROM {$this->table}
             WHERE name LIKE ? OR lecturer_no LIKE ? OR department LIKE ?
             ORDER BY name
             LIMIT ? OFFSET ?",
            [$searchPattern, $searchPattern, $searchPattern, $limit, $offset]
        );
    }

    /**
     * Find lecturers by department
     *
     * @param string $department
     * @return array<int, array<string, mixed>>
     * @throws DatabaseException
     */
    public function findByDepartment(string $department): array
    {
        return $this->query("SELECT * FROM {$this->table} WHERE department = ? ORDER BY name", [$department]);
    }

    /**
     * Find lecturers by faculty
     *
     * @param string $faculty
     * @return array<int, array<string, mixed>>
     * @throws DatabaseException
     */
    public function findByFaculty(string $faculty): array
    {
        return $this->query("SELECT * FROM {$this->table} WHERE faculty = ? ORDER BY name", [$faculty]);
    }

    /**
     * Check if lecturer number exists
     *
     * @param string $lecturerNo
     * @param string|null $excludeId
     * @return bool
     * @throws DatabaseException
     */
    public function lecturerNoExists(string $lecturerNo, ?string $excludeId = null): bool
    {
        if ($excludeId) {
            $result = $this->queryOne(
                "SELECT 1 FROM {$this->table} WHERE lecturer_no = ? AND id != ? LIMIT 1",
                [$lecturerNo, $excludeId]
            );
        } else {
            $result = $this->queryOne(
                "SELECT 1 FROM {$this->table} WHERE lecturer_no = ? LIMIT 1",
                [$lecturerNo]
            );
        }

        return $result !== null;
    }

    /**
     * Check if phone exists
     *
     * @param string $phone
     * @param string|null $excludeId
     * @return bool
     * @throws DatabaseException
     */
    public function phoneExists(string $phone, ?string $excludeId = null): bool
    {
        if ($excludeId) {
            $result = $this->queryOne(
                "SELECT 1 FROM {$this->table} WHERE phone = ? AND id != ? LIMIT 1",
                [$phone, $excludeId]
            );
        } else {
            $result = $this->queryOne(
                "SELECT 1 FROM {$this->table} WHERE phone = ? LIMIT 1",
                [$phone]
            );
        }

        return $result !== null;
    }

    /**
     * Get all unique departments
     *
     * @return array<int, string>
     * @throws DatabaseException
     */
    public function getAllDepartments(): array
    {
        $results = $this->query("SELECT DISTINCT department FROM {$this->table} WHERE department IS NOT NULL ORDER BY department");

        return array_column($results, 'department');
    }

    /**
     * Get all unique faculties
     *
     * @return array<int, string>
     * @throws DatabaseException
     */
    public function getAllFaculties(): array
    {
        $results = $this->query("SELECT DISTINCT faculty FROM {$this->table} WHERE faculty IS NOT NULL ORDER BY faculty");

        return array_column($results, 'faculty');
    }

    /**
     * Bulk insert lecturers
     *
     * @param array<int, array<string, mixed>> $lecturers
     * @return int Number of inserted records
     * @throws DatabaseException
     */
    public function bulkInsert(array $lecturers): int
    {
        if (empty($lecturers)) {
            return 0;
        }

        try {
            $this->beginTransaction();

            $inserted = 0;
            foreach ($lecturers as $lecturer) {
                $this->create($lecturer);
                $inserted++;
            }

            $this->commit();

            return $inserted;
        } catch (\Exception $e) {
            $this->rollback();
            throw new DatabaseException("Bulk insert failed: " . $e->getMessage(), $e);
        }
    }
}
