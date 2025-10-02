<?php

namespace Chapel\Models;

/**
 * Service Model
 *
 * Represents a chapel service (typically held on Wednesdays)
 */
class Service
{
    public string $id;
    public string $serviceDate;
    public string $startTime;
    public string $endTime;
    public ?string $theme = null;
    public ?string $pastorId = null;
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
            'serviceDate' => $this->serviceDate,
            'startTime' => $this->startTime,
            'endTime' => $this->endTime,
            'theme' => $this->theme,
            'pastorId' => $this->pastorId,
            'createdAt' => $this->createdAt,
            'updatedAt' => $this->updatedAt,
        ];
    }

    /**
     * Create Service from database row
     *
     * @param array<string, mixed> $row
     * @return self
     */
    public static function fromArray(array $row): self
    {
        $service = new self();
        $service->id = $row['id'];
        $service->serviceDate = $row['service_date'];
        $service->startTime = $row['start_time'];
        $service->endTime = $row['end_time'];
        $service->theme = $row['theme'] ?? null;
        $service->pastorId = $row['pastor_id'] ?? null;
        $service->createdAt = $row['created_at'] ?? null;
        $service->updatedAt = $row['updated_at'] ?? null;

        return $service;
    }
}
