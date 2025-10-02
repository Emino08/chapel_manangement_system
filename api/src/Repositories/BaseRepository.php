<?php

namespace Chapel\Repositories;

use Chapel\Database\Database;
use Chapel\Exceptions\DatabaseException;
use PDO;
use PDOException;

/**
 * BaseRepository
 *
 * Provides common CRUD operations for all repositories
 */
abstract class BaseRepository
{
    protected PDO $db;
    protected string $table;
    protected string $primaryKey = 'id';

    public function __construct()
    {
        $this->db = Database::getInstance();
    }

    /**
     * Find a record by ID
     *
     * @param string $id
     * @return array<string, mixed>|null
     * @throws DatabaseException
     */
    public function findById(string $id): ?array
    {
        try {
            $stmt = $this->db->prepare("SELECT * FROM {$this->table} WHERE {$this->primaryKey} = ? LIMIT 1");
            $stmt->execute([$id]);
            $result = $stmt->fetch();

            return $result !== false ? $result : null;
        } catch (PDOException $e) {
            throw new DatabaseException("Error finding record: " . $e->getMessage(), $e);
        }
    }

    /**
     * Find all records
     *
     * @param int $limit
     * @param int $offset
     * @return array<int, array<string, mixed>>
     * @throws DatabaseException
     */
    public function findAll(int $limit = 100, int $offset = 0): array
    {
        try {
            $stmt = $this->db->prepare("SELECT * FROM {$this->table} LIMIT ? OFFSET ?");
            $stmt->execute([$limit, $offset]);

            return $stmt->fetchAll();
        } catch (PDOException $e) {
            throw new DatabaseException("Error fetching records: " . $e->getMessage(), $e);
        }
    }

    /**
     * Count all records
     *
     * @return int
     * @throws DatabaseException
     */
    public function count(): int
    {
        try {
            $stmt = $this->db->query("SELECT COUNT(*) as count FROM {$this->table}");
            $result = $stmt->fetch();

            return (int) $result['count'];
        } catch (PDOException $e) {
            throw new DatabaseException("Error counting records: " . $e->getMessage(), $e);
        }
    }

    /**
     * Create a new record
     *
     * @param array<string, mixed> $data
     * @return string The ID of the created record
     * @throws DatabaseException
     */
    public function create(array $data): string
    {
        try {
            $columns = array_keys($data);
            $placeholders = array_fill(0, count($columns), '?');

            $sql = sprintf(
                "INSERT INTO %s (%s) VALUES (%s)",
                $this->table,
                implode(', ', $columns),
                implode(', ', $placeholders)
            );

            $stmt = $this->db->prepare($sql);
            $stmt->execute(array_values($data));

            return $data[$this->primaryKey] ?? $this->db->lastInsertId();
        } catch (PDOException $e) {
            throw new DatabaseException("Error creating record: " . $e->getMessage(), $e);
        }
    }

    /**
     * Update a record by ID
     *
     * @param string $id
     * @param array<string, mixed> $data
     * @return bool
     * @throws DatabaseException
     */
    public function update(string $id, array $data): bool
    {
        try {
            $columns = array_keys($data);
            $setClause = implode(' = ?, ', $columns) . ' = ?';

            $sql = "UPDATE {$this->table} SET {$setClause} WHERE {$this->primaryKey} = ?";

            $stmt = $this->db->prepare($sql);
            $values = array_values($data);
            $values[] = $id;

            return $stmt->execute($values);
        } catch (PDOException $e) {
            throw new DatabaseException("Error updating record: " . $e->getMessage(), $e);
        }
    }

    /**
     * Delete a record by ID
     *
     * @param string $id
     * @return bool
     * @throws DatabaseException
     */
    public function delete(string $id): bool
    {
        try {
            $stmt = $this->db->prepare("DELETE FROM {$this->table} WHERE {$this->primaryKey} = ?");

            return $stmt->execute([$id]);
        } catch (PDOException $e) {
            throw new DatabaseException("Error deleting record: " . $e->getMessage(), $e);
        }
    }

    /**
     * Check if a record exists
     *
     * @param string $id
     * @return bool
     * @throws DatabaseException
     */
    public function exists(string $id): bool
    {
        try {
            $stmt = $this->db->prepare("SELECT 1 FROM {$this->table} WHERE {$this->primaryKey} = ? LIMIT 1");
            $stmt->execute([$id]);

            return $stmt->fetch() !== false;
        } catch (PDOException $e) {
            throw new DatabaseException("Error checking existence: " . $e->getMessage(), $e);
        }
    }

    /**
     * Execute a raw query
     *
     * @param string $sql
     * @param array<int, mixed> $params
     * @return array<int, array<string, mixed>>
     * @throws DatabaseException
     */
    protected function query(string $sql, array $params = []): array
    {
        try {
            $stmt = $this->db->prepare($sql);
            $stmt->execute($params);

            return $stmt->fetchAll();
        } catch (PDOException $e) {
            throw new DatabaseException("Query error: " . $e->getMessage(), $e);
        }
    }

    /**
     * Execute a raw query and return single row
     *
     * @param string $sql
     * @param array<int, mixed> $params
     * @return array<string, mixed>|null
     * @throws DatabaseException
     */
    protected function queryOne(string $sql, array $params = []): ?array
    {
        try {
            $stmt = $this->db->prepare($sql);
            $stmt->execute($params);
            $result = $stmt->fetch();

            return $result !== false ? $result : null;
        } catch (PDOException $e) {
            throw new DatabaseException("Query error: " . $e->getMessage(), $e);
        }
    }

    /**
     * Begin a transaction
     *
     * @return bool
     */
    protected function beginTransaction(): bool
    {
        return $this->db->beginTransaction();
    }

    /**
     * Commit a transaction
     *
     * @return bool
     */
    protected function commit(): bool
    {
        return $this->db->commit();
    }

    /**
     * Rollback a transaction
     *
     * @return bool
     */
    protected function rollback(): bool
    {
        return $this->db->rollBack();
    }
}
