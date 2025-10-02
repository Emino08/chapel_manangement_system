<?php

namespace Chapel\Tests\Unit;

use PHPUnit\Framework\TestCase;
use Chapel\Utils\JwtHelper;

/**
 * Unit Test for JWT Helper
 */
class JwtHelperTest extends TestCase
{
    private JwtHelper $jwtHelper;

    protected function setUp(): void
    {
        $this->jwtHelper = new JwtHelper();
    }

    public function testGenerateToken(): void
    {
        $payload = [
            'user_id' => '123e4567-e89b-12d3-a456-426614174000',
            'email' => 'test@example.com',
            'role' => 'ADMIN'
        ];

        $token = $this->jwtHelper->generateToken($payload);

        $this->assertIsString($token);
        $this->assertNotEmpty($token);
        $this->assertStringContainsString('.', $token); // JWT has dots
    }

    public function testVerifyValidToken(): void
    {
        $payload = [
            'user_id' => '123e4567-e89b-12d3-a456-426614174000',
            'email' => 'test@example.com',
            'role' => 'ADMIN'
        ];

        $token = $this->jwtHelper->generateToken($payload);
        $decoded = $this->jwtHelper->verifyToken($token);

        $this->assertIsArray($decoded);
        $this->assertEquals($payload['user_id'], $decoded['user_id']);
        $this->assertEquals($payload['email'], $decoded['email']);
        $this->assertEquals($payload['role'], $decoded['role']);
    }

    public function testVerifyExpiredToken(): void
    {
        // Create a token that expired 1 hour ago
        $payload = [
            'user_id' => '123e4567-e89b-12d3-a456-426614174000',
            'email' => 'test@example.com',
            'role' => 'ADMIN',
            'exp' => time() - 3600 // Expired 1 hour ago
        ];

        $token = $this->jwtHelper->generateToken($payload);

        $this->expectException(\Exception::class);
        $this->jwtHelper->verifyToken($token);
    }

    public function testVerifyInvalidToken(): void
    {
        $this->expectException(\Exception::class);
        $this->jwtHelper->verifyToken('invalid.token.here');
    }

    public function testTokenContainsExpiration(): void
    {
        $payload = [
            'user_id' => '123e4567-e89b-12d3-a456-426614174000',
            'email' => 'test@example.com',
            'role' => 'ADMIN'
        ];

        $token = $this->jwtHelper->generateToken($payload);
        $decoded = $this->jwtHelper->verifyToken($token);

        $this->assertArrayHasKey('exp', $decoded);
        $this->assertGreaterThan(time(), $decoded['exp']);
    }
}
