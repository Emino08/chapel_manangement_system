<?php

namespace Chapel\Utils;

use Respect\Validation\Validator as v;
use Respect\Validation\Exceptions\ValidationException as RespectValidationException;
use Chapel\Exceptions\ValidationException;

/**
 * Validator
 *
 * Validation helper using Respect\Validation library
 */
class Validator
{
    /**
     * @var array<string, string[]>
     */
    private array $errors = [];

    /**
     * Validate data against rules
     *
     * @param array<string, mixed> $data
     * @param array<string, callable> $rules
     * @return bool
     */
    public function validate(array $data, array $rules): bool
    {
        $this->errors = [];

        foreach ($rules as $field => $rule) {
            $value = $data[$field] ?? null;

            try {
                $rule($value);
            } catch (RespectValidationException $e) {
                $this->errors[$field] = [$e->getMessage()];
            }
        }

        return empty($this->errors);
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

    /**
     * Throw ValidationException if there are errors
     *
     * @param string $message
     * @return void
     * @throws ValidationException
     */
    public function throwIfFailed(string $message = 'Validation failed'): void
    {
        if (!empty($this->errors)) {
            throw new ValidationException($message, $this->errors);
        }
    }

    /**
     * Validate user creation data
     *
     * @param array<string, mixed> $data
     * @return void
     * @throws ValidationException
     */
    public function validateUserCreate(array $data): void
    {
        $rules = [
            'name' => fn($v) => v::notEmpty()->stringType()->length(2, 255)->assert($v),
            'email' => fn($v) => v::notEmpty()->email()->assert($v),
            'role' => fn($v) => v::notEmpty()->in(['ADMIN', 'HR', 'SUO'])->assert($v),
            'password' => fn($v) => v::notEmpty()->stringType()->length(8, 255)->assert($v),
        ];

        if (!$this->validate($data, $rules)) {
            $this->throwIfFailed('User validation failed');
        }
    }

    /**
     * Validate user update data
     *
     * @param array<string, mixed> $data
     * @return void
     * @throws ValidationException
     */
    public function validateUserUpdate(array $data): void
    {
        $rules = [];

        if (isset($data['name'])) {
            $rules['name'] = fn($v) => v::notEmpty()->stringType()->length(2, 255)->assert($v);
        }

        if (isset($data['email'])) {
            $rules['email'] = fn($v) => v::notEmpty()->email()->assert($v);
        }

        if (isset($data['role'])) {
            $rules['role'] = fn($v) => v::notEmpty()->in(['ADMIN', 'HR', 'SUO'])->assert($v);
        }

        if (isset($data['password'])) {
            $rules['password'] = fn($v) => v::notEmpty()->stringType()->length(8, 255)->assert($v);
        }

        if (!$this->validate($data, $rules)) {
            $this->throwIfFailed('User validation failed');
        }
    }

    /**
     * Validate password change data
     *
     * @param array<string, mixed> $data
     * @return void
     * @throws ValidationException
     */
    public function validatePasswordChange(array $data): void
    {
        $rules = [
            'currentPassword' => fn($v) => v::notEmpty()->stringType()->assert($v),
            'newPassword' => fn($v) => v::notEmpty()->stringType()->length(8, 255)->assert($v),
        ];

        if (!$this->validate($data, $rules)) {
            $this->throwIfFailed('Password change validation failed');
        }
    }

    /**
     * Validate student creation data
     *
     * @param array<string, mixed> $data
     * @return void
     * @throws ValidationException
     */
    public function validateStudentCreate(array $data): void
    {
        $rules = [
            'student_no' => fn($v) => v::notEmpty()->stringType()->length(1, 50)->assert($v),
            'name' => fn($v) => v::notEmpty()->stringType()->length(2, 255)->assert($v),
            'program' => fn($v) => v::notEmpty()->stringType()->length(2, 255)->assert($v),
        ];

        if (isset($data['phone']) && !empty($data['phone'])) {
            $rules['phone'] = fn($v) => v::phone()->assert($v);
        }

        if (!$this->validate($data, $rules)) {
            $this->throwIfFailed('Student validation failed');
        }
    }

    /**
     * Validate pastor creation data
     *
     * @param array<string, mixed> $data
     * @return void
     * @throws ValidationException
     */
    public function validatePastorCreate(array $data): void
    {
        $rules = [
            'code' => fn($v) => v::notEmpty()->stringType()->length(1, 50)->assert($v),
            'name' => fn($v) => v::notEmpty()->stringType()->length(2, 255)->assert($v),
        ];

        if (isset($data['phone']) && !empty($data['phone'])) {
            $rules['phone'] = fn($v) => v::phone()->assert($v);
        }

        if (!$this->validate($data, $rules)) {
            $this->throwIfFailed('Pastor validation failed');
        }
    }

    /**
     * Validate semester creation data
     *
     * @param array<string, mixed> $data
     * @return void
     * @throws ValidationException
     */
    public function validateSemesterCreate(array $data): void
    {
        $rules = [
            'name' => fn($v) => v::notEmpty()->stringType()->length(2, 255)->assert($v),
            'start_date' => fn($v) => v::notEmpty()->date('Y-m-d')->assert($v),
            'end_date' => fn($v) => v::notEmpty()->date('Y-m-d')->assert($v),
        ];

        if (!$this->validate($data, $rules)) {
            $this->throwIfFailed('Semester validation failed');
        }

        // Additional validation: end_date must be after start_date
        if (isset($data['start_date']) && isset($data['end_date'])) {
            if (strtotime($data['end_date']) <= strtotime($data['start_date'])) {
                $this->errors['end_date'] = ['End date must be after start date'];
                $this->throwIfFailed('Semester validation failed');
            }
        }
    }

    /**
     * Validate service creation data
     *
     * @param array<string, mixed> $data
     * @return void
     * @throws ValidationException
     */
    public function validateServiceCreate(array $data): void
    {
        $rules = [
            'service_date' => fn($v) => v::notEmpty()->date('Y-m-d')->assert($v),
            'start_time' => fn($v) => v::notEmpty()->time('H:i:s')->assert($v),
            'end_time' => fn($v) => v::notEmpty()->time('H:i:s')->assert($v),
        ];

        if (isset($data['pastor_id']) && !empty($data['pastor_id'])) {
            $rules['pastor_id'] = fn($v) => v::notEmpty()->uuid()->assert($v);
        }

        if (!$this->validate($data, $rules)) {
            $this->throwIfFailed('Service validation failed');
        }
    }

    /**
     * Validate attendance marking data
     *
     * @param array<string, mixed> $data
     * @return void
     * @throws ValidationException
     */
    public function validateAttendanceCreate(array $data): void
    {
        $rules = [
            'service_id' => fn($v) => v::notEmpty()->uuid()->assert($v),
            'student_id' => fn($v) => v::notEmpty()->uuid()->assert($v),
            'status' => fn($v) => v::notEmpty()->in(['PRESENT', 'ABSENT'])->assert($v),
        ];

        if (!$this->validate($data, $rules)) {
            $this->throwIfFailed('Attendance validation failed');
        }
    }

    /**
     * Validate login credentials
     *
     * @param array<string, mixed> $data
     * @return void
     * @throws ValidationException
     */
    public function validateLogin(array $data): void
    {
        $rules = [
            'email' => fn($v) => v::notEmpty()->email()->assert($v),
            'password' => fn($v) => v::notEmpty()->stringType()->assert($v),
        ];

        if (!$this->validate($data, $rules)) {
            $this->throwIfFailed('Login validation failed');
        }
    }

    /**
     * Validate UUID
     *
     * @param string $value
     * @return bool
     */
    public static function isUuid(string $value): bool
    {
        try {
            v::uuid()->assert($value);

            return true;
        } catch (RespectValidationException $e) {
            return false;
        }
    }

    /**
     * Validate email
     *
     * @param string $value
     * @return bool
     */
    public static function isEmail(string $value): bool
    {
        try {
            v::email()->assert($value);

            return true;
        } catch (RespectValidationException $e) {
            return false;
        }
    }

    /**
     * Validate date format
     *
     * @param string $value
     * @param string $format
     * @return bool
     */
    public static function isDate(string $value, string $format = 'Y-m-d'): bool
    {
        try {
            v::date($format)->assert($value);

            return true;
        } catch (RespectValidationException $e) {
            return false;
        }
    }
}
