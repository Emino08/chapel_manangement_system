<?php

namespace Chapel\Models;

/**
 * Attendance Model
 *
 * Represents a student's attendance record for a chapel service
 */
class Attendance
{
    public string $id;
    public string $serviceId;
    public string $studentId;
    public string $status;
    public string $markedBy;
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
            'serviceId' => $this->serviceId,
            'studentId' => $this->studentId,
            'status' => $this->status,
            'markedBy' => $this->markedBy,
            'createdAt' => $this->createdAt,
            'updatedAt' => $this->updatedAt,
        ];
    }

    /**
     * Create Attendance from database row
     *
     * @param array<string, mixed> $row
     * @return self
     */
    public static function fromArray(array $row): self
    {
        $attendance = new self();
        $attendance->id = $row['id'];
        $attendance->serviceId = $row['service_id'];
        $attendance->studentId = $row['student_id'];
        $attendance->status = $row['status'];
        $attendance->markedBy = $row['marked_by'];
        $attendance->createdAt = $row['created_at'] ?? null;
        $attendance->updatedAt = $row['updated_at'] ?? null;

        return $attendance;
    }
}
