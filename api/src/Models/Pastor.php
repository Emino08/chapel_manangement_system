<?php

namespace Chapel\Models;

/**
 * Pastor Model
 *
 * Represents a pastor who can lead chapel services
 */
class Pastor
{
    public string $id;
    public string $code;
    public string $name;
    public ?string $program = null;
    public ?string $phone = null;
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
            'code' => $this->code,
            'name' => $this->name,
            'program' => $this->program,
            'phone' => $this->phone,
            'createdAt' => $this->createdAt,
            'updatedAt' => $this->updatedAt,
        ];
    }

    /**
     * Create Pastor from database row
     *
     * @param array<string, mixed> $row
     * @return self
     */
    public static function fromArray(array $row): self
    {
        $pastor = new self();
        $pastor->id = $row['id'];
        $pastor->code = $row['code'];
        $pastor->name = $row['name'];
        $pastor->program = $row['program'] ?? null;
        $pastor->phone = $row['phone'] ?? null;
        $pastor->createdAt = $row['created_at'] ?? null;
        $pastor->updatedAt = $row['updated_at'] ?? null;

        return $pastor;
    }
}
