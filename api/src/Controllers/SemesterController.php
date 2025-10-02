<?php

namespace Chapel\Controllers;

use Chapel\Repositories\SemesterRepository;
use Chapel\Utils\Validator;
use Chapel\Utils\ResponseHelper;
use Chapel\Exceptions\NotFoundException;
use Chapel\Exceptions\ValidationException;

/**
 * SemesterController
 *
 * Handles semester management operations
 */
class SemesterController
{
    private SemesterRepository $semesterRepository;
    private Validator $validator;

    public function __construct(SemesterRepository $semesterRepository, Validator $validator)
    {
        $this->semesterRepository = $semesterRepository;
        $this->validator = $validator;
    }

    /**
     * List all semesters with pagination
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

            $semesters = $this->semesterRepository->findAll($limit, $offset);
            $total = $this->semesterRepository->count();

            ResponseHelper::paginated($semesters, $total, $page, $limit, 'Semesters retrieved successfully');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }

    /**
     * Get a single semester by ID
     *
     * @param string $id Semester ID
     * @return void
     */
    public function show(string $id): void
    {
        try {
            $semester = $this->semesterRepository->getWithServiceCount($id);

            if (!$semester) {
                throw new NotFoundException('Semester not found');
            }

            ResponseHelper::success($semester, 'Semester retrieved successfully');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }

    /**
     * Create a new semester
     *
     * @param array<string, mixed> $data Request body data
     * @return void
     */
    public function create(array $data): void
    {
        try {
            // Validate input
            $this->validator->validateSemesterCreate($data);

            // Check for date range overlap
            if ($this->semesterRepository->hasOverlap($data['start_date'], $data['end_date'])) {
                throw new ValidationException('Semester dates overlap with existing semester', [
                    'start_date' => ['Date range conflicts with another semester'],
                    'end_date' => ['Date range conflicts with another semester'],
                ]);
            }

            // Create semester
            $semesterId = \Ramsey\Uuid\Uuid::uuid4()->toString();
            $active = isset($data['active']) ? (bool) $data['active'] : false;

            // If this semester should be active, deactivate others first
            if ($active) {
                $this->semesterRepository->query("UPDATE semesters SET active = 0");
            }

            $this->semesterRepository->create([
                'id' => $semesterId,
                'name' => $data['name'],
                'start_date' => $data['start_date'],
                'end_date' => $data['end_date'],
                'active' => $active ? 1 : 0,
            ]);

            // Fetch created semester
            $semester = $this->semesterRepository->findById($semesterId);

            ResponseHelper::created($semester, 'Semester created successfully');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }

    /**
     * Update an existing semester
     *
     * @param string $id Semester ID
     * @param array<string, mixed> $data Request body data
     * @return void
     */
    public function update(string $id, array $data): void
    {
        try {
            // Check if semester exists
            $semester = $this->semesterRepository->findById($id);
            if (!$semester) {
                throw new NotFoundException('Semester not found');
            }

            // Prepare update data
            $updateData = [];

            if (isset($data['name'])) {
                $updateData['name'] = $data['name'];
            }

            if (isset($data['start_date']) || isset($data['end_date'])) {
                $startDate = $data['start_date'] ?? $semester['start_date'];
                $endDate = $data['end_date'] ?? $semester['end_date'];

                // Validate date range
                if (strtotime($endDate) <= strtotime($startDate)) {
                    throw new ValidationException('End date must be after start date', [
                        'end_date' => ['End date must be after start date']
                    ]);
                }

                // Check for date range overlap (excluding current semester)
                if ($this->semesterRepository->hasOverlap($startDate, $endDate, $id)) {
                    throw new ValidationException('Semester dates overlap with existing semester', [
                        'start_date' => ['Date range conflicts with another semester'],
                        'end_date' => ['Date range conflicts with another semester'],
                    ]);
                }

                if (isset($data['start_date'])) {
                    $updateData['start_date'] = $data['start_date'];
                }
                if (isset($data['end_date'])) {
                    $updateData['end_date'] = $data['end_date'];
                }
            }

            // Update semester
            $this->semesterRepository->update($id, $updateData);

            // Fetch updated semester
            $updatedSemester = $this->semesterRepository->findById($id);

            ResponseHelper::success($updatedSemester, 'Semester updated successfully');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }

    /**
     * Delete a semester
     *
     * @param string $id Semester ID
     * @return void
     */
    public function delete(string $id): void
    {
        try {
            // Check if semester exists
            $semester = $this->semesterRepository->findById($id);
            if (!$semester) {
                throw new NotFoundException('Semester not found');
            }

            // Delete semester
            $this->semesterRepository->delete($id);

            ResponseHelper::success(null, 'Semester deleted successfully');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }

    /**
     * Toggle active status of a semester
     *
     * @param string $id Semester ID
     * @return void
     */
    public function toggleActive(string $id): void
    {
        try {
            // Check if semester exists
            $semester = $this->semesterRepository->findById($id);
            if (!$semester) {
                throw new NotFoundException('Semester not found');
            }

            // Set this semester as active (will deactivate others)
            $this->semesterRepository->setActive($id);

            // Fetch updated semester
            $updatedSemester = $this->semesterRepository->findById($id);

            ResponseHelper::success($updatedSemester, 'Semester activated successfully');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }

    /**
     * Get the currently active semester
     *
     * @return void
     */
    public function getActive(): void
    {
        try {
            $semester = $this->semesterRepository->getActiveSemester();

            if (!$semester) {
                throw new NotFoundException('No active semester found');
            }

            ResponseHelper::success($semester, 'Active semester retrieved successfully');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }
}
