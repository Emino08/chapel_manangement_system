<?php

namespace Chapel\Controllers;

use Chapel\Repositories\ServiceRepository;
use Chapel\Repositories\PastorRepository;
use Chapel\Utils\Validator;
use Chapel\Utils\ResponseHelper;
use Chapel\Exceptions\NotFoundException;
use Chapel\Exceptions\ValidationException;

/**
 * ServiceController
 *
 * Handles chapel service management operations
 */
class ServiceController
{
    private ServiceRepository $serviceRepository;
    private PastorRepository $pastorRepository;
    private Validator $validator;

    public function __construct(
        ServiceRepository $serviceRepository,
        PastorRepository $pastorRepository,
        Validator $validator
    ) {
        $this->serviceRepository = $serviceRepository;
        $this->pastorRepository = $pastorRepository;
        $this->validator = $validator;
    }

    /**
     * List all services with pagination
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

            $services = $this->serviceRepository->getWithPastorDetails($limit, $offset);
            $total = $this->serviceRepository->count();

            ResponseHelper::paginated($services, $total, $page, $limit, 'Services retrieved successfully');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }

    /**
     * Get a single service by ID
     *
     * @param string $id Service ID
     * @return void
     */
    public function show(string $id): void
    {
        try {
            $service = $this->serviceRepository->getWithDetails($id);

            if (!$service) {
                throw new NotFoundException('Service not found');
            }

            ResponseHelper::success($service, 'Service retrieved successfully');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }

    /**
     * Create a new service
     *
     * @param array<string, mixed> $data Request body data
     * @return void
     */
    public function create(array $data): void
    {
        try {
            // Validate input
            $this->validator->validateServiceCreate($data);

            // Check if service date already exists
            if ($this->serviceRepository->dateExists($data['service_date'])) {
                throw new ValidationException('A service already exists on this date', [
                    'service_date' => ['Service date is already taken']
                ]);
            }

            // Validate pastor exists if provided
            if (isset($data['pastor_id']) && !empty($data['pastor_id'])) {
                $pastor = $this->pastorRepository->findById($data['pastor_id']);
                if (!$pastor) {
                    throw new ValidationException('Pastor not found', [
                        'pastor_id' => ['Invalid pastor ID']
                    ]);
                }
            }

            // Create service
            $serviceId = \Ramsey\Uuid\Uuid::uuid4()->toString();
            $this->serviceRepository->create([
                'id' => $serviceId,
                'service_date' => $data['service_date'],
                'start_time' => $data['start_time'],
                'end_time' => $data['end_time'],
                'theme' => $data['theme'] ?? null,
                'pastor_id' => $data['pastor_id'] ?? null,
            ]);

            // Fetch created service with details
            $service = $this->serviceRepository->getWithDetails($serviceId);

            ResponseHelper::created($service, 'Service created successfully');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }

    /**
     * Update an existing service
     *
     * @param string $id Service ID
     * @param array<string, mixed> $data Request body data
     * @return void
     */
    public function update(string $id, array $data): void
    {
        try {
            // Check if service exists
            $service = $this->serviceRepository->findById($id);
            if (!$service) {
                throw new NotFoundException('Service not found');
            }

            // Prepare update data
            $updateData = [];

            if (isset($data['service_date'])) {
                // Check if service date already exists (excluding current service)
                if ($this->serviceRepository->dateExists($data['service_date'], $id)) {
                    throw new ValidationException('A service already exists on this date', [
                        'service_date' => ['Service date is already taken']
                    ]);
                }
                $updateData['service_date'] = $data['service_date'];
            }

            if (isset($data['start_time'])) {
                $updateData['start_time'] = $data['start_time'];
            }

            if (isset($data['end_time'])) {
                $updateData['end_time'] = $data['end_time'];
            }

            if (isset($data['theme'])) {
                $updateData['theme'] = $data['theme'];
            }

            if (isset($data['pastor_id'])) {
                // Validate pastor exists if provided
                if (!empty($data['pastor_id'])) {
                    $pastor = $this->pastorRepository->findById($data['pastor_id']);
                    if (!$pastor) {
                        throw new ValidationException('Pastor not found', [
                            'pastor_id' => ['Invalid pastor ID']
                        ]);
                    }
                }
                $updateData['pastor_id'] = $data['pastor_id'];
            }

            // Update service
            $this->serviceRepository->update($id, $updateData);

            // Fetch updated service
            $updatedService = $this->serviceRepository->getWithDetails($id);

            ResponseHelper::success($updatedService, 'Service updated successfully');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }

    /**
     * Delete a service
     *
     * @param string $id Service ID
     * @return void
     */
    public function delete(string $id): void
    {
        try {
            // Check if service exists
            $service = $this->serviceRepository->findById($id);
            if (!$service) {
                throw new NotFoundException('Service not found');
            }

            // Delete service
            $this->serviceRepository->delete($id);

            ResponseHelper::success(null, 'Service deleted successfully');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }

    /**
     * Get services by date range
     *
     * @param array<string, mixed> $params Query parameters (start_date, end_date)
     * @return void
     */
    public function getByDateRange(array $params): void
    {
        try {
            $startDate = $params['start_date'] ?? null;
            $endDate = $params['end_date'] ?? null;

            if (!$startDate || !$endDate) {
                throw new ValidationException('Both start_date and end_date are required', [
                    'start_date' => !$startDate ? ['Start date is required'] : [],
                    'end_date' => !$endDate ? ['End date is required'] : [],
                ]);
            }

            // Validate date format
            if (!$this->validator->isDate($startDate) || !$this->validator->isDate($endDate)) {
                throw new ValidationException('Invalid date format. Use Y-m-d format', [
                    'start_date' => ['Invalid date format'],
                    'end_date' => ['Invalid date format'],
                ]);
            }

            $services = $this->serviceRepository->findByDateRange($startDate, $endDate);

            ResponseHelper::success($services, 'Services retrieved successfully');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }

    /**
     * Get upcoming services
     *
     * @param array<string, mixed> $params Query parameters (limit)
     * @return void
     */
    public function getUpcoming(array $params): void
    {
        try {
            $limit = (int) ($params['limit'] ?? 10);

            $services = $this->serviceRepository->getUpcoming($limit);

            ResponseHelper::success($services, 'Upcoming services retrieved successfully');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }
}
