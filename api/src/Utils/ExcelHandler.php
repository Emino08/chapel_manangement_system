<?php

namespace Chapel\Utils;

use PhpOffice\PhpSpreadsheet\IOFactory;
use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;
use PhpOffice\PhpSpreadsheet\Style\Fill;
use PhpOffice\PhpSpreadsheet\Style\Alignment;
use PhpOffice\PhpSpreadsheet\Style\Border;
use Chapel\Exceptions\ValidationException;

/**
 * ExcelHandler
 *
 * Handles Excel file upload parsing and export generation
 */
class ExcelHandler
{
    /**
     * Parse Excel file for student import
     *
     * @param string $filePath
     * @return array<int, array<string, mixed>>
     * @throws ValidationException
     */
    public function parseStudentFile(string $filePath): array
    {
        if (!file_exists($filePath)) {
            throw new ValidationException('Excel file not found');
        }

        try {
            $spreadsheet = IOFactory::load($filePath);
            $worksheet = $spreadsheet->getActiveSheet();

            $headers = [];
            $students = [];

            foreach ($worksheet->getRowIterator() as $rowIndex => $row) {
                $cellIterator = $row->getCellIterator();
                $cellIterator->setIterateOnlyExistingCells(false);

                $rowData = [];
                foreach ($cellIterator as $cell) {
                    $rowData[] = $cell->getValue();
                }

                // First row is header
                if ($rowIndex === 1) {
                    $headers = array_map('trim', $rowData);
                    continue;
                }

                // Skip empty rows
                if ($this->isEmptyRow($rowData)) {
                    continue;
                }

                $student = $this->parseStudentRow($headers, $rowData, $rowIndex);

                if ($student) {
                    $students[] = $student;
                }
            }

            if (empty($students)) {
                throw new ValidationException('No valid student records found in Excel file');
            }

            return $students;
        } catch (\Exception $e) {
            throw new ValidationException('Error parsing Excel file: ' . $e->getMessage());
        }
    }

    /**
     * Export attendance report to Excel
     *
     * @param array<int, array<string, mixed>> $data
     * @param array<int, string> $headers
     * @param string $title
     * @return string Path to generated file
     * @throws ValidationException
     */
    public function exportAttendance(array $data, array $headers, string $title): string
    {
        try {
            $spreadsheet = new Spreadsheet();
            $worksheet = $spreadsheet->getActiveSheet();

            // Set title
            $worksheet->setTitle(substr($title, 0, 31)); // Excel sheet title max 31 chars

            // Write headers
            $col = 1;
            foreach ($headers as $header) {
                $worksheet->setCellValueByColumnAndRow($col, 1, $header);
                $col++;
            }

            // Style headers
            $headerRange = 'A1:' . $worksheet->getCellByColumnAndRow(count($headers), 1)->getColumn() . '1';
            $worksheet->getStyle($headerRange)->applyFromArray([
                'font' => ['bold' => true, 'color' => ['rgb' => 'FFFFFF']],
                'fill' => ['fillType' => Fill::FILL_SOLID, 'startColor' => ['rgb' => '4472C4']],
                'alignment' => ['horizontal' => Alignment::HORIZONTAL_CENTER],
            ]);

            // Write data
            $row = 2;
            foreach ($data as $record) {
                $col = 1;
                foreach ($headers as $header) {
                    $key = $this->headerToKey($header);
                    $value = $record[$key] ?? '';
                    $worksheet->setCellValueByColumnAndRow($col, $row, $value);
                    $col++;
                }
                $row++;
            }

            // Auto-size columns
            foreach (range(1, count($headers)) as $col) {
                $worksheet->getColumnDimensionByColumn($col)->setAutoSize(true);
            }

            // Add borders
            $dataRange = 'A1:' . $worksheet->getCellByColumnAndRow(count($headers), $row - 1)->getColumn() . ($row - 1);
            $worksheet->getStyle($dataRange)->applyFromArray([
                'borders' => [
                    'allBorders' => ['borderStyle' => Border::BORDER_THIN, 'color' => ['rgb' => '000000']],
                ],
            ]);

            // Save to temp file
            $tempFile = sys_get_temp_dir() . '/' . uniqid('attendance_', true) . '.xlsx';
            $writer = new Xlsx($spreadsheet);
            $writer->save($tempFile);

            return $tempFile;
        } catch (\Exception $e) {
            throw new ValidationException('Error generating Excel file: ' . $e->getMessage());
        }
    }

    /**
     * Export semester report to Excel
     *
     * @param array<int, array<string, mixed>> $data
     * @param string $semesterName
     * @return string Path to generated file
     * @throws ValidationException
     */
    public function exportSemesterReport(array $data, string $semesterName): string
    {
        $headers = [
            'Student No',
            'Name',
            'Program',
            'Faculty',
            'Level',
            'Times Attended',
            'Total Services',
            'Attendance %',
        ];

        try {
            $spreadsheet = new Spreadsheet();
            $worksheet = $spreadsheet->getActiveSheet();

            // Set title
            $worksheet->setTitle(substr($semesterName, 0, 31));

            // Add report title
            $worksheet->setCellValue('A1', $semesterName . ' - Attendance Report');
            $worksheet->mergeCells('A1:H1');
            $worksheet->getStyle('A1')->applyFromArray([
                'font' => ['bold' => true, 'size' => 14],
                'alignment' => ['horizontal' => Alignment::HORIZONTAL_CENTER],
            ]);

            // Write headers
            $col = 1;
            foreach ($headers as $header) {
                $worksheet->setCellValueByColumnAndRow($col, 2, $header);
                $col++;
            }

            // Style headers
            $worksheet->getStyle('A2:H2')->applyFromArray([
                'font' => ['bold' => true, 'color' => ['rgb' => 'FFFFFF']],
                'fill' => ['fillType' => Fill::FILL_SOLID, 'startColor' => ['rgb' => '4472C4']],
                'alignment' => ['horizontal' => Alignment::HORIZONTAL_CENTER],
            ]);

            // Write data
            $row = 3;
            foreach ($data as $record) {
                $timesAttended = (int) ($record['times_attended'] ?? 0);
                $totalServices = (int) ($record['total_services'] ?? 1);
                $percentage = $totalServices > 0 ? round(($timesAttended / $totalServices) * 100, 2) : 0;

                $worksheet->setCellValueByColumnAndRow(1, $row, $record['student_no'] ?? '');
                $worksheet->setCellValueByColumnAndRow(2, $row, $record['student_name'] ?? '');
                $worksheet->setCellValueByColumnAndRow(3, $row, $record['program'] ?? '');
                $worksheet->setCellValueByColumnAndRow(4, $row, $record['faculty'] ?? '');
                $worksheet->setCellValueByColumnAndRow(5, $row, $record['level'] ?? '');
                $worksheet->setCellValueByColumnAndRow(6, $row, $timesAttended);
                $worksheet->setCellValueByColumnAndRow(7, $row, $totalServices);
                $worksheet->setCellValueByColumnAndRow(8, $row, $percentage . '%');

                $row++;
            }

            // Auto-size columns
            foreach (range(1, count($headers)) as $col) {
                $worksheet->getColumnDimensionByColumn($col)->setAutoSize(true);
            }

            // Add borders
            $dataRange = 'A2:H' . ($row - 1);
            $worksheet->getStyle($dataRange)->applyFromArray([
                'borders' => [
                    'allBorders' => ['borderStyle' => Border::BORDER_THIN, 'color' => ['rgb' => '000000']],
                ],
            ]);

            // Save to temp file
            $tempFile = sys_get_temp_dir() . '/' . uniqid('semester_report_', true) . '.xlsx';
            $writer = new Xlsx($spreadsheet);
            $writer->save($tempFile);

            return $tempFile;
        } catch (\Exception $e) {
            throw new ValidationException('Error generating Excel file: ' . $e->getMessage());
        }
    }

    /**
     * Parse student row from Excel
     *
     * @param array<int, string> $headers
     * @param array<int, mixed> $rowData
     * @param int $rowIndex
     * @return array<string, mixed>|null
     */
    private function parseStudentRow(array $headers, array $rowData, int $rowIndex): ?array
    {
        $record = [];

        foreach ($headers as $index => $header) {
            $record[trim($header)] = $rowData[$index] ?? '';
        }

        // Map to database columns
        $studentNo = trim((string) ($record['No'] ?? $record['Student No'] ?? ''));
        $name = trim((string) ($record['Name'] ?? ''));
        $program = trim((string) ($record['Program'] ?? ''));
        $phone = trim((string) ($record['Phone Number'] ?? $record['Phone'] ?? ''));
        $faculty = trim((string) ($record['Faculty'] ?? ''));
        $level = trim((string) ($record['Level'] ?? ''));

        // Skip if required fields are missing
        if (empty($studentNo) || empty($name) || empty($program)) {
            return null;
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
     * @param array<int, mixed> $rowData
     * @return bool
     */
    private function isEmptyRow(array $rowData): bool
    {
        foreach ($rowData as $value) {
            if (!empty(trim((string) $value))) {
                return false;
            }
        }

        return true;
    }

    /**
     * Convert header to snake_case key
     *
     * @param string $header
     * @return string
     */
    private function headerToKey(string $header): string
    {
        return strtolower(str_replace(' ', '_', trim($header)));
    }
}
