<?php

namespace Chapel\Exceptions;

use Exception;

/**
 * ForbiddenException
 *
 * Thrown when user lacks required role/permissions
 */
class ForbiddenException extends Exception
{
    protected $code = 403;

    public function __construct(string $message = 'Forbidden - insufficient permissions', ?\Throwable $previous = null)
    {
        parent::__construct($message, $this->code, $previous);
    }
}
