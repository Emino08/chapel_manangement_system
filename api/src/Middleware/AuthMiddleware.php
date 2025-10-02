<?php

namespace Chapel\Middleware;

use Chapel\Exceptions\UnauthorizedException;
use Chapel\Utils\JwtHelper;
use Chapel\Repositories\UserRepository;

/**
 * AuthMiddleware
 *
 * Verifies JWT token and attaches user to request
 */
class AuthMiddleware
{
    private JwtHelper $jwtHelper;
    private UserRepository $userRepository;

    public function __construct()
    {
        $this->jwtHelper = new JwtHelper();
        $this->userRepository = new UserRepository();
    }

    /**
     * Process the authentication middleware
     *
     * @param array<string, mixed> $request
     * @return array<string, mixed> Modified request with user data
     * @throws UnauthorizedException
     */
    public function process(array $request): array
    {
        $token = $this->extractToken($request);

        if (!$token) {
            throw new UnauthorizedException('No authentication token provided');
        }

        try {
            $payload = $this->jwtHelper->decode($token);

            // Verify user still exists
            $user = $this->userRepository->findById($payload['userId']);

            if (!$user) {
                throw new UnauthorizedException('User not found');
            }

            // Attach user to request
            $request['user'] = [
                'id' => $user['id'],
                'name' => $user['name'],
                'email' => $user['email'],
                'role' => $user['role'],
            ];

            return $request;
        } catch (\Exception $e) {
            throw new UnauthorizedException('Invalid or expired token: ' . $e->getMessage());
        }
    }

    /**
     * Extract token from Authorization header or query parameter
     *
     * @param array<string, mixed> $request
     * @return string|null
     */
    private function extractToken(array $request): ?string
    {
        // Check Authorization header
        $authHeader = $_SERVER['HTTP_AUTHORIZATION'] ?? $_SERVER['REDIRECT_HTTP_AUTHORIZATION'] ?? null;

        if ($authHeader && preg_match('/Bearer\s+(.*)$/i', $authHeader, $matches)) {
            return $matches[1];
        }

        // Fallback to query parameter
        if (isset($_GET['token'])) {
            return $_GET['token'];
        }

        return null;
    }

    /**
     * Static helper to get current user from request
     *
     * @param array<string, mixed> $request
     * @return array<string, mixed>|null
     */
    public static function getUser(array $request): ?array
    {
        return $request['user'] ?? null;
    }

    /**
     * Static helper to get current user ID from request
     *
     * @param array<string, mixed> $request
     * @return string|null
     */
    public static function getUserId(array $request): ?string
    {
        return $request['user']['id'] ?? null;
    }
}
