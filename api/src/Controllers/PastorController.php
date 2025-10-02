<?php

namespace Chapel\Controllers;

use Chapel\Repositories\PastorRepository;
use Chapel\Utils\Validator;
use Chapel\Utils\ResponseHelper;
use Chapel\Utils\CsvParser;
use Chapel\Utils\ExcelHandler;
use Chapel\Exceptions\NotFoundException;
use Chapel\Exceptions\ValidationException;

/**
 * PastorController
 *
 * Handles pastor management operations
 */
class PastorController
{
    private PastorRepository $pastorRepository;
    private Validator $validator;
    private CsvParser $csvParser;
    private ExcelHandler $excelHandler;

    public function __construct(
        PastorRepository $pastorRepository,
        Validator $validator,
        CsvParser $csvParser,
        ExcelHandler $excelHandler
    ) {
        $this->pastorRepository = $pastorRepository;
        $this->validator = $validator;
        $this->csvParser = $csvParser;
        $this->excelHandler = $excelHandler;
    }

    /**
     * List all pastors with pagination
     *
     * @param array<string, mixed> $params Query parameters (page, limit)
     * @return void
     */
    public function index(array $params): void
    {
        try {
            $page = (int) ($params['page'] ?? 1);
            $limit = (int) ($params['limit'] ?? 50);
            $offset = ($page - 1) * $limit;

            $pastors = $this->pastorRepository->findAll($limit, $offset);
            $total = $this->pastorRepository->count();

            ResponseHelper::paginated($pastors, $total, $page, $limit, 'Pastors retrieved successfully');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }

    /**
     * Get a single pastor by ID
     *
     * @param string $id Pastor ID
     * @return void
     */
    public function show(string $id): void
    {
        try {
            $pastor = $this->pastorRepository->findById($id);

            if (!$pastor) {
                throw new NotFoundException('Pastor not found');
            }

            ResponseHelper::success($pastor, 'Pastor retrieved successfully');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }

    /**
     * Create a new pastor
     *
     * @param array<string, mixed> $data Request body data
     * @return void
     */
    public function create(array $data): void
    {
        try {
            // Validate input
            $this->validator->validatePastorCreate($data);

            // Check if pastor code already exists
            if ($this->pastorRepository->codeExists($data['code'])) {
                throw new ValidationException('Pastor code already exists', [
                    'code' => ['Pastor code is already taken']
                ]);
            }

            // Check if phone already exists (if provided)
            if (isset($data['phone']) && !empty($data['phone'])) {
                if ($this->pastorRepository->phoneExists($data['phone'])) {
                    throw new ValidationException('Phone number already exists', [
                        'phone' => ['Phone number is already taken']
                    ]);
                }
            }

            // Create pastor
            $pastorId = \Ramsey\Uuid\Uuid::uuid4()->toString();
            $this->pastorRepository->create([
                'id' => $pastorId,
                'code' => $data['code'],
                'name' => $data['name'],
                'phone' => $data['phone'] ?? null,
                'program' => $data['program'] ?? null,
            ]);

            // Fetch created pastor
            $pastor = $this->pastorRepository->findById($pastorId);

            ResponseHelper::created($pastor, 'Pastor created successfully');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }

    /**
     * Update an existing pastor
     *
     * @param string $id Pastor ID
     * @param array<string, mixed> $data Request body data
     * @return void
     */
    public function update(string $id, array $data): void
    {
        try {
            // Check if pastor exists
            $pastor = $this->pastorRepository->findById($id);
            if (!$pastor) {
                throw new NotFoundException('Pastor not found');
            }

            // Prepare update data
            $updateData = [];

            if (isset($data['code'])) {
                // Check if pastor code already exists (excluding current pastor)
                if ($this->pastorRepository->codeExists($data['code'], $id)) {
                    throw new ValidationException('Pastor code already exists', [
                        'code' => ['Pastor code is already taken']
                    ]);
                }
                $updateData['code'] = $data['code'];
            }

            if (isset($data['name'])) {
                $updateData['name'] = $data['name'];
            }

            if (isset($data['phone'])) {
                // Check if phone already exists (excluding current pastor)
                if (!empty($data['phone']) && $this->pastorRepository->phoneExists($data['phone'], $id)) {
                    throw new ValidationException('Phone number already exists', [
                        'phone' => ['Phone number is already taken']
                    ]);
                }
                $updateData['phone'] = $data['phone'];
            }

            if (isset($data['program'])) {
                $updateData['program'] = $data['program'];
            }

            // Update pastor
            $this->pastorRepository->update($id, $updateData);

            // Fetch updated pastor
            $updatedPastor = $this->pastorRepository->findById($id);

            ResponseHelper::success($updatedPastor, 'Pastor updated successfully');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }

    /**
     * Delete a pastor
     *
     * @param string $id Pastor ID
     * @return void
     */
    public function delete(string $id): void
    {
        try {
            // Check if pastor exists
            $pastor = $this->pastorRepository->findById($id);
            if (!$pastor) {
                throw new NotFoundException('Pastor not found');
            }

            // Delete pastor
            $this->pastorRepository->delete($id);

            ResponseHelper::success(null, 'Pastor deleted successfully');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }

    /**
     * Search pastors
     *
     * @param array<string, mixed> $params Query parameters (query, page, limit)
     * @return void
     */
    public function search(array $params): void
    {
        try {
            $query = $params['query'] ?? '';
            $page = (int) ($params['page'] ?? 1);
            $limit = (int) ($params['limit'] ?? 50);
            $offset = ($page - 1) * $limit;

            $pastors = $this->pastorRepository->search($query, $limit, $offset);

            // For simplicity, we'll estimate total count based on results
            $total = count($pastors);

            ResponseHelper::paginated($pastors, $total, $page, $limit, 'Pastors found');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }

    /**
     * Bulk upload pastors from CSV file
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

            // For pastor CSV, we need to customize the parser
            $parser = clone $this->csvParser;
            $parser->setRequiredColumns(['Code', 'Name']);
            $parser->setOptionalColumns(['Phone', 'Email']);

            // Parse file
            if ($fileExt === 'csv') {
                $rawRecords = $parser->parseFile($filePath);
            } elseif (in_array($fileExt, ['xlsx', 'xls'])) {
                // For Excel files, we'd need a custom parser for pastors
                throw new ValidationException('Excel format not yet supported for pastors. Please use CSV format.');
            } else {
                throw new ValidationException('Invalid file format. Only CSV files are supported.');
            }

            $inserted = 0;
            $updated = 0;
            $errors = [];

            // Process each pastor (upsert by code)
            foreach ($rawRecords as $index => $record) {
                try {
                    // Map CSV fields to database fields
                    $pastorData = [
                        'code' => $record['student_no'] ?? ($record['code'] ?? ''), // CSV parser uses student_no key
                        'name' => $record['name'],
                        'phone' => $record['phone'] ?? null,
                        'email' => $record['email'] ?? null,
                    ];

                    // Check if pastor exists by code
                    $existingPastor = $this->pastorRepository->findByCode($pastorData['code']);

                    if ($existingPastor) {
                        // Update existing pastor
                        $this->pastorRepository->update($existingPastor['id'], [
                            'name' => $pastorData['name'],
                            'phone' => $pastorData['phone'],
                            'email' => $pastorData['email'],
                        ]);
                        $updated++;
                    } else {
                        // Insert new pastor
                        $pastorId = \Ramsey\Uuid\Uuid::uuid4()->toString();
                        $this->pastorRepository->create([
                            'id' => $pastorId,
                            'code' => $pastorData['code'],
                            'name' => $pastorData['name'],
                            'phone' => $pastorData['phone'],
                            'email' => $pastorData['email'],
                        ]);
                        $inserted++;
                    }
                } catch (\Exception $e) {
                    $errors[] = [
                        'row' => $index + 2,
                        'code' => $record['code'] ?? 'N/A',
                        'error' => $e->getMessage(),
                    ];
                }
            }

            ResponseHelper::success([
                'summary' => [
                    'total' => count($rawRecords),
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
