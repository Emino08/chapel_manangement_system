<?php

namespace Chapel\Middleware;

use Chapel\Exceptions\ForbiddenException;
use Chapel\Exceptions\UnauthorizedException;

/**
 * RoleMiddleware
 *
 * Checks if user has required role(s) to access a resource
 */
class RoleMiddleware
{
    /**
     * Process the role middleware
     *
     * @param array<string, mixed> $request
     * @param array<int, string> $allowedRoles
     * @return array<string, mixed>
     * @throws UnauthorizedException|ForbiddenException
     */
    public function process(array $request, array $allowedRoles): array
    {
        $user = $request['user'] ?? null;

        if (!$user) {
            throw new UnauthorizedException('Authentication required');
        }

        $userRole = $user['role'] ?? null;

        if (!$userRole || !in_array($userRole, $allowedRoles, true)) {
            throw new ForbiddenException(
                sprintf(
                    'Access denied. Required role(s): %s',
                    implode(', ', $allowedRoles)
                )
            );
        }

        return $request;
    }

    /**
     * Check if user is ADMIN
     *
     * @param array<string, mixed> $request
     * @return array<string, mixed>
     * @throws UnauthorizedException|ForbiddenException
     */
    public function requireAdmin(array $request): array
    {
        return $this->process($request, ['ADMIN']);
    }

    /**
     * Check if user is ADMIN or HR
     *
     * @param array<string, mixed> $request
     * @return array<string, mixed>
     * @throws UnauthorizedException|ForbiddenException
     */
    public function requireAdminOrHR(array $request): array
    {
        return $this->process($request, ['ADMIN', 'HR']);
    }

    /**
     * Check if user is ADMIN or SUO
     *
     * @param array<string, mixed> $request
     * @return array<string, mixed>
     * @throws UnauthorizedException|ForbiddenException
     */
    public function requireAdminOrSUO(array $request): array
    {
        return $this->process($request, ['ADMIN', 'SUO']);
    }

    /**
     * Check if user has any of the standard roles (ADMIN, HR, SUO)
     *
     * @param array<string, mixed> $request
     * @return array<string, mixed>
     * @throws UnauthorizedException|ForbiddenException
     */
    public function requireAnyRole(array $request): array
    {
        return $this->process($request, ['ADMIN', 'HR', 'SUO']);
    }

    /**
     * Static helper to check if user has role
     *
     * @param array<string, mixed> $request
     * @param string $role
     * @return bool
     */
    public static function hasRole(array $request, string $role): bool
    {
        $user = $request['user'] ?? null;

        if (!$user) {
            return false;
        }

        return ($user['role'] ?? null) === $role;
    }

    /**
     * Static helper to check if user has any of the roles
     *
     * @param array<string, mixed> $request
     * @param array<int, string> $roles
     * @return bool
     */
    public static function hasAnyRole(array $request, array $roles): bool
    {
        $user = $request['user'] ?? null;

        if (!$user) {
            return false;
        }

        $userRole = $user['role'] ?? null;

        return $userRole && in_array($userRole, $roles, true);
    }
}
