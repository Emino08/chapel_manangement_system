<?php

namespace Chapel\Exceptions;

use Exception;

/**
 * NotFoundException
 *
 * Thrown when a requested resource is not found
 */
class NotFoundException extends Exception
{
    protected $code = 404;

    public function __construct(string $message = 'Resource not found', ?\Throwable $previous = null)
    {
        parent::__construct($message, $this->code, $previous);
    }
}
