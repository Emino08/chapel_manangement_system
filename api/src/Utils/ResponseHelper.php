<?php

namespace Chapel\Utils;

use Chapel\Exceptions\ValidationException;

/**
 * ResponseHelper
 *
 * Helper class for standardized JSON responses with problem-details format
 */
class ResponseHelper
{
    /**
     * Send a success response
     *
     * @param mixed $data
     * @param string|null $message
     * @param int $statusCode
     * @return void
     */
    public static function success(mixed $data = null, ?string $message = null, int $statusCode = 200): void
    {
        self::json([
            'success' => true,
            'message' => $message,
            'data' => $data,
        ], $statusCode);
    }

    /**
     * Send a created response
     *
     * @param mixed $data
     * @param string|null $message
     * @return void
     */
    public static function created(mixed $data = null, ?string $message = 'Resource created successfully'): void
    {
        self::success($data, $message, 201);
    }

    /**
     * Send a no content response
     *
     * @return void
     */
    public static function noContent(): void
    {
        http_response_code(204);
        exit;
    }

    /**
     * Send an error response (RFC 7807 Problem Details)
     *
     * @param string $title
     * @param string|null $detail
     * @param int $status
     * @param array<string, mixed> $additional
     * @return void
     */
    public static function error(string $title, ?string $detail = null, int $status = 400, array $additional = []): void
    {
        $response = [
            'success' => false,
            'type' => self::getTypeUrl($status),
            'title' => $title,
            'status' => $status,
            'detail' => $detail,
        ];

        // Add additional fields
        foreach ($additional as $key => $value) {
            $response[$key] = $value;
        }

        self::json($response, $status);
    }

    /**
     * Send a validation error response
     *
     * @param ValidationException $exception
     * @return void
     */
    public static function validationError(ValidationException $exception): void
    {
        self::error(
            'Validation Failed',
            $exception->getMessage(),
            422,
            ['errors' => $exception->getErrors()]
        );
    }

    /**
     * Send an unauthorized error response
     *
     * @param string|null $detail
     * @return void
     */
    public static function unauthorized(?string $detail = 'Authentication required'): void
    {
        self::error('Unauthorized', $detail, 401);
    }

    /**
     * Send a forbidden error response
     *
     * @param string|null $detail
     * @return void
     */
    public static function forbidden(?string $detail = 'Insufficient permissions'): void
    {
        self::error('Forbidden', $detail, 403);
    }

    /**
     * Send a not found error response
     *
     * @param string|null $detail
     * @return void
     */
    public static function notFound(?string $detail = 'Resource not found'): void
    {
        self::error('Not Found', $detail, 404);
    }

    /**
     * Send a server error response
     *
     * @param string|null $detail
     * @return void
     */
    public static function serverError(?string $detail = 'Internal server error'): void
    {
        self::error('Internal Server Error', $detail, 500);
    }

    /**
     * Send a conflict error response
     *
     * @param string|null $detail
     * @return void
     */
    public static function conflict(?string $detail = 'Resource already exists'): void
    {
        self::error('Conflict', $detail, 409);
    }

    /**
     * Send a bad request error response
     *
     * @param string|null $detail
     * @return void
     */
    public static function badRequest(?string $detail = 'Bad request'): void
    {
        self::error('Bad Request', $detail, 400);
    }

    /**
     * Send paginated response
     *
     * @param array<int, mixed> $data
     * @param int $total
     * @param int $page
     * @param int $limit
     * @param string|null $message
     * @return void
     */
    public static function paginated(array $data, int $total, int $page = 1, int $limit = 50, ?string $message = null): void
    {
        $totalPages = $limit > 0 ? (int) ceil($total / $limit) : 1;

        self::json([
            'success' => true,
            'message' => $message,
            'data' => $data,
            'pagination' => [
                'total' => $total,
                'page' => $page,
                'limit' => $limit,
                'totalPages' => $totalPages,
                'hasNext' => $page < $totalPages,
                'hasPrevious' => $page > 1,
            ],
        ]);
    }

    /**
     * Send JSON response
     *
     * @param array<string, mixed> $data
     * @param int $statusCode
     * @return void
     */
    private static function json(array $data, int $statusCode = 200): void
    {
        http_response_code($statusCode);
        header('Content-Type: application/json');

        echo json_encode($data, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES);
        exit;
    }

    /**
     * Get RFC 7807 type URL for status code
     *
     * @param int $status
     * @return string
     */
    private static function getTypeUrl(int $status): string
    {
        $types = [
            400 => 'https://httpstatuses.com/400',
            401 => 'https://httpstatuses.com/401',
            403 => 'https://httpstatuses.com/403',
            404 => 'https://httpstatuses.com/404',
            409 => 'https://httpstatuses.com/409',
            422 => 'https://httpstatuses.com/422',
            500 => 'https://httpstatuses.com/500',
        ];

        return $types[$status] ?? 'https://httpstatuses.com/' . $status;
    }

    /**
     * Handle exception and send appropriate response
     *
     * @param \Throwable $exception
     * @param bool $debug Show stack trace in debug mode
     * @return void
     */
    public static function handleException(\Throwable $exception, bool $debug = false): void
    {
        $statusCode = 500;
        $title = 'Internal Server Error';
        $detail = $exception->getMessage();
        $additional = [];

        // Map exception types to appropriate responses
        if ($exception instanceof ValidationException) {
            self::validationError($exception);
            return;
        }

        if ($exception instanceof \Chapel\Exceptions\UnauthorizedException) {
            $statusCode = 401;
            $title = 'Unauthorized';
        } elseif ($exception instanceof \Chapel\Exceptions\ForbiddenException) {
            $statusCode = 403;
            $title = 'Forbidden';
        } elseif ($exception instanceof \Chapel\Exceptions\NotFoundException) {
            $statusCode = 404;
            $title = 'Not Found';
        } elseif ($exception instanceof \Chapel\Exceptions\DatabaseException) {
            $statusCode = 500;
            $title = 'Database Error';
        }

        // Add debug information if in debug mode
        if ($debug) {
            $additional['debug'] = [
                'exception' => get_class($exception),
                'file' => $exception->getFile(),
                'line' => $exception->getLine(),
                'trace' => $exception->getTraceAsString(),
            ];
        }

        self::error($title, $detail, $statusCode, $additional);
    }

    /**
     * Set timezone for the application
     *
     * @return void
     */
    public static function setTimezone(): void
    {
        $timezone = $_ENV['APP_TIMEZONE'] ?? 'Africa/Freetown';
        date_default_timezone_set($timezone);
    }
}
