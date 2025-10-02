<?php

namespace Chapel\Tests\Unit;

use PHPUnit\Framework\TestCase;
use Chapel\Utils\Validator;

/**
 * Unit Test for Validator
 */
class ValidatorTest extends TestCase
{
    private Validator $validator;

    protected function setUp(): void
    {
        $this->validator = new Validator();
    }

    public function testValidateEmailValid(): void
    {
        $result = $this->validator->validateEmail('test@example.com');
        $this->assertTrue($result);
    }

    public function testValidateEmailInvalid(): void
    {
        $this->expectException(\Chapel\Exceptions\ValidationException::class);
        $this->validator->validateEmail('invalid-email');
    }

    public function testValidateRequiredFieldsSuccess(): void
    {
        $data = [
            'name' => 'John Doe',
            'email' => 'john@example.com',
            'role' => 'ADMIN'
        ];

        $result = $this->validator->validateRequired($data, ['name', 'email', 'role']);
        $this->assertTrue($result);
    }

    public function testValidateRequiredFieldsFailure(): void
    {
        $data = [
            'name' => 'John Doe',
            'email' => 'john@example.com'
        ];

        $this->expectException(\Chapel\Exceptions\ValidationException::class);
        $this->validator->validateRequired($data, ['name', 'email', 'role']);
    }

    public function testValidateRoleValid(): void
    {
        $result = $this->validator->validateRole('ADMIN');
        $this->assertTrue($result);

        $result = $this->validator->validateRole('HR');
        $this->assertTrue($result);

        $result = $this->validator->validateRole('SUO');
        $this->assertTrue($result);
    }

    public function testValidateRoleInvalid(): void
    {
        $this->expectException(\Chapel\Exceptions\ValidationException::class);
        $this->validator->validateRole('INVALID_ROLE');
    }

    public function testValidatePhoneNumberValid(): void
    {
        $result = $this->validator->validatePhone('+23276123456');
        $this->assertTrue($result);

        $result = $this->validator->validatePhone('076123456');
        $this->assertTrue($result);
    }

    public function testValidateDateValid(): void
    {
        $result = $this->validator->validateDate('2025-10-02');
        $this->assertTrue($result);
    }

    public function testValidateDateInvalid(): void
    {
        $this->expectException(\Chapel\Exceptions\ValidationException::class);
        $this->validator->validateDate('invalid-date');
    }

    public function testValidateTimeValid(): void
    {
        $result = $this->validator->validateTime('09:00:00');
        $this->assertTrue($result);

        $result = $this->validator->validateTime('14:30:00');
        $this->assertTrue($result);
    }

    public function testValidateTimeInvalid(): void
    {
        $this->expectException(\Chapel\Exceptions\ValidationException::class);
        $this->validator->validateTime('25:00:00');
    }

    public function testValidateUuidValid(): void
    {
        $result = $this->validator->validateUuid('550e8400-e29b-41d4-a716-446655440000');
        $this->assertTrue($result);
    }

    public function testValidateUuidInvalid(): void
    {
        $this->expectException(\Chapel\Exceptions\ValidationException::class);
        $this->validator->validateUuid('not-a-uuid');
    }

    public function testValidateAttendanceStatusValid(): void
    {
        $result = $this->validator->validateAttendanceStatus('PRESENT');
        $this->assertTrue($result);

        $result = $this->validator->validateAttendanceStatus('ABSENT');
        $this->assertTrue($result);
    }

    public function testValidateAttendanceStatusInvalid(): void
    {
        $this->expectException(\Chapel\Exceptions\ValidationException::class);
        $this->validator->validateAttendanceStatus('MAYBE');
    }
}
