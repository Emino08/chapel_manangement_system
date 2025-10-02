<?php

namespace Chapel\Exceptions;

use Exception;

/**
 * UnauthorizedException
 *
 * Thrown when authentication fails or JWT token is invalid
 */
class UnauthorizedException extends Exception
{
    protected $code = 401;

    public function __construct(string $message = 'Unauthorized', ?\Throwable $previous = null)
    {
        parent::__construct($message, $this->code, $previous);
    }
}
