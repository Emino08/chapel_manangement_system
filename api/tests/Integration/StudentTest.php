<?php

namespace Chapel\Tests\Integration;

use PHPUnit\Framework\TestCase;

/**
 * Integration Test for Students API
 */
class StudentTest extends TestCase
{
    private string $baseUrl = 'http://localhost:8080/api/v1';
    private ?string $token = null;

    protected function setUp(): void
    {
        // Login to get token
        $response = $this->makeRequest('POST', '/auth/login', [
            'email' => 'admin@chapel.local',
            'password' => 'Admin#12345'
        ]);

        $this->token = $response['body']['data']['token'] ?? null;
    }

    public function testGetStudentsList(): void
    {
        $response = $this->makeRequest('GET', '/students', null, $this->token);

        $this->assertEquals(200, $response['status']);
        $this->assertTrue($response['body']['success']);
        $this->assertArrayHasKey('data', $response['body']);
        $this->assertArrayHasKey('students', $response['body']['data']);
    }

    public function testCreateStudent(): void
    {
        $studentData = [
            'student_no' => 'TEST' . time(),
            'name' => 'Test Student',
            'program' => 'Computer Science',
            'faculty' => 'Engineering',
            'phone' => '+23276' . rand(1000000, 9999999),
            'level' => '300'
        ];

        $response = $this->makeRequest('POST', '/students', $studentData, $this->token);

        $this->assertEquals(201, $response['status']);
        $this->assertTrue($response['body']['success']);
        $this->assertArrayHasKey('student', $response['body']['data']);
        $this->assertEquals($studentData['name'], $response['body']['data']['student']['name']);
    }

    public function testCreateStudentWithDuplicateNumber(): void
    {
        $studentData = [
            'student_no' => 'DUP' . time(),
            'name' => 'First Student',
            'program' => 'Computer Science',
            'phone' => '+23276' . rand(1000000, 9999999)
        ];

        // Create first student
        $response1 = $this->makeRequest('POST', '/students', $studentData, $this->token);
        $this->assertEquals(201, $response1['status']);

        // Try to create duplicate
        $studentData['name'] = 'Second Student';
        $studentData['phone'] = '+23276' . rand(1000000, 9999999);
        $response2 = $this->makeRequest('POST', '/students', $studentData, $this->token);

        $this->assertGreaterThanOrEqual(400, $response2['status']);
        $this->assertFalse($response2['body']['success']);
    }

    public function testSearchStudents(): void
    {
        $response = $this->makeRequest('GET', '/students/search?q=Test', null, $this->token);

        $this->assertEquals(200, $response['status']);
        $this->assertTrue($response['body']['success']);
        $this->assertArrayHasKey('students', $response['body']['data']);
    }

    public function testFilterStudentsByProgram(): void
    {
        $response = $this->makeRequest('GET', '/students?program=Computer Science', null, $this->token);

        $this->assertEquals(200, $response['status']);
        $this->assertTrue($response['body']['success']);
        $this->assertArrayHasKey('students', $response['body']['data']);
    }

    public function testGetStudentById(): void
    {
        // First create a student
        $studentData = [
            'student_no' => 'GETTEST' . time(),
            'name' => 'Get Test Student',
            'program' => 'Computer Science',
            'phone' => '+23276' . rand(1000000, 9999999)
        ];

        $createResponse = $this->makeRequest('POST', '/students', $studentData, $this->token);
        $studentId = $createResponse['body']['data']['student']['id'];

        // Get student by ID
        $response = $this->makeRequest('GET', "/students/{$studentId}", null, $this->token);

        $this->assertEquals(200, $response['status']);
        $this->assertTrue($response['body']['success']);
        $this->assertEquals($studentId, $response['body']['data']['student']['id']);
    }

    public function testUpdateStudent(): void
    {
        // First create a student
        $studentData = [
            'student_no' => 'UPDATE' . time(),
            'name' => 'Update Test Student',
            'program' => 'Computer Science',
            'phone' => '+23276' . rand(1000000, 9999999)
        ];

        $createResponse = $this->makeRequest('POST', '/students', $studentData, $this->token);
        $studentId = $createResponse['body']['data']['student']['id'];

        // Update student
        $updateData = [
            'name' => 'Updated Student Name',
            'level' => '400'
        ];

        $response = $this->makeRequest('PATCH', "/students/{$studentId}", $updateData, $this->token);

        $this->assertEquals(200, $response['status']);
        $this->assertTrue($response['body']['success']);
        $this->assertEquals('Updated Student Name', $response['body']['data']['student']['name']);
        $this->assertEquals('400', $response['body']['data']['student']['level']);
    }

    public function testDeleteStudent(): void
    {
        // First create a student
        $studentData = [
            'student_no' => 'DELETE' . time(),
            'name' => 'Delete Test Student',
            'program' => 'Computer Science',
            'phone' => '+23276' . rand(1000000, 9999999)
        ];

        $createResponse = $this->makeRequest('POST', '/students', $studentData, $this->token);
        $studentId = $createResponse['body']['data']['student']['id'];

        // Delete student
        $response = $this->makeRequest('DELETE', "/students/{$studentId}", null, $this->token);

        $this->assertEquals(200, $response['status']);
        $this->assertTrue($response['body']['success']);

        // Verify deletion
        $getResponse = $this->makeRequest('GET', "/students/{$studentId}", null, $this->token);
        $this->assertEquals(404, $getResponse['status']);
    }

    public function testUnauthorizedAccess(): void
    {
        $response = $this->makeRequest('GET', '/students');

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
