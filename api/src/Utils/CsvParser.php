<?php

namespace Chapel\Utils;

use League\Csv\Reader;
use League\Csv\Exception as CsvException;
use Chapel\Exceptions\ValidationException;

/**
 * CsvParser
 *
 * Parses CSV files for student bulk upload
 * Expected columns: No, Name, Program, Phone Number
 */
class CsvParser
{
    /**
     * @var array<int, string>
     */
    private array $requiredColumns = ['No', 'Name', 'Program'];

    /**
     * @var array<int, string>
     */
    private array $optionalColumns = ['Phone Number', 'Faculty', 'Level'];

    /**
     * Parse CSV file from path
     *
     * @param string $filePath
     * @return array<int, array<string, mixed>>
     * @throws ValidationException
     */
    public function parseFile(string $filePath): array
    {
        if (!file_exists($filePath)) {
            throw new ValidationException('CSV file not found');
        }

        try {
            $csv = Reader::createFromPath($filePath, 'r');
            $csv->setHeaderOffset(0);

            return $this->parseReader($csv);
        } catch (CsvException $e) {
            throw new ValidationException('Error reading CSV file: ' . $e->getMessage());
        }
    }

    /**
     * Parse CSV from string content
     *
     * @param string $content
     * @return array<int, array<string, mixed>>
     * @throws ValidationException
     */
    public function parseString(string $content): array
    {
        try {
            $csv = Reader::createFromString($content);
            $csv->setHeaderOffset(0);

            return $this->parseReader($csv);
        } catch (CsvException $e) {
            throw new ValidationException('Error parsing CSV content: ' . $e->getMessage());
        }
    }

    /**
     * Parse CSV reader
     *
     * @param Reader $csv
     * @return array<int, array<string, mixed>>
     * @throws ValidationException
     */
    private function parseReader(Reader $csv): array
    {
        $headers = $csv->getHeader();

        // Validate headers
        $this->validateHeaders($headers);

        $students = [];
        $rowNumber = 1; // Start from 1 (header is row 0)

        foreach ($csv->getRecords() as $record) {
            $rowNumber++;

            try {
                $student = $this->parseRow($record, $rowNumber);

                if ($student) {
                    $students[] = $student;
                }
            } catch (ValidationException $e) {
                // Re-throw with row number context
                throw new ValidationException(
                    sprintf('Row %d: %s', $rowNumber, $e->getMessage()),
                    $e->getErrors()
                );
            }
        }

        if (empty($students)) {
            throw new ValidationException('No valid student records found in CSV');
        }

        return $students;
    }

    /**
     * Validate CSV headers
     *
     * @param array<int, string> $headers
     * @return void
     * @throws ValidationException
     */
    private function validateHeaders(array $headers): void
    {
        $headers = array_map('trim', $headers);

        foreach ($this->requiredColumns as $required) {
            if (!in_array($required, $headers, true)) {
                throw new ValidationException(
                    sprintf(
                        'Missing required column: "%s". Expected columns: %s',
                        $required,
                        implode(', ', $this->requiredColumns)
                    )
                );
            }
        }
    }

    /**
     * Parse a single CSV row
     *
     * @param array<string, string> $record
     * @param int $rowNumber
     * @return array<string, mixed>|null
     * @throws ValidationException
     */
    private function parseRow(array $record, int $rowNumber): ?array
    {
        // Skip empty rows
        if ($this->isEmptyRow($record)) {
            return null;
        }

        $errors = [];

        // Student No (from "No" column)
        $studentNo = trim($record['No'] ?? '');
        if (empty($studentNo)) {
            $errors['studentNo'] = ['Student number is required'];
        }

        // Name
        $name = trim($record['Name'] ?? '');
        if (empty($name)) {
            $errors['name'] = ['Student name is required'];
        }

        // Program
        $program = trim($record['Program'] ?? '');
        if (empty($program)) {
            $errors['program'] = ['Program is required'];
        }

        // Phone Number (optional)
        $phone = trim($record['Phone Number'] ?? '');
        if ($phone && !$this->isValidPhone($phone)) {
            $errors['phone'] = ['Invalid phone number format'];
        }

        // Faculty (optional)
        $faculty = trim($record['Faculty'] ?? '');

        // Level (optional)
        $level = trim($record['Level'] ?? '');

        if (!empty($errors)) {
            throw new ValidationException('Validation failed', $errors);
        }

        return [
            'student_no' => $studentNo,
            'name' => $name,
            'program' => $program,
            'phone' => !empty($phone) ? $phone : null,
            'faculty' => !empty($faculty) ? $faculty : null,
            'level' => !empty($level) ? $level : null,
        ];
    }

    /**
     * Check if row is empty
     *
     * @param array<string, string> $record
     * @return bool
     */
    private function isEmptyRow(array $record): bool
    {
        foreach ($record as $value) {
            if (!empty(trim($value))) {
                return false;
            }
        }

        return true;
    }

    /**
     * Validate phone number format
     *
     * @param string $phone
     * @return bool
     */
    private function isValidPhone(string $phone): bool
    {
        // Remove common separators
        $cleaned = preg_replace('/[\s\-\(\)]+/', '', $phone);

        // Check if it's a valid format (supports +232, 232, or local numbers)
        return preg_match('/^\+?232\d{8}$|^\d{8,15}$/', $cleaned ?? '') === 1;
    }

    /**
     * Set required columns
     *
     * @param array<int, string> $columns
     * @return self
     */
    public function setRequiredColumns(array $columns): self
    {
        $this->requiredColumns = $columns;

        return $this;
    }

    /**
     * Set optional columns
     *
     * @param array<int, string> $columns
     * @return self
     */
    public function setOptionalColumns(array $columns): self
    {
        $this->optionalColumns = $columns;

        return $this;
    }
}
