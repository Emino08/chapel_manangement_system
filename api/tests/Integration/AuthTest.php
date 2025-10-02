<?php

namespace Chapel\Tests\Integration;

use PHPUnit\Framework\TestCase;

/**
 * Integration Test for Authentication API
 */
class AuthTest extends TestCase
{
    private string $baseUrl = 'http://localhost:8080/api/v1';

    public function testHealthCheck(): void
    {
        $response = $this->makeRequest('GET', '/health');

        $this->assertEquals(200, $response['status']);
        $this->assertTrue($response['body']['success']);
        $this->assertEquals('API is healthy', $response['body']['message']);
    }

    public function testLoginWithValidCredentials(): void
    {
        $response = $this->makeRequest('POST', '/auth/login', [
            'email' => 'admin@chapel.local',
            'password' => 'Admin#12345'
        ]);

        $this->assertEquals(200, $response['status']);
        $this->assertTrue($response['body']['success']);
        $this->assertArrayHasKey('token', $response['body']['data']);
        $this->assertArrayHasKey('user', $response['body']['data']);
        $this->assertEquals('admin@chapel.local', $response['body']['data']['user']['email']);
        $this->assertEquals('ADMIN', $response['body']['data']['user']['role']);
    }

    public function testLoginWithInvalidCredentials(): void
    {
        $response = $this->makeRequest('POST', '/auth/login', [
            'email' => 'admin@chapel.local',
            'password' => 'wrongpassword'
        ]);

        $this->assertEquals(401, $response['status']);
        $this->assertFalse($response['body']['success']);
    }

    public function testLoginWithMissingEmail(): void
    {
        $response = $this->makeRequest('POST', '/auth/login', [
            'password' => 'Admin#12345'
        ]);

        $this->assertGreaterThanOrEqual(400, $response['status']);
        $this->assertFalse($response['body']['success']);
    }

    public function testGetCurrentUserWithValidToken(): void
    {
        // First login to get token
        $loginResponse = $this->makeRequest('POST', '/auth/login', [
            'email' => 'admin@chapel.local',
            'password' => 'Admin#12345'
        ]);

        $token = $loginResponse['body']['data']['token'];

        // Get current user
        $response = $this->makeRequest('GET', '/auth/me', null, $token);

        $this->assertEquals(200, $response['status']);
        $this->assertTrue($response['body']['success']);
        $this->assertArrayHasKey('user', $response['body']['data']);
        $this->assertEquals('admin@chapel.local', $response['body']['data']['user']['email']);
    }

    public function testGetCurrentUserWithoutToken(): void
    {
        $response = $this->makeRequest('GET', '/auth/me');

        $this->assertEquals(401, $response['status']);
    }

    private function makeRequest(string $method, string $endpoint, ?array $data = null, ?string $token = null): array
    {
        $url = $this->baseUrl . $endpoint;
        $ch = curl_init($url);

        $headers = [
            'Content-Type: application/json',
            'Accept: application/json'
        ];

        if ($token) {
            $headers[] = 'Authorization: Bearer ' . $token;
        }

        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
        curl_setopt($ch, CURLOPT_CUSTOMREQUEST, $method);

        if ($data && in_array($method, ['POST', 'PATCH', 'PUT'])) {
            curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
        }

        $responseBody = curl_exec($ch);
        $statusCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);

        return [
            'status' => $statusCode,
            'body' => json_decode($responseBody, true) ?? []
        ];
    }
}
