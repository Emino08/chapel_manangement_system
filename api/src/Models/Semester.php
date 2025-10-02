<?php

namespace Chapel\Models;

/**
 * Semester Model
 *
 * Represents an academic semester for tracking attendance periods
 */
class Semester
{
    public string $id;
    public string $name;
    public string $startDate;
    public string $endDate;
    public bool $active;
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
            'startDate' => $this->startDate,
            'endDate' => $this->endDate,
            'active' => $this->active,
            'createdAt' => $this->createdAt,
            'updatedAt' => $this->updatedAt,
        ];
    }

    /**
     * Create Semester from database row
     *
     * @param array<string, mixed> $row
     * @return self
     */
    public static function fromArray(array $row): self
    {
        $semester = new self();
        $semester->id = $row['id'];
        $semester->name = $row['name'];
        $semester->startDate = $row['start_date'];
        $semester->endDate = $row['end_date'];
        $semester->active = (bool) $row['active'];
        $semester->createdAt = $row['created_at'] ?? null;
        $semester->updatedAt = $row['updated_at'] ?? null;

        return $semester;
    }
}
