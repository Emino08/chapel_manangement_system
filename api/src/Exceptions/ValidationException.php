<?php

namespace Chapel\Exceptions;

use Exception;

/**
 * ValidationException
 *
 * Thrown when input validation fails
 */
class ValidationException extends Exception
{
    protected $code = 422;

    /**
     * @var array<string, string[]>
     */
    private array $errors = [];

    /**
     * @param string $message
     * @param array<string, string[]> $errors
     * @param \Throwable|null $previous
     */
    public function __construct(string $message = 'Validation failed', array $errors = [], ?\Throwable $previous = null)
    {
        parent::__construct($message, $this->code, $previous);
        $this->errors = $errors;
    }

    /**
     * Get validation errors
     *
     * @return array<string, string[]>
     */
    public function getErrors(): array
    {
        return $this->errors;
    }
}
