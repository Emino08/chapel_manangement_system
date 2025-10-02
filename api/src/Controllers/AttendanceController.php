<?php

namespace Chapel\Controllers;

use Chapel\Repositories\AttendanceRepository;
use Chapel\Repositories\ServiceRepository;
use Chapel\Repositories\StudentRepository;
use Chapel\Repositories\LecturerRepository;
use Chapel\Repositories\LecturerAttendanceRepository;
use Chapel\Utils\Validator;
use Chapel\Utils\ResponseHelper;
use Chapel\Exceptions\NotFoundException;
use Chapel\Exceptions\ValidationException;

/**
 * AttendanceController
 *
 * Handles attendance marking and retrieval operations for students and lecturers
 */
class AttendanceController
{
    private AttendanceRepository $attendanceRepository;
    private ServiceRepository $serviceRepository;
    private StudentRepository $studentRepository;
    private LecturerRepository $lecturerRepository;
    private LecturerAttendanceRepository $lecturerAttendanceRepository;
    private Validator $validator;

    public function __construct(
        AttendanceRepository $attendanceRepository,
        ServiceRepository $serviceRepository,
        StudentRepository $studentRepository,
        LecturerRepository $lecturerRepository,
        LecturerAttendanceRepository $lecturerAttendanceRepository,
        Validator $validator
    ) {
        $this->attendanceRepository = $attendanceRepository;
        $this->serviceRepository = $serviceRepository;
        $this->studentRepository = $studentRepository;
        $this->lecturerRepository = $lecturerRepository;
        $this->lecturerAttendanceRepository = $lecturerAttendanceRepository;
        $this->validator = $validator;
    }

    /**
     * Search students for attendance marking
     * POST /api/v1/attendance/search
     * Body: {serviceId, program?, faculty?, query?}
     *
     * @param array<string, mixed> $data Request body data
     * @return void
     */
    public function search(array $data): void
    {
        try {
            $serviceId = $data['serviceId'] ?? null;
            $program = $data['program'] ?? null;
            $faculty = $data['faculty'] ?? null;
            $query = $data['query'] ?? '';

            if (!$serviceId) {
                throw new ValidationException('Service ID is required', [
                    'serviceId' => ['Service ID is required']
                ]);
            }

            // Verify service exists
            $service = $this->serviceRepository->findById($serviceId);
            if (!$service) {
                throw new NotFoundException('Service not found');
            }

            $students = [];

            // If query is provided, search by student_no or phone
            if (!empty($query)) {
                // Search by student_no or phone
                $allStudents = $this->studentRepository->search($query, 100, 0);

                // Filter by student_no or phone match
                $students = array_filter($allStudents, function ($student) use ($query) {
                    $lowerQuery = strtolower($query);
                    return strpos(strtolower($student['student_no'] ?? ''), $lowerQuery) !== false ||
                           strpos(strtolower($student['phone'] ?? ''), $lowerQuery) !== false;
                });
            } else {
                // Get all students with optional filters
                $students = $this->studentRepository->findAll(100, 0);

                // Apply filters
                if ($program) {
                    $students = array_filter($students, function ($student) use ($program) {
                        return $student['program'] === $program;
                    });
                }

                if ($faculty) {
                    $students = array_filter($students, function ($student) use ($faculty) {
                        return $student['faculty'] === $faculty;
                    });
                }
            }

            // Reset array keys
            $students = array_values($students);

            ResponseHelper::success($students, 'Students retrieved successfully');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }

    /**
     * Mark attendance for a student
     * POST /api/v1/attendance/mark
     * Body: {serviceId, studentId, status}
     *
     * @param array<string, mixed> $data Request body data
     * @param array<string, mixed> $request Request with user data
     * @return void
     */
    public function mark(array $data, array $request): void
    {
        try {
            // Validate input
            $this->validator->validateAttendanceCreate($data);

            $serviceId = $data['service_id'];
            $studentId = $data['student_id'];
            $status = $data['status'];
            $markedBy = $request['user']['id'] ?? null;

            if (!$markedBy) {
                throw new ValidationException('User not authenticated');
            }

            // Verify service exists
            $service = $this->serviceRepository->findById($serviceId);
            if (!$service) {
                throw new NotFoundException('Service not found');
            }

            // Verify student exists
            $student = $this->studentRepository->findById($studentId);
            if (!$student) {
                throw new NotFoundException('Student not found');
            }

            // Check if attendance record already exists
            $existingAttendance = $this->attendanceRepository->findByServiceAndStudent($serviceId, $studentId);

            if ($existingAttendance) {
                // Update existing record (idempotent)
                $this->attendanceRepository->update($existingAttendance['id'], [
                    'status' => $status,
                    'marked_by' => $markedBy,
                ]);
                $attendanceId = $existingAttendance['id'];
            } else {
                // Create new record
                $attendanceId = \Ramsey\Uuid\Uuid::uuid4()->toString();
                $this->attendanceRepository->create([
                    'id' => $attendanceId,
                    'service_id' => $serviceId,
                    'student_id' => $studentId,
                    'status' => $status,
                    'marked_by' => $markedBy,
                ]);
            }

            // Fetch the attendance record
            $attendance = $this->attendanceRepository->findById($attendanceId);

            ResponseHelper::success($attendance, 'Attendance marked successfully');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }

    /**
     * Get attendance records for a service
     * GET /api/v1/attendance/service/:serviceId
     *
     * @param string $serviceId Service ID
     * @return void
     */
    public function getServiceAttendance(string $serviceId): void
    {
        try {
            // Verify service exists
            $service = $this->serviceRepository->findById($serviceId);
            if (!$service) {
                throw new NotFoundException('Service not found');
            }

            // Get attendance records
            $attendance = $this->attendanceRepository->getByService($serviceId);

            // Get statistics
            $stats = $this->attendanceRepository->getServiceStats($serviceId);

            ResponseHelper::success([
                'service' => $service,
                'attendance' => $attendance,
                'statistics' => $stats,
            ], 'Service attendance retrieved successfully');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }

    /**
     * Get attendance records for a student
     * GET /api/v1/attendance/student/:studentId
     *
     * @param string $studentId Student ID
     * @param array<string, mixed> $params Query parameters (semesterId?)
     * @return void
     */
    public function getStudentAttendance(string $studentId, array $params): void
    {
        try {
            // Verify student exists
            $student = $this->studentRepository->findById($studentId);
            if (!$student) {
                throw new NotFoundException('Student not found');
            }

            $semesterId = $params['semesterId'] ?? null;

            // Get attendance records
            $attendance = $this->attendanceRepository->getByStudent($studentId);

            // Get statistics
            $stats = $this->attendanceRepository->getStudentStats($studentId, $semesterId);

            ResponseHelper::success([
                'student' => $student,
                'attendance' => $attendance,
                'statistics' => $stats,
            ], 'Student attendance retrieved successfully');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }

    /**
     * Bulk mark attendance for multiple students
     * POST /api/v1/attendance/bulk
     * Body: {serviceId, attendanceRecords: [{studentId, status}]}
     *
     * @param array<string, mixed> $data Request body data
     * @param array<string, mixed> $request Request with user data
     * @return void
     */
    public function bulkMark(array $data, array $request): void
    {
        try {
            $serviceId = $data['serviceId'] ?? null;
            $attendanceRecords = $data['attendanceRecords'] ?? [];
            $markedBy = $request['user']['id'] ?? null;

            if (!$serviceId) {
                throw new ValidationException('Service ID is required', [
                    'serviceId' => ['Service ID is required']
                ]);
            }

            if (!$markedBy) {
                throw new ValidationException('User not authenticated');
            }

            if (empty($attendanceRecords)) {
                throw new ValidationException('No attendance records provided', [
                    'attendanceRecords' => ['At least one attendance record is required']
                ]);
            }

            // Verify service exists
            $service = $this->serviceRepository->findById($serviceId);
            if (!$service) {
                throw new NotFoundException('Service not found');
            }

            // Process bulk attendance
            $count = $this->attendanceRepository->bulkMarkAttendance($serviceId, $attendanceRecords, $markedBy);

            ResponseHelper::success([
                'count' => $count,
                'message' => sprintf('%d attendance records processed', $count),
            ], 'Bulk attendance marked successfully');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }

    /**
     * Mark attendance for a lecturer
     * POST /api/v1/attendance/mark-lecturer
     * Body: {serviceId, lecturerId, status}
     *
     * @param array<string, mixed> $data Request body data
     * @param array<string, mixed> $request Request with user data
     * @return void
     */
    public function markLecturer(array $data, array $request): void
    {
        try {
            $serviceId = $data['service_id'] ?? null;
            $lecturerId = $data['lecturer_id'] ?? null;
            $status = $data['status'] ?? 'PRESENT';
            $markedBy = $request['user']['id'] ?? null;

            if (!$serviceId || !$lecturerId) {
                throw new ValidationException('Service ID and Lecturer ID are required');
            }

            if (!$markedBy) {
                throw new ValidationException('User not authenticated');
            }

            // Verify service exists
            $service = $this->serviceRepository->findById($serviceId);
            if (!$service) {
                throw new NotFoundException('Service not found');
            }

            // Verify lecturer exists
            $lecturer = $this->lecturerRepository->findById($lecturerId);
            if (!$lecturer) {
                throw new NotFoundException('Lecturer not found');
            }

            // Check if attendance record already exists
            $existingAttendance = $this->lecturerAttendanceRepository->findByServiceAndLecturer($serviceId, $lecturerId);

            if ($existingAttendance) {
                // Update existing record (idempotent)
                $this->lecturerAttendanceRepository->update($existingAttendance['id'], [
                    'status' => $status,
                    'marked_by' => $markedBy,
                ]);
                $attendanceId = $existingAttendance['id'];
            } else {
                // Create new record
                $attendanceId = \Ramsey\Uuid\Uuid::uuid4()->toString();
                $this->lecturerAttendanceRepository->create([
                    'id' => $attendanceId,
                    'service_id' => $serviceId,
                    'lecturer_id' => $lecturerId,
                    'status' => $status,
                    'marked_by' => $markedBy,
                ]);
            }

            // Fetch the attendance record
            $attendance = $this->lecturerAttendanceRepository->findById($attendanceId);

            ResponseHelper::success($attendance, 'Lecturer attendance marked successfully');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }

    /**
     * Get lecturer attendance records for a service
     * GET /api/v1/attendance/service/:serviceId/lecturers
     *
     * @param string $serviceId Service ID
     * @return void
     */
    public function getServiceLecturerAttendance(string $serviceId): void
    {
        try {
            // Verify service exists
            $service = $this->serviceRepository->findById($serviceId);
            if (!$service) {
                throw new NotFoundException('Service not found');
            }

            // Get attendance records
            $attendance = $this->lecturerAttendanceRepository->getByService($serviceId);

            // Get statistics
            $stats = $this->lecturerAttendanceRepository->getServiceStats($serviceId);

            ResponseHelper::success([
                'service' => $service,
                'attendance' => $attendance,
                'statistics' => $stats,
            ], 'Service lecturer attendance retrieved successfully');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }

    /**
     * Get attendance records for a lecturer
     * GET /api/v1/attendance/lecturer/:lecturerId
     *
     * @param string $lecturerId Lecturer ID
     * @param array<string, mixed> $params Query parameters (semesterId?)
     * @return void
     */
    public function getLecturerAttendance(string $lecturerId, array $params): void
    {
        try {
            // Verify lecturer exists
            $lecturer = $this->lecturerRepository->findById($lecturerId);
            if (!$lecturer) {
                throw new NotFoundException('Lecturer not found');
            }

            $semesterId = $params['semesterId'] ?? null;

            // Get attendance records
            $attendance = $this->lecturerAttendanceRepository->getByLecturer($lecturerId);

            // Get statistics
            $stats = $this->lecturerAttendanceRepository->getLecturerStats($lecturerId, $semesterId);

            ResponseHelper::success([
                'lecturer' => $lecturer,
                'attendance' => $attendance,
                'statistics' => $stats,
            ], 'Lecturer attendance retrieved successfully');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }

    /**
     * Search lecturers for attendance marking
     * POST /api/v1/attendance/search-lecturers
     * Body: {serviceId, department?, faculty?, query?}
     *
     * @param array<string, mixed> $data Request body data
     * @return void
     */
    public function searchLecturers(array $data): void
    {
        try {
            $serviceId = $data['serviceId'] ?? null;
            $department = $data['department'] ?? null;
            $faculty = $data['faculty'] ?? null;
            $query = $data['query'] ?? '';

            if (!$serviceId) {
                throw new ValidationException('Service ID is required', [
                    'serviceId' => ['Service ID is required']
                ]);
            }

            // Verify service exists
            $service = $this->serviceRepository->findById($serviceId);
            if (!$service) {
                throw new NotFoundException('Service not found');
            }

            $lecturers = [];

            // If query is provided, search by lecturer_no or phone
            if (!empty($query)) {
                $lecturers = $this->lecturerRepository->search($query, 100, 0);
            } else {
                // Get all lecturers with optional filters
                $lecturers = $this->lecturerRepository->findAll(100, 0);

                // Apply filters
                if ($department) {
                    $lecturers = array_filter($lecturers, function ($lecturer) use ($department) {
                        return $lecturer['department'] === $department;
                    });
                }

                if ($faculty) {
                    $lecturers = array_filter($lecturers, function ($lecturer) use ($faculty) {
                        return $lecturer['faculty'] === $faculty;
                    });
                }
            }

            // Reset array keys
            $lecturers = array_values($lecturers);

            ResponseHelper::success($lecturers, 'Lecturers retrieved successfully');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }
}
