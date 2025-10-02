<?php

namespace Chapel\Repositories;

use Chapel\Exceptions\DatabaseException;

/**
 * UserRepository
 *
 * Handles database operations for users
 */
class UserRepository extends BaseRepository
{
    protected string $table = 'users';

    /**
     * Find a user by email
     *
     * @param string $email
     * @return array<string, mixed>|null
     * @throws DatabaseException
     */
    public function findByEmail(string $email): ?array
    {
        return $this->queryOne("SELECT * FROM {$this->table} WHERE email = ? LIMIT 1", [$email]);
    }

    /**
     * Find users by role
     *
     * @param string $role
     * @return array<int, array<string, mixed>>
     * @throws DatabaseException
     */
    public function findByRole(string $role): array
    {
        return $this->query("SELECT * FROM {$this->table} WHERE role = ?", [$role]);
    }

    /**
     * Check if email exists
     *
     * @param string $email
     * @param string|null $excludeId
     * @return bool
     * @throws DatabaseException
     */
    public function emailExists(string $email, ?string $excludeId = null): bool
    {
        if ($excludeId) {
            $result = $this->queryOne(
                "SELECT 1 FROM {$this->table} WHERE email = ? AND id != ? LIMIT 1",
                [$email, $excludeId]
            );
        } else {
            $result = $this->queryOne(
                "SELECT 1 FROM {$this->table} WHERE email = ? LIMIT 1",
                [$email]
            );
        }

        return $result !== null;
    }

    /**
     * Update user password
     *
     * @param string $id
     * @param string $passwordHash
     * @return bool
     * @throws DatabaseException
     */
    public function updatePassword(string $id, string $passwordHash): bool
    {
        return $this->update($id, ['password_hash' => $passwordHash]);
    }

    /**
     * Get user count by role
     *
     * @return array<string, int>
     * @throws DatabaseException
     */
    public function countByRole(): array
    {
        $results = $this->query("SELECT role, COUNT(*) as count FROM {$this->table} GROUP BY role");

        $counts = [];
        foreach ($results as $row) {
            $counts[$row['role']] = (int) $row['count'];
        }

        return $counts;
    }
}
