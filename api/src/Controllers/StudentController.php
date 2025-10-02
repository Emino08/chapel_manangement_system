<?php

namespace Chapel\Controllers;

use Chapel\Repositories\StudentRepository;
use Chapel\Utils\Validator;
use Chapel\Utils\ResponseHelper;
use Chapel\Utils\CsvParser;
use Chapel\Utils\ExcelHandler;
use Chapel\Exceptions\NotFoundException;
use Chapel\Exceptions\ValidationException;

/**
 * StudentController
 *
 * Handles student management operations
 */
class StudentController
{
    private StudentRepository $studentRepository;
    private Validator $validator;
    private CsvParser $csvParser;
    private ExcelHandler $excelHandler;

    public function __construct(
        StudentRepository $studentRepository,
        Validator $validator,
        CsvParser $csvParser,
        ExcelHandler $excelHandler
    ) {
        $this->studentRepository = $studentRepository;
        $this->validator = $validator;
        $this->csvParser = $csvParser;
        $this->excelHandler = $excelHandler;
    }

    /**
     * List all students with pagination and optional filters
     *
     * @param array<string, mixed> $params Query parameters (page, limit, program, faculty, level, search)
     * @return void
     */
    public function index(array $params): void
    {
        try {
            $page = (int) ($params['page'] ?? 1);
            $limit = (int) ($params['limit'] ?? 50);
            $offset = ($page - 1) * $limit;

            $students = $this->studentRepository->findAll($limit, $offset);
            $total = $this->studentRepository->count();

            ResponseHelper::paginated($students, $total, $page, $limit, 'Students retrieved successfully');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }

    /**
     * Get a single student by ID
     *
     * @param string $id Student ID
     * @return void
     */
    public function show(string $id): void
    {
        try {
            $student = $this->studentRepository->findById($id);

            if (!$student) {
                throw new NotFoundException('Student not found');
            }

            ResponseHelper::success($student, 'Student retrieved successfully');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }

    /**
     * Create a new student
     *
     * @param array<string, mixed> $data Request body data
     * @return void
     */
    public function create(array $data): void
    {
        try {
            // Validate input
            $this->validator->validateStudentCreate($data);

            // Check if student number already exists
            if ($this->studentRepository->studentNoExists($data['student_no'])) {
                throw new ValidationException('Student number already exists', [
                    'student_no' => ['Student number is already taken']
                ]);
            }

            // Check if phone already exists (if provided)
            if (isset($data['phone']) && !empty($data['phone'])) {
                if ($this->studentRepository->phoneExists($data['phone'])) {
                    throw new ValidationException('Phone number already exists', [
                        'phone' => ['Phone number is already taken']
                    ]);
                }
            }

            // Create student
            $studentId = \Ramsey\Uuid\Uuid::uuid4()->toString();
            $this->studentRepository->create([
                'id' => $studentId,
                'student_no' => $data['student_no'],
                'name' => $data['name'],
                'program' => $data['program'],
                'phone' => $data['phone'] ?? null,
                'faculty' => $data['faculty'] ?? null,
                'level' => $data['level'] ?? null,
            ]);

            // Fetch created student
            $student = $this->studentRepository->findById($studentId);

            ResponseHelper::created($student, 'Student created successfully');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }

    /**
     * Update an existing student
     *
     * @param string $id Student ID
     * @param array<string, mixed> $data Request body data
     * @return void
     */
    public function update(string $id, array $data): void
    {
        try {
            // Check if student exists
            $student = $this->studentRepository->findById($id);
            if (!$student) {
                throw new NotFoundException('Student not found');
            }

            // Prepare update data
            $updateData = [];

            if (isset($data['student_no'])) {
                // Check if student number already exists (excluding current student)
                if ($this->studentRepository->studentNoExists($data['student_no'], $id)) {
                    throw new ValidationException('Student number already exists', [
                        'student_no' => ['Student number is already taken']
                    ]);
                }
                $updateData['student_no'] = $data['student_no'];
            }

            if (isset($data['name'])) {
                $updateData['name'] = $data['name'];
            }

            if (isset($data['program'])) {
                $updateData['program'] = $data['program'];
            }

            if (isset($data['phone'])) {
                // Check if phone already exists (excluding current student)
                if (!empty($data['phone']) && $this->studentRepository->phoneExists($data['phone'], $id)) {
                    throw new ValidationException('Phone number already exists', [
                        'phone' => ['Phone number is already taken']
                    ]);
                }
                $updateData['phone'] = $data['phone'];
            }

            if (isset($data['faculty'])) {
                $updateData['faculty'] = $data['faculty'];
            }

            if (isset($data['level'])) {
                $updateData['level'] = $data['level'];
            }

            // Update student
            $this->studentRepository->update($id, $updateData);

            // Fetch updated student
            $updatedStudent = $this->studentRepository->findById($id);

            ResponseHelper::success($updatedStudent, 'Student updated successfully');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }

    /**
     * Delete a student
     *
     * @param string $id Student ID
     * @return void
     */
    public function delete(string $id): void
    {
        try {
            // Check if student exists
            $student = $this->studentRepository->findById($id);
            if (!$student) {
                throw new NotFoundException('Student not found');
            }

            // Delete student
            $this->studentRepository->delete($id);

            ResponseHelper::success(null, 'Student deleted successfully');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }

    /**
     * Search students
     *
     * @param array<string, mixed> $params Query parameters (query, program, faculty, level, page, limit)
     * @return void
     */
    public function search(array $params): void
    {
        try {
            $query = $params['query'] ?? '';
            $page = (int) ($params['page'] ?? 1);
            $limit = (int) ($params['limit'] ?? 50);
            $offset = ($page - 1) * $limit;

            $students = $this->studentRepository->search($query, $limit, $offset);

            // For simplicity, we'll estimate total count based on results
            // In production, you'd want a separate count query
            $total = count($students);

            ResponseHelper::paginated($students, $total, $page, $limit, 'Students found');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }

    /**
     * Bulk upload students from CSV file
     *
     * @param array<string, mixed> $files Uploaded files array
     * @return void
     */
    public function bulkUpload(array $files): void
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

            // Parse file based on extension
            if ($fileExt === 'csv') {
                $students = $this->csvParser->parseFile($filePath);
            } elseif (in_array($fileExt, ['xlsx', 'xls'])) {
                $students = $this->excelHandler->parseStudentFile($filePath);
            } else {
                throw new ValidationException('Invalid file format. Only CSV and Excel files are supported.');
            }

            $inserted = 0;
            $updated = 0;
            $errors = [];

            // Process each student (upsert by student_no)
            foreach ($students as $index => $studentData) {
                try {
                    // Check if student exists by student_no
                    $existingStudent = $this->studentRepository->findByStudentNo($studentData['student_no']);

                    if ($existingStudent) {
                        // Update existing student
                        $this->studentRepository->update($existingStudent['id'], [
                            'name' => $studentData['name'],
                            'program' => $studentData['program'],
                            'phone' => $studentData['phone'] ?? null,
                            'faculty' => $studentData['faculty'] ?? null,
                            'level' => $studentData['level'] ?? null,
                        ]);
                        $updated++;
                    } else {
                        // Insert new student
                        $studentId = \Ramsey\Uuid\Uuid::uuid4()->toString();
                        $this->studentRepository->create([
                            'id' => $studentId,
                            'student_no' => $studentData['student_no'],
                            'name' => $studentData['name'],
                            'program' => $studentData['program'],
                            'phone' => $studentData['phone'] ?? null,
                            'faculty' => $studentData['faculty'] ?? null,
                            'level' => $studentData['level'] ?? null,
                        ]);
                        $inserted++;
                    }
                } catch (\Exception $e) {
                    $errors[] = [
                        'row' => $index + 2, // +2 because index starts at 0 and row 1 is header
                        'student_no' => $studentData['student_no'] ?? 'N/A',
                        'error' => $e->getMessage(),
                    ];
                }
            }

            ResponseHelper::success([
                'summary' => [
                    'total' => count($students),
                    'inserted' => $inserted,
                    'updated' => $updated,
                    'errors' => count($errors),
                ],
                'errors' => $errors,
            ], 'Bulk upload completed');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }
}
