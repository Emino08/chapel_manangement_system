<?php

namespace Chapel\Repositories;

use Chapel\Exceptions\DatabaseException;

/**
 * PastorRepository
 *
 * Handles database operations for pastors
 */
class PastorRepository extends BaseRepository
{
    protected string $table = 'pastors';

    /**
     * Find a pastor by code
     *
     * @param string $code
     * @return array<string, mixed>|null
     * @throws DatabaseException
     */
    public function findByCode(string $code): ?array
    {
        return $this->queryOne("SELECT * FROM {$this->table} WHERE code = ? LIMIT 1", [$code]);
    }

    /**
     * Find a pastor by phone number
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
     * Search pastors by name or code
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
             WHERE name LIKE ? OR code LIKE ?
             ORDER BY name
             LIMIT ? OFFSET ?",
            [$searchPattern, $searchPattern, $limit, $offset]
        );
    }

    /**
     * Check if pastor code exists
     *
     * @param string $code
     * @param string|null $excludeId
     * @return bool
     * @throws DatabaseException
     */
    public function codeExists(string $code, ?string $excludeId = null): bool
    {
        if ($excludeId) {
            $result = $this->queryOne(
                "SELECT 1 FROM {$this->table} WHERE code = ? AND id != ? LIMIT 1",
                [$code, $excludeId]
            );
        } else {
            $result = $this->queryOne(
                "SELECT 1 FROM {$this->table} WHERE code = ? LIMIT 1",
                [$code]
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
     * Get pastors with service count
     *
     * @return array<int, array<string, mixed>>
     * @throws DatabaseException
     */
    public function getPastorsWithServiceCount(): array
    {
        return $this->query(
            "SELECT p.*, COUNT(s.id) as service_count
             FROM {$this->table} p
             LEFT JOIN services s ON s.pastor_id = p.id
             GROUP BY p.id
             ORDER BY p.name"
        );
    }
}
