<?php

namespace Chapel\Controllers;

use Chapel\Repositories\UserRepository;
use Chapel\Utils\Validator;
use Chapel\Utils\ResponseHelper;
use Chapel\Exceptions\NotFoundException;
use Chapel\Exceptions\ValidationException;

/**
 * UserController
 *
 * Handles user management operations (ADMIN only)
 */
class UserController
{
    private UserRepository $userRepository;
    private Validator $validator;

    public function __construct(UserRepository $userRepository, Validator $validator)
    {
        $this->userRepository = $userRepository;
        $this->validator = $validator;
    }

    /**
     * List all users with pagination
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

            $users = $this->userRepository->findAll($limit, $offset);
            $total = $this->userRepository->count();

            // Remove password_hash from all users
            $users = array_map(function ($user) {
                unset($user['password_hash']);
                return $user;
            }, $users);

            ResponseHelper::paginated($users, $total, $page, $limit, 'Users retrieved successfully');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }

    /**
     * Get a single user by ID
     *
     * @param string $id User ID
     * @return void
     */
    public function show(string $id): void
    {
        try {
            $user = $this->userRepository->findById($id);

            if (!$user) {
                throw new NotFoundException('User not found');
            }

            // Remove password_hash
            unset($user['password_hash']);

            ResponseHelper::success($user, 'User retrieved successfully');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }

    /**
     * Create a new user
     *
     * @param array<string, mixed> $data Request body data
     * @return void
     */
    public function create(array $data): void
    {
        try {
            // Validate input
            $this->validator->validateUserCreate($data);

            // Check if email already exists
            if ($this->userRepository->emailExists($data['email'])) {
                throw new ValidationException('Email already exists', ['email' => ['Email is already taken']]);
            }

            // Hash password
            $passwordHash = password_hash($data['password'], PASSWORD_BCRYPT);

            // Create user
            $userId = \Ramsey\Uuid\Uuid::uuid4()->toString();
            $this->userRepository->create([
                'id' => $userId,
                'name' => $data['name'],
                'email' => $data['email'],
                'role' => $data['role'],
                'password_hash' => $passwordHash,
                'must_change_password' => 1, // Force password change on first login
            ]);

            // Fetch created user
            $user = $this->userRepository->findById($userId);
            unset($user['password_hash']);

            ResponseHelper::created($user, 'User created successfully');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }

    /**
     * Update an existing user
     *
     * @param string $id User ID
     * @param array<string, mixed> $data Request body data
     * @return void
     */
    public function update(string $id, array $data): void
    {
        try {
            // Check if user exists
            $user = $this->userRepository->findById($id);
            if (!$user) {
                throw new NotFoundException('User not found');
            }

            // Validate input
            $this->validator->validateUserUpdate($data);

            // Check if email already exists (excluding current user)
            if (isset($data['email']) && $this->userRepository->emailExists($data['email'], $id)) {
                throw new ValidationException('Email already exists', ['email' => ['Email is already taken']]);
            }

            // Prepare update data
            $updateData = [];
            if (isset($data['name'])) {
                $updateData['name'] = $data['name'];
            }
            if (isset($data['email'])) {
                $updateData['email'] = $data['email'];
            }
            if (isset($data['role'])) {
                $updateData['role'] = $data['role'];
            }
            if (isset($data['password'])) {
                $updateData['password_hash'] = password_hash($data['password'], PASSWORD_BCRYPT);
            }

            // Update user
            $this->userRepository->update($id, $updateData);

            // Fetch updated user
            $updatedUser = $this->userRepository->findById($id);
            unset($updatedUser['password_hash']);

            ResponseHelper::success($updatedUser, 'User updated successfully');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }

    /**
     * Delete a user
     *
     * @param string $id User ID
     * @return void
     */
    public function delete(string $id): void
    {
        try {
            // Check if user exists
            $user = $this->userRepository->findById($id);
            if (!$user) {
                throw new NotFoundException('User not found');
            }

            // Delete user
            $this->userRepository->delete($id);

            ResponseHelper::success(null, 'User deleted successfully');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }
}
