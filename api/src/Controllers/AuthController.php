<?php

namespace Chapel\Controllers;

use Chapel\Repositories\UserRepository;
use Chapel\Utils\JwtHelper;
use Chapel\Utils\Validator;
use Chapel\Utils\ResponseHelper;
use Chapel\Exceptions\UnauthorizedException;

/**
 * AuthController
 *
 * Handles authentication operations
 */
class AuthController
{
    private UserRepository $userRepository;
    private JwtHelper $jwtHelper;
    private Validator $validator;

    public function __construct(UserRepository $userRepository, JwtHelper $jwtHelper, Validator $validator)
    {
        $this->userRepository = $userRepository;
        $this->jwtHelper = $jwtHelper;
        $this->validator = $validator;
    }

    /**
     * Login endpoint
     *
     * @param array<string, mixed> $data Request body data
     * @return void
     */
    public function login(array $data): void
    {
        try {
            // Debug logging to see what we're receiving
            error_log("AuthController::login - Received data: " . json_encode($data));
            error_log("AuthController::login - Data type: " . gettype($data));
            error_log("AuthController::login - Email isset: " . (isset($data['email']) ? 'YES' : 'NO'));
            error_log("AuthController::login - Email value: " . ($data['email'] ?? 'NULL'));

            // Validate input
            $this->validator->validateLogin($data);

            $email = $data['email'];
            $password = $data['password'];

            // Find user by email
            $user = $this->userRepository->findByEmail($email);

            if (!$user) {
                throw new UnauthorizedException('Invalid email or password');
            }

            // Verify password
            if (!password_verify($password, $user['password_hash'])) {
                throw new UnauthorizedException('Invalid email or password');
            }

            // Generate JWT token
            $token = $this->jwtHelper->generateUserToken(
                $user['id'],
                $user['email'],
                $user['role']
            );

            // Remove sensitive data from user object
            unset($user['password_hash']);

            // Return success response with token and user info
            ResponseHelper::success([
                'token' => $token,
                'user' => $user,
                'mustChangePassword' => (bool) ($user['must_change_password'] ?? 0),
            ], 'Login successful');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }

    /**
     * Get current user profile
     *
     * @param array<string, mixed> $request Request with user data from middleware
     * @return void
     */
    public function me(array $request): void
    {
        try {
            $userId = $request['user']['id'] ?? null;

            if (!$userId) {
                throw new UnauthorizedException('User not authenticated');
            }

            $user = $this->userRepository->findById($userId);

            if (!$user) {
                throw new UnauthorizedException('User not found');
            }

            // Remove sensitive data
            unset($user['password_hash']);

            ResponseHelper::success($user, 'User profile retrieved successfully');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }

    /**
     * Change user password
     *
     * @param array<string, mixed> $request Request with user data from middleware
     * @param array<string, mixed> $data Request body data
     * @return void
     */
    public function changePassword(array $request, array $data): void
    {
        try {
            $userId = $request['user']['id'] ?? null;

            if (!$userId) {
                throw new UnauthorizedException('User not authenticated');
            }

            // Validate input
            $this->validator->validatePasswordChange($data);

            $currentPassword = $data['currentPassword'];
            $newPassword = $data['newPassword'];

            // Find user
            $user = $this->userRepository->findById($userId);

            if (!$user) {
                throw new UnauthorizedException('User not found');
            }

            // Verify current password (skip if must_change_password is true - first time login)
            if (!$user['must_change_password']) {
                if (!password_verify($currentPassword, $user['password_hash'])) {
                    throw new UnauthorizedException('Current password is incorrect');
                }
            }

            // Hash new password
            $passwordHash = password_hash($newPassword, PASSWORD_BCRYPT);

            // Update password and clear must_change_password flag
            $this->userRepository->update($userId, [
                'password_hash' => $passwordHash,
                'must_change_password' => 0,
            ]);

            ResponseHelper::success(null, 'Password changed successfully');
        } catch (\Exception $e) {
            ResponseHelper::handleException($e);
        }
    }
}
