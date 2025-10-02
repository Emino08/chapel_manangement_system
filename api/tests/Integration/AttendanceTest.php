<?php

namespace Chapel\Tests\Integration;

use PHPUnit\Framework\TestCase;

/**
 * Integration Test for Attendance API
 */
class AttendanceTest extends TestCase
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

    public function testMarkAttendance(): void
    {
        // Create a student
        $studentData = [
            'student_no' => 'ATT' . time(),
            'name' => 'Attendance Test Student',
            'program' => 'Computer Science',
            'phone' => '+23276' . rand(1000000, 9999999)
        ];
        $studentResponse = $this->makeRequest('POST', '/students', $studentData, $this->token);
        $studentId = $studentResponse['body']['data']['student']['id'];

        // Create a service
        $serviceData = [
            'service_date' => date('Y-m-d', strtotime('next Wednesday')),
            'start_time' => '09:00:00',
            'end_time' => '12:00:00',
            'theme' => 'Test Service'
        ];
        $serviceResponse = $this->makeRequest('POST', '/services', $serviceData, $this->token);
        $serviceId = $serviceResponse['body']['data']['service']['id'];

        // Mark attendance
        $attendanceData = [
            'service_id' => $serviceId,
            'student_id' => $studentId,
            'status' => 'PRESENT'
        ];
        $response = $this->makeRequest('POST', '/attendance/mark', $attendanceData, $this->token);

        $this->assertEquals(200, $response['status']);
        $this->assertTrue($response['body']['success']);
        $this->assertArrayHasKey('attendance', $response['body']['data']);
        $this->assertEquals('PRESENT', $response['body']['data']['attendance']['status']);
    }

    public function testUpdateAttendanceStatus(): void
    {
        // Create student and service
        $studentData = [
            'student_no' => 'UPD' . time(),
            'name' => 'Update Attendance Student',
            'program' => 'Computer Science',
            'phone' => '+23276' . rand(1000000, 9999999)
        ];
        $studentResponse = $this->makeRequest('POST', '/students', $studentData, $this->token);
        $studentId = $studentResponse['body']['data']['student']['id'];

        $serviceData = [
            'service_date' => date('Y-m-d', strtotime('+7 days')),
            'start_time' => '09:00:00',
            'end_time' => '12:00:00'
        ];
        $serviceResponse = $this->makeRequest('POST', '/services', $serviceData, $this->token);
        $serviceId = $serviceResponse['body']['data']['service']['id'];

        // Mark as PRESENT
        $attendanceData = [
            'service_id' => $serviceId,
            'student_id' => $studentId,
            'status' => 'PRESENT'
        ];
        $response1 = $this->makeRequest('POST', '/attendance/mark', $attendanceData, $this->token);
        $this->assertEquals('PRESENT', $response1['body']['data']['attendance']['status']);

        // Update to ABSENT (should update, not create duplicate)
        $attendanceData['status'] = 'ABSENT';
        $response2 = $this->makeRequest('POST', '/attendance/mark', $attendanceData, $this->token);
        $this->assertEquals('ABSENT', $response2['body']['data']['attendance']['status']);
    }

    public function testSearchStudentsForAttendance(): void
    {
        // Create a service
        $serviceData = [
            'service_date' => date('Y-m-d', strtotime('+8 days')),
            'start_time' => '09:00:00',
            'end_time' => '12:00:00'
        ];
        $serviceResponse = $this->makeRequest('POST', '/services', $serviceData, $this->token);
        $serviceId = $serviceResponse['body']['data']['service']['id'];

        // Search students
        $searchData = [
            'service_id' => $serviceId,
            'query' => 'Test'
        ];
        $response = $this->makeRequest('POST', '/attendance/search', $searchData, $this->token);

        $this->assertEquals(200, $response['status']);
        $this->assertTrue($response['body']['success']);
        $this->assertArrayHasKey('students', $response['body']['data']);
    }

    public function testGetServiceAttendance(): void
    {
        // Create a service
        $serviceData = [
            'service_date' => date('Y-m-d', strtotime('+9 days')),
            'start_time' => '09:00:00',
            'end_time' => '12:00:00'
        ];
        $serviceResponse = $this->makeRequest('POST', '/services', $serviceData, $this->token);
        $serviceId = $serviceResponse['body']['data']['service']['id'];

        // Get service attendance
        $response = $this->makeRequest('GET', "/attendance/service/{$serviceId}", null, $this->token);

        $this->assertEquals(200, $response['status']);
        $this->assertTrue($response['body']['success']);
        $this->assertArrayHasKey('attendance', $response['body']['data']);
    }

    public function testBulkMarkAttendance(): void
    {
        // Create multiple students
        $studentIds = [];
        for ($i = 1; $i <= 3; $i++) {
            $studentData = [
                'student_no' => 'BULK' . time() . $i,
                'name' => "Bulk Student {$i}",
                'program' => 'Computer Science',
                'phone' => '+23276' . rand(1000000, 9999999)
            ];
            $response = $this->makeRequest('POST', '/students', $studentData, $this->token);
            $studentIds[] = $response['body']['data']['student']['id'];
        }

        // Create a service
        $serviceData = [
            'service_date' => date('Y-m-d', strtotime('+10 days')),
            'start_time' => '09:00:00',
            'end_time' => '12:00:00'
        ];
        $serviceResponse = $this->makeRequest('POST', '/services', $serviceData, $this->token);
        $serviceId = $serviceResponse['body']['data']['service']['id'];

        // Bulk mark attendance
        $bulkData = [
            'service_id' => $serviceId,
            'attendances' => array_map(function ($id) {
                return [
                    'student_id' => $id,
                    'status' => 'PRESENT'
                ];
            }, $studentIds)
        ];

        $response = $this->makeRequest('POST', '/attendance/bulk', $bulkData, $this->token);

        $this->assertEquals(200, $response['status']);
        $this->assertTrue($response['body']['success']);
        $this->assertArrayHasKey('count', $response['body']['data']);
        $this->assertEquals(3, $response['body']['data']['count']);
    }

    public function testGetStudentAttendanceHistory(): void
    {
        // Create a student
        $studentData = [
            'student_no' => 'HIST' . time(),
            'name' => 'History Test Student',
            'program' => 'Computer Science',
            'phone' => '+23276' . rand(1000000, 9999999)
        ];
        $studentResponse = $this->makeRequest('POST', '/students', $studentData, $this->token);
        $studentId = $studentResponse['body']['data']['student']['id'];

        // Get student attendance history
        $response = $this->makeRequest('GET', "/attendance/student/{$studentId}", null, $this->token);

        $this->assertEquals(200, $response['status']);
        $this->assertTrue($response['body']['success']);
        $this->assertArrayHasKey('attendance', $response['body']['data']);
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
