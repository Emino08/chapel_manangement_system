<?php

namespace Chapel\Exceptions;

use Exception;

/**
 * DatabaseException
 *
 * Thrown when database operations fail
 */
class DatabaseException extends Exception
{
    protected $code = 500;

    public function __construct(string $message = 'Database error occurred', ?\Throwable $previous = null)
    {
        parent::__construct($message, $this->code, $previous);
    }
}
