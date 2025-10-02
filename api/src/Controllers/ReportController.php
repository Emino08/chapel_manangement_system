<?php

namespace Chapel\Controllers;

use Chapel\Repositories\AttendanceRepository;
use Chapel\Repositories\LecturerAttendanceRepository;
use Chapel\Repositories\SemesterRepository;
use Chapel\Repositories\ServiceRepository;
use Chapel\Utils\ExcelHandler;
use Chapel\Utils\ResponseHelper;
use Chapel\Exceptions\NotFoundException;
use Chapel\Exceptions\ValidationException;

/**
 * ReportController
 *
 * Handles report generation and export operations for students and lecturers
 */
class ReportController
{
    private AttendanceRepository $attendanceRepository;
    private LecturerAttendanceRepository $lecturerAttendanceRepository;
    private SemesterRepository $semesterRepository;
    private ServiceRepository $serviceRepository;
    private ExcelHandler $excelHandler;

    public function __construct(
        AttendanceRepository $attendanceRepository,
        LecturerAttendanceRepository $lecturerAttendanceRepository,
        SemesterRepository $semesterRepository,
        ServiceRepository $serviceRepository,
        ExcelHandler $excelHandler
    ) {
        $this->attendanceRepository = $attendanceRepository;
        $this->lecturerAttendanceRepository = $lecturerAttendanceRepository;
        $this->semesterRepository = $semesterRepository;
        $this->serviceRepository = $serviceRepository;
        $this->excelHandler = $excelHandler;
    }

    /**
     * Get semester attendance report with filters
     * GET /api/v1/reports/semester/:semesterId?program=&faculty=&threshold=75
     *
     * @param string $semesterId Semester ID
     * @param array<string, mixed> $params Query parameters (program, faculty, threshold, page, limit)
     * @return void
     */
    public function semesterReport(string $semesterId, array $params): void
    {
        try {
            // Verify semester exists
            $semester = $this->semesterRepository->findById($semesterId);
            if (!$semester) {
                throw new NotFoundException('Semester not found');
            }

            // Get filter parameters
            $program = $params['program'] ?? null;
            $faculty = $params['faculty'] ?? null;
            $threshold = (int) ($params['threshold'] ?? 75);
            $page = (int) ($params['page'] ?? 1);
            $limit = (int) ($params['limit'] ?? 50);
            $offset = ($page - 1) * $limit;

            // Get semester report from view
            $report = $this->attendanceRepository->getSemesterReport($semesterId);

            // Apply filters
            if ($program) {
                $report = array_filter($report, function ($record) use ($program) {
                    return $record['program'] === $program;
                });
            }

            if ($faculty) {
                $report = array_filter($report, function ($record) use ($faculty) {
                    return $record['faculty'] === $faculty;
                });
            }

            // Calculate eligibility based on threshold
            $report = array_map(function ($record) use ($threshold) {
                $timesAttended = (int) $record['times_attended'];
                $totalServices = (int) $record['total_services'];
                $percentage = $totalServices > 0 ? ($timesAttended / $totalServices) * 100 : 0;

                $record['attendance_percentage'] = round($percentage, 2);
                $record['is_eligible'] = $percentage >= $threshold;

                return $record;
            }, $report);

            // Sort by student name
            usort($report, function ($a, $b) {
                return strcmp($a['student_name'], $b['student_name']);
            });

            // Paginate
            $total = count($report);
            $report = array_slice($report, $offset, $limit);

            ResponseHelper::paginated(
                array_values($report),
                $total,
                $page,
                $limit,
                'Semester report retrieved successfully'
            );
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }

    /**
     * Upload and parse Excel file for validation
     * POST /api/v1/reports/upload
     *
     * @param array<string, mixed> $files Uploaded files array
     * @return void
     */
    public function uploadExcel(array $files): void
    {
        try {
            // Check if file was uploaded
            if (!isset($files['file']) || $files['file']['error'] !== UPLOAD_ERR_OK) {
                throw new ValidationException('No file uploaded or upload error occurred');
            }

            $file = $files['file'];
            $filePath = $file['tmp_name'];
            $fileName = $file['name'];
            $fileExt = strtolower(pathinfo($fileName, PATHINFO_EXTENSION));

            // Only accept Excel files
            if (!in_array($fileExt, ['xlsx', 'xls'])) {
                throw new ValidationException('Invalid file format. Only Excel files (.xlsx, .xls) are supported.');
            }

            // Parse Excel file
            $students = $this->excelHandler->parseStudentFile($filePath);

            // Return normalized rows for preview (don't save to DB yet)
            ResponseHelper::success([
                'count' => count($students),
                'preview' => array_slice($students, 0, 10), // First 10 rows as preview
                'students' => $students,
            ], 'Excel file parsed successfully');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }

    /**
     * Export semester report to CSV or Excel
     * GET /api/v1/reports/export?format=csv|xlsx&semesterId=...&program=&faculty=&threshold=75
     *
     * @param array<string, mixed> $params Query parameters
     * @return void
     */
    public function export(array $params): void
    {
        try {
            $format = $params['format'] ?? 'xlsx';
            $semesterId = $params['semesterId'] ?? null;

            if (!$semesterId) {
                throw new ValidationException('Semester ID is required', [
                    'semesterId' => ['Semester ID is required']
                ]);
            }

            // Verify semester exists
            $semester = $this->semesterRepository->findById($semesterId);
            if (!$semester) {
                throw new NotFoundException('Semester not found');
            }

            // Get filter parameters
            $program = $params['program'] ?? null;
            $faculty = $params['faculty'] ?? null;
            $threshold = (int) ($params['threshold'] ?? 75);

            // Get full report (no pagination)
            $report = $this->attendanceRepository->getSemesterReport($semesterId);

            // Apply filters
            if ($program) {
                $report = array_filter($report, function ($record) use ($program) {
                    return $record['program'] === $program;
                });
            }

            if ($faculty) {
                $report = array_filter($report, function ($record) use ($faculty) {
                    return $record['faculty'] === $faculty;
                });
            }

            // Calculate eligibility based on threshold
            $report = array_map(function ($record) use ($threshold) {
                $timesAttended = (int) $record['times_attended'];
                $totalServices = (int) $record['total_services'];
                $percentage = $totalServices > 0 ? ($timesAttended / $totalServices) * 100 : 0;

                $record['attendance_percentage'] = round($percentage, 2);
                $record['is_eligible'] = $percentage >= $threshold ? 'Yes' : 'No';

                return $record;
            }, $report);

            // Sort by student name
            usort($report, function ($a, $b) {
                return strcmp($a['student_name'], $b['student_name']);
            });

            if ($format === 'csv') {
                // Generate CSV
                $this->exportCsv($report, $semester['name']);
            } else {
                // Generate Excel
                $filePath = $this->excelHandler->exportSemesterReport(
                    array_values($report),
                    $semester['name']
                );

                // Send file to browser
                $this->sendFile($filePath, $semester['name'] . '_report.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
            }
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }

    /**
     * Export report as CSV
     *
     * @param array<int, array<string, mixed>> $data Report data
     * @param string $semesterName Semester name
     * @return void
     */
    private function exportCsv(array $data, string $semesterName): void
    {
        $filename = $semesterName . '_report.csv';

        // Set headers for CSV download
        header('Content-Type: text/csv');
        header('Content-Disposition: attachment; filename="' . $filename . '"');
        header('Pragma: no-cache');
        header('Expires: 0');

        // Open output stream
        $output = fopen('php://output', 'w');

        // Write headers
        if (!empty($data)) {
            $headers = [
                'Student No',
                'Name',
                'Program',
                'Faculty',
                'Level',
                'Times Attended',
                'Total Services',
                'Attendance %',
                'Eligible',
            ];
            fputcsv($output, $headers);

            // Write data rows
            foreach ($data as $row) {
                fputcsv($output, [
                    $row['student_no'] ?? '',
                    $row['student_name'] ?? '',
                    $row['program'] ?? '',
                    $row['faculty'] ?? '',
                    $row['level'] ?? '',
                    $row['times_attended'] ?? 0,
                    $row['total_services'] ?? 0,
                    $row['attendance_percentage'] ?? 0,
                    $row['is_eligible'] ?? 'No',
                ]);
            }
        }

        fclose($output);
        exit;
    }

    /**
     * Send file to browser for download
     *
     * @param string $filePath Path to file
     * @param string $filename Download filename
     * @param string $mimeType MIME type
     * @return void
     */
    private function sendFile(string $filePath, string $filename, string $mimeType): void
    {
        if (!file_exists($filePath)) {
            throw new NotFoundException('File not found');
        }

        // Set headers for file download
        header('Content-Type: ' . $mimeType);
        header('Content-Disposition: attachment; filename="' . $filename . '"');
        header('Content-Length: ' . filesize($filePath));
        header('Pragma: no-cache');
        header('Expires: 0');

        // Output file
        readfile($filePath);

        // Clean up temp file
        unlink($filePath);

        exit;
    }

    /**
     * Get summary statistics for a semester
     * GET /api/v1/reports/semester/:semesterId/stats
     *
     * @param string $semesterId Semester ID
     * @return void
     */
    public function semesterStats(string $semesterId): void
    {
        try {
            // Verify semester exists
            $semester = $this->semesterRepository->findById($semesterId);
            if (!$semester) {
                throw new NotFoundException('Semester not found');
            }

            // Get total services in semester
            $services = $this->serviceRepository->getBySemester($semesterId);
            $totalServices = count($services);

            // Get report data
            $report = $this->attendanceRepository->getSemesterReport($semesterId);

            // Calculate statistics
            $totalStudents = count($report);
            $totalAttendanceRecords = array_sum(array_column($report, 'times_attended'));
            $averageAttendance = $totalStudents > 0 ? $totalAttendanceRecords / $totalStudents : 0;

            // Count eligible students (75% threshold)
            $eligibleCount = 0;
            foreach ($report as $record) {
                $percentage = $record['total_services'] > 0
                    ? ($record['times_attended'] / $record['total_services']) * 100
                    : 0;
                if ($percentage >= 75) {
                    $eligibleCount++;
                }
            }

            ResponseHelper::success([
                'semester' => $semester,
                'total_services' => $totalServices,
                'total_students' => $totalStudents,
                'total_attendance_records' => $totalAttendanceRecords,
                'average_attendance' => round($averageAttendance, 2),
                'eligible_students' => $eligibleCount,
                'eligibility_percentage' => $totalStudents > 0 ? round(($eligibleCount / $totalStudents) * 100, 2) : 0,
            ], 'Semester statistics retrieved successfully');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }

    /**
     * Get lecturer semester attendance report with filters
     * GET /api/v1/reports/semester/:semesterId/lecturers?department=&faculty=&threshold=75
     *
     * @param string $semesterId Semester ID
     * @param array<string, mixed> $params Query parameters (department, faculty, threshold, page, limit)
     * @return void
     */
    public function lecturerSemesterReport(string $semesterId, array $params): void
    {
        try {
            // Verify semester exists
            $semester = $this->semesterRepository->findById($semesterId);
            if (!$semester) {
                throw new NotFoundException('Semester not found');
            }

            // Get filter parameters
            $department = $params['department'] ?? null;
            $faculty = $params['faculty'] ?? null;
            $threshold = (int) ($params['threshold'] ?? 75);
            $page = (int) ($params['page'] ?? 1);
            $limit = (int) ($params['limit'] ?? 50);
            $offset = ($page - 1) * $limit;

            // Get semester report from view
            $report = $this->lecturerAttendanceRepository->getSemesterReport($semesterId);

            // Apply filters
            if ($department) {
                $report = array_filter($report, function ($record) use ($department) {
                    return $record['department'] === $department;
                });
            }

            if ($faculty) {
                $report = array_filter($report, function ($record) use ($faculty) {
                    return $record['faculty'] === $faculty;
                });
            }

            // Calculate eligibility based on threshold
            $report = array_map(function ($record) use ($threshold) {
                $timesAttended = (int) $record['times_attended'];
                $totalServices = (int) $record['total_services'];
                $percentage = $totalServices > 0 ? ($timesAttended / $totalServices) * 100 : 0;

                $record['attendance_percentage'] = round($percentage, 2);
                $record['is_eligible'] = $percentage >= $threshold;

                return $record;
            }, $report);

            // Sort by lecturer name
            usort($report, function ($a, $b) {
                return strcmp($a['lecturer_name'], $b['lecturer_name']);
            });

            // Paginate
            $total = count($report);
            $report = array_slice($report, $offset, $limit);

            ResponseHelper::paginated(
                array_values($report),
                $total,
                $page,
                $limit,
                'Lecturer semester report retrieved successfully'
            );
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }
}
