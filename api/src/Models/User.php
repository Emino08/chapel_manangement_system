<?php

namespace Chapel\Models;

/**
 * User Model
 *
 * Represents a system user (ADMIN, HR, or SUO role)
 */
class User
{
    public string $id;
    public string $name;
    public string $email;
    public string $role;
    public string $passwordHash;
    public ?string $createdAt = null;
    public ?string $updatedAt = null;

    /**
     * Convert model to array
     *
     * @return array<string, mixed>
     */
    public function toArray(): array
    {
        return [
            'id' => $this->id,
            'name' => $this->name,
            'email' => $this->email,
            'role' => $this->role,
            'createdAt' => $this->createdAt,
            'updatedAt' => $this->updatedAt,
        ];
    }

    /**
     * Create User from database row
     *
     * @param array<string, mixed> $row
     * @return self
     */
    public static function fromArray(array $row): self
    {
        $user = new self();
        $user->id = $row['id'];
        $user->name = $row['name'];
        $user->email = $row['email'];
        $user->role = $row['role'];
        $user->passwordHash = $row['password_hash'] ?? '';
        $user->createdAt = $row['created_at'] ?? null;
        $user->updatedAt = $row['updated_at'] ?? null;

        return $user;
    }
}
