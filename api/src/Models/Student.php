<?php

namespace Chapel\Models;

/**
 * Student Model
 *
 * Represents a student in the chapel attendance system
 */
class Student
{
    public string $id;
    public string $studentNo;
    public string $name;
    public string $program;
    public ?string $faculty = null;
    public ?string $phone = null;
    public ?string $level = null;
    public ?string $studentIdCard = null;
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
            'studentNo' => $this->studentNo,
            'name' => $this->name,
            'program' => $this->program,
            'faculty' => $this->faculty,
            'phone' => $this->phone,
            'level' => $this->level,
            'studentIdCard' => $this->studentIdCard,
            'createdAt' => $this->createdAt,
            'updatedAt' => $this->updatedAt,
        ];
    }

    /**
     * Create Student from database row
     *
     * @param array<string, mixed> $row
     * @return self
     */
    public static function fromArray(array $row): self
    {
        $student = new self();
        $student->id = $row['id'];
        $student->studentNo = $row['student_no'];
        $student->name = $row['name'];
        $student->program = $row['program'];
        $student->faculty = $row['faculty'] ?? null;
        $student->phone = $row['phone'] ?? null;
        $student->level = $row['level'] ?? null;
        $student->studentIdCard = $row['student_id_card'] ?? null;
        $student->createdAt = $row['created_at'] ?? null;
        $student->updatedAt = $row['updated_at'] ?? null;

        return $student;
    }
}
