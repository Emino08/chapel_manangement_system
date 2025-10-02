<?php

namespace Chapel\Controllers;

use Chapel\Repositories\LecturerRepository;
use Chapel\Utils\Validator;
use Chapel\Utils\ResponseHelper;
use Chapel\Utils\CsvParser;
use Chapel\Utils\ExcelHandler;
use Chapel\Exceptions\NotFoundException;
use Chapel\Exceptions\ValidationException;

/**
 * LecturerController
 *
 * Handles lecturer management operations
 */
class LecturerController
{
    private LecturerRepository $lecturerRepository;
    private Validator $validator;
    private CsvParser $csvParser;
    private ExcelHandler $excelHandler;

    public function __construct(
        LecturerRepository $lecturerRepository,
        Validator $validator,
        CsvParser $csvParser,
        ExcelHandler $excelHandler
    ) {
        $this->lecturerRepository = $lecturerRepository;
        $this->validator = $validator;
        $this->csvParser = $csvParser;
        $this->excelHandler = $excelHandler;
    }

    /**
     * List all lecturers with pagination and optional filters
     *
     * @param array<string, mixed> $params Query parameters (page, limit, department, faculty, search)
     * @return void
     */
    public function index(array $params): void
    {
        try {
            $page = (int) ($params['page'] ?? 1);
            $limit = (int) ($params['limit'] ?? 50);
            $offset = ($page - 1) * $limit;

            $lecturers = $this->lecturerRepository->findAll($limit, $offset);
            $total = $this->lecturerRepository->count();

            ResponseHelper::paginated($lecturers, $total, $page, $limit, 'Lecturers retrieved successfully');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }

    /**
     * Get a single lecturer by ID
     *
     * @param string $id Lecturer ID
     * @return void
     */
    public function show(string $id): void
    {
        try {
            $lecturer = $this->lecturerRepository->findById($id);

            if (!$lecturer) {
                throw new NotFoundException('Lecturer not found');
            }

            ResponseHelper::success($lecturer, 'Lecturer retrieved successfully');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }

    /**
     * Create a new lecturer
     *
     * @param array<string, mixed> $data Request body data
     * @return void
     */
    public function create(array $data): void
    {
        try {
            // Validate required fields
            if (empty($data['lecturer_no']) || empty($data['name']) || empty($data['department'])) {
                throw new ValidationException('Lecturer number, name, and department are required fields');
            }

            // Check if lecturer number already exists
            if ($this->lecturerRepository->lecturerNoExists($data['lecturer_no'])) {
                throw new ValidationException('Lecturer number already exists', [
                    'lecturer_no' => ['Lecturer number is already taken']
                ]);
            }

            // Check if phone already exists (if provided)
            if (isset($data['phone']) && !empty($data['phone'])) {
                if ($this->lecturerRepository->phoneExists($data['phone'])) {
                    throw new ValidationException('Phone number already exists', [
                        'phone' => ['Phone number is already taken']
                    ]);
                }
            }

            // Create lecturer
            $lecturerId = \Ramsey\Uuid\Uuid::uuid4()->toString();
            $this->lecturerRepository->create([
                'id' => $lecturerId,
                'lecturer_no' => $data['lecturer_no'],
                'name' => $data['name'],
                'department' => $data['department'],
                'faculty' => $data['faculty'] ?? null,
                'phone' => $data['phone'] ?? null,
                'email' => $data['email'] ?? null,
                'position' => $data['position'] ?? null,
            ]);

            // Fetch created lecturer
            $lecturer = $this->lecturerRepository->findById($lecturerId);

            ResponseHelper::created($lecturer, 'Lecturer created successfully');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }

    /**
     * Update an existing lecturer
     *
     * @param string $id Lecturer ID
     * @param array<string, mixed> $data Request body data
     * @return void
     */
    public function update(string $id, array $data): void
    {
        try {
            // Check if lecturer exists
            $lecturer = $this->lecturerRepository->findById($id);
            if (!$lecturer) {
                throw new NotFoundException('Lecturer not found');
            }

            // Prepare update data
            $updateData = [];

            if (isset($data['lecturer_no'])) {
                // Check if lecturer number already exists (excluding current lecturer)
                if ($this->lecturerRepository->lecturerNoExists($data['lecturer_no'], $id)) {
                    throw new ValidationException('Lecturer number already exists', [
                        'lecturer_no' => ['Lecturer number is already taken']
                    ]);
                }
                $updateData['lecturer_no'] = $data['lecturer_no'];
            }

            if (isset($data['name'])) {
                $updateData['name'] = $data['name'];
            }

            if (isset($data['department'])) {
                $updateData['department'] = $data['department'];
            }

            if (isset($data['faculty'])) {
                $updateData['faculty'] = $data['faculty'];
            }

            if (isset($data['phone'])) {
                // Check if phone already exists (excluding current lecturer)
                if (!empty($data['phone']) && $this->lecturerRepository->phoneExists($data['phone'], $id)) {
                    throw new ValidationException('Phone number already exists', [
                        'phone' => ['Phone number is already taken']
                    ]);
                }
                $updateData['phone'] = $data['phone'];
            }

            if (isset($data['email'])) {
                $updateData['email'] = $data['email'];
            }

            if (isset($data['position'])) {
                $updateData['position'] = $data['position'];
            }

            // Update lecturer
            $this->lecturerRepository->update($id, $updateData);

            // Fetch updated lecturer
            $updatedLecturer = $this->lecturerRepository->findById($id);

            ResponseHelper::success($updatedLecturer, 'Lecturer updated successfully');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }

    /**
     * Delete a lecturer
     *
     * @param string $id Lecturer ID
     * @return void
     */
    public function delete(string $id): void
    {
        try {
            // Check if lecturer exists
            $lecturer = $this->lecturerRepository->findById($id);
            if (!$lecturer) {
                throw new NotFoundException('Lecturer not found');
            }

            // Delete lecturer
            $this->lecturerRepository->delete($id);

            ResponseHelper::success(null, 'Lecturer deleted successfully');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }

    /**
     * Search lecturers
     *
     * @param array<string, mixed> $params Query parameters (query, department, faculty, page, limit)
     * @return void
     */
    public function search(array $params): void
    {
        try {
            $query = $params['query'] ?? '';
            $page = (int) ($params['page'] ?? 1);
            $limit = (int) ($params['limit'] ?? 50);
            $offset = ($page - 1) * $limit;

            $lecturers = $this->lecturerRepository->search($query, $limit, $offset);

            // For simplicity, we'll estimate total count based on results
            // In production, you'd want a separate count query
            $total = count($lecturers);

            ResponseHelper::paginated($lecturers, $total, $page, $limit, 'Lecturers found');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }

    /**
     * Bulk upload lecturers from CSV file
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
                $lecturers = $this->csvParser->parseFile($filePath);
            } elseif (in_array($fileExt, ['xlsx', 'xls'])) {
                $lecturers = $this->excelHandler->parseLecturerFile($filePath);
            } else {
                throw new ValidationException('Invalid file format. Only CSV and Excel files are supported.');
            }

            $inserted = 0;
            $updated = 0;
            $errors = [];

            // Process each lecturer (upsert by lecturer_no)
            foreach ($lecturers as $index => $lecturerData) {
                try {
                    // Check if lecturer exists by lecturer_no
                    $existingLecturer = $this->lecturerRepository->findByLecturerNo($lecturerData['lecturer_no']);

                    if ($existingLecturer) {
                        // Update existing lecturer
                        $this->lecturerRepository->update($existingLecturer['id'], [
                            'name' => $lecturerData['name'],
                            'department' => $lecturerData['department'],
                            'faculty' => $lecturerData['faculty'] ?? null,
                            'phone' => $lecturerData['phone'] ?? null,
                            'email' => $lecturerData['email'] ?? null,
                            'position' => $lecturerData['position'] ?? null,
                        ]);
                        $updated++;
                    } else {
                        // Insert new lecturer
                        $lecturerId = \Ramsey\Uuid\Uuid::uuid4()->toString();
                        $this->lecturerRepository->create([
                            'id' => $lecturerId,
                            'lecturer_no' => $lecturerData['lecturer_no'],
                            'name' => $lecturerData['name'],
                            'department' => $lecturerData['department'],
                            'faculty' => $lecturerData['faculty'] ?? null,
                            'phone' => $lecturerData['phone'] ?? null,
                            'email' => $lecturerData['email'] ?? null,
                            'position' => $lecturerData['position'] ?? null,
                        ]);
                        $inserted++;
                    }
                } catch (\Exception $e) {
                    $errors[] = [
                        'row' => $index + 2, // +2 because index starts at 0 and row 1 is header
                        'lecturer_no' => $lecturerData['lecturer_no'] ?? 'N/A',
                        'error' => $e->getMessage(),
                    ];
                }
            }

            ResponseHelper::success([
                'summary' => [
                    'total' => count($lecturers),
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
