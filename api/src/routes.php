<?php

/**
 * API Routes
 *
 * Define all API routes with proper middleware
 */

use Chapel\Controllers\AuthController;
use Chapel\Controllers\UserController;
use Chapel\Controllers\StudentController;
use Chapel\Controllers\PastorController;
use Chapel\Controllers\LecturerController;
use Chapel\Controllers\SemesterController;
use Chapel\Controllers\ServiceController;
use Chapel\Controllers\AttendanceController;
use Chapel\Controllers\ReportController;
use Chapel\Middleware\AuthMiddleware;
use Chapel\Middleware\RoleMiddleware;

return function ($app, $container) {
    // API version prefix
    $apiPrefix = '/api/v1';

    // ===========================
    // Public Routes (No Auth)
    // ===========================

    // POST /api/v1/auth/login - Direct JSON handling to fix persistent NULL email
    $app->post($apiPrefix . '/auth/login', function ($request, $response) use ($container) {
        // Direct approach - get raw body and parse it immediately
        $rawBody = $request->getBody();
        $rawBody->rewind();
        $bodyContent = $rawBody->getContents();

        // Parse JSON data directly
        $data = [];
        if (!empty($bodyContent)) {
            $jsonData = json_decode($bodyContent, true);
            if (json_last_error() === JSON_ERROR_NONE && is_array($jsonData) && !empty($jsonData)) {
                $data = $jsonData;
            }
        }

        // If that didn't work, try the global data
        if (empty($data) && isset($GLOBALS['parsed_json_body']) && is_array($GLOBALS['parsed_json_body'])) {
            $data = $GLOBALS['parsed_json_body'];
        }

        // If still empty, try $_POST
        if (empty($data) && !empty($_POST)) {
            $data = $_POST;
        }

        // If STILL empty, try Slim's parsed body as last resort
        if (empty($data)) {
            $parsedBody = $request->getParsedBody();
            if (is_array($parsedBody) && !empty($parsedBody)) {
                $data = $parsedBody;
            }
        }

        // Handle both 'username' and 'email' field names from frontend
        if (isset($data['username']) && !isset($data['email'])) {
            $data['email'] = $data['username'];
        }

        // Final validation - if we still don't have email/password, create a detailed error
        if (empty($data) || !isset($data['email']) || !isset($data['password'])) {
            // Create detailed debug response
            $debugInfo = [
                'raw_body' => $bodyContent,
                'raw_body_length' => strlen($bodyContent ?? ''),
                'json_decode_result' => json_decode($bodyContent ?? '', true),
                'json_last_error' => json_last_error(),
                'global_data' => $GLOBALS['parsed_json_body'] ?? null,
                'post_data' => $_POST,
                'parsed_body' => $request->getParsedBody(),
                'content_type' => $request->getHeaderLine('Content-Type'),
                'request_method' => $request->getMethod(),
                'final_data' => $data
            ];

            $response->getBody()->write(json_encode([
                'success' => false,
                'type' => 'https://httpstatuses.com/422',
                'title' => 'JSON Parsing Failed',
                'status' => 422,
                'detail' => 'Unable to parse JSON request body or extract email/password',
                'debug' => $debugInfo
            ]));
            return $response->withStatus(422)->withHeader('Content-Type', 'application/json');
        }

        // Log successful parsing
        error_log("Login Success - Email received: " . ($data['email'] ?? 'MISSING'));
        error_log("Login Success - Password received: " . (isset($data['password']) ? 'YES' : 'NO'));

        $controller = $container->get(AuthController::class);
        $controller->login($data);
        return $response;
    });

    // ===========================
    // Authenticated Routes
    // ===========================

    // Auth - Get current user
    $app->get($apiPrefix . '/auth/me', function ($request, $response) use ($container) {
        $authMiddleware = new AuthMiddleware();
        $requestData = $authMiddleware->process([]);

        $controller = $container->get(AuthController::class);
        $controller->me($requestData);
        return $response;
    });

    // POST /api/v1/auth/change-password
    $app->post($apiPrefix . '/auth/change-password', function ($request, $response) use ($container) {
        $authMiddleware = new AuthMiddleware();
        $requestData = $authMiddleware->process([]);

        $data = $request->getParsedBody();
        $controller = $container->get(AuthController::class);
        $controller->changePassword($requestData, $data);
        return $response;
    });

    // ===========================
    // User Routes (ADMIN only)
    // ===========================

    $app->group($apiPrefix . '/users', function ($group) use ($container) {
        // GET /api/v1/users
        $group->get('', function ($request, $response) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $requestData = $authMiddleware->process([]);

            $roleMiddleware = new RoleMiddleware();
            $roleMiddleware->process($requestData, ['ADMIN']);

            $params = $request->getQueryParams();
            $controller = $container->get(UserController::class);
            $controller->index($params);
            return $response;
        });

        // GET /api/v1/users/{id}
        $group->get('/{id}', function ($request, $response, $args) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $requestData = $authMiddleware->process([]);

            $roleMiddleware = new RoleMiddleware();
            $roleMiddleware->process($requestData, ['ADMIN']);

            $controller = $container->get(UserController::class);
            $controller->show($args['id']);
            return $response;
        });

        // POST /api/v1/users
        $group->post('', function ($request, $response) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $requestData = $authMiddleware->process([]);

            $roleMiddleware = new RoleMiddleware();
            $roleMiddleware->process($requestData, ['ADMIN']);

            $data = $request->getParsedBody();
            $controller = $container->get(UserController::class);
            $controller->create($data);
            return $response;
        });

        // PATCH /api/v1/users/{id}
        $group->patch('/{id}', function ($request, $response, $args) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $requestData = $authMiddleware->process([]);

            $roleMiddleware = new RoleMiddleware();
            $roleMiddleware->process($requestData, ['ADMIN']);

            $data = $request->getParsedBody();
            $controller = $container->get(UserController::class);
            $controller->update($args['id'], $data);
            return $response;
        });

        // DELETE /api/v1/users/{id}
        $group->delete('/{id}', function ($request, $response, $args) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $requestData = $authMiddleware->process([]);

            $roleMiddleware = new RoleMiddleware();
            $roleMiddleware->process($requestData, ['ADMIN']);

            $controller = $container->get(UserController::class);
            $controller->delete($args['id']);
            return $response;
        });
    });

    // ===========================
    // Student Routes (Authenticated)
    // ===========================

    $app->group($apiPrefix . '/students', function ($group) use ($container) {
        // GET /api/v1/students
        $group->get('', function ($request, $response) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $authMiddleware->process([]);

            $params = $request->getQueryParams();
            $controller = $container->get(StudentController::class);
            $controller->index($params);
            return $response;
        });

        // GET /api/v1/students/search
        $group->get('/search', function ($request, $response) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $authMiddleware->process([]);

            $params = $request->getQueryParams();
            $controller = $container->get(StudentController::class);
            $controller->search($params);
            return $response;
        });

        // GET /api/v1/students/{id}
        $group->get('/{id}', function ($request, $response, $args) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $authMiddleware->process([]);

            $controller = $container->get(StudentController::class);
            $controller->show($args['id']);
            return $response;
        });

        // POST /api/v1/students
        $group->post('', function ($request, $response) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $authMiddleware->process([]);

            $data = $request->getParsedBody();
            $controller = $container->get(StudentController::class);
            $controller->create($data);
            return $response;
        });

        // POST /api/v1/students/bulk-upload
        $group->post('/bulk-upload', function ($request, $response) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $authMiddleware->process([]);

            $files = $request->getUploadedFiles();
            $filesArray = [];
            foreach ($files as $key => $file) {
                $filesArray[$key] = [
                    'name' => $file->getClientFilename(),
                    'type' => $file->getClientMediaType(),
                    'tmp_name' => $file->getStream()->getMetadata('uri'),
                    'error' => $file->getError(),
                    'size' => $file->getSize(),
                ];
            }

            $controller = $container->get(StudentController::class);
            $controller->bulkUpload($filesArray);
            return $response;
        });

        // PATCH /api/v1/students/{id}
        $group->patch('/{id}', function ($request, $response, $args) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $authMiddleware->process([]);

            $data = $request->getParsedBody();
            $controller = $container->get(StudentController::class);
            $controller->update($args['id'], $data);
            return $response;
        });

        // DELETE /api/v1/students/{id}
        $group->delete('/{id}', function ($request, $response, $args) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $authMiddleware->process([]);

            $controller = $container->get(StudentController::class);
            $controller->delete($args['id']);
            return $response;
        });
    });

    // ===========================
    // Pastor Routes (Authenticated)
    // ===========================

    $app->group($apiPrefix . '/pastors', function ($group) use ($container) {
        // GET /api/v1/pastors
        $group->get('', function ($request, $response) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $authMiddleware->process([]);

            $params = $request->getQueryParams();
            $controller = $container->get(PastorController::class);
            $controller->index($params);
            return $response;
        });

        // GET /api/v1/pastors/search
        $group->get('/search', function ($request, $response) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $authMiddleware->process([]);

            $params = $request->getQueryParams();
            $controller = $container->get(PastorController::class);
            $controller->search($params);
            return $response;
        });

        // GET /api/v1/pastors/{id}
        $group->get('/{id}', function ($request, $response, $args) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $authMiddleware->process([]);

            $controller = $container->get(PastorController::class);
            $controller->show($args['id']);
            return $response;
        });

        // POST /api/v1/pastors
        $group->post('', function ($request, $response) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $authMiddleware->process([]);

            $data = $request->getParsedBody();
            $controller = $container->get(PastorController::class);
            $controller->create($data);
            return $response;
        });

        // POST /api/v1/pastors/bulk-upload
        $group->post('/bulk-upload', function ($request, $response) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $authMiddleware->process([]);

            $files = $request->getUploadedFiles();
            $filesArray = [];
            foreach ($files as $key => $file) {
                $filesArray[$key] = [
                    'name' => $file->getClientFilename(),
                    'type' => $file->getClientMediaType(),
                    'tmp_name' => $file->getStream()->getMetadata('uri'),
                    'error' => $file->getError(),
                    'size' => $file->getSize(),
                ];
            }

            $controller = $container->get(PastorController::class);
            $controller->bulkUpload($filesArray);
            return $response;
        });

        // PATCH /api/v1/pastors/{id}
        $group->patch('/{id}', function ($request, $response, $args) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $authMiddleware->process([]);

            $data = $request->getParsedBody();
            $controller = $container->get(PastorController::class);
            $controller->update($args['id'], $data);
            return $response;
        });

        // DELETE /api/v1/pastors/{id}
        $group->delete('/{id}', function ($request, $response, $args) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $authMiddleware->process([]);

            $controller = $container->get(PastorController::class);
            $controller->delete($args['id']);
            return $response;
        });
    });

    // ===========================
    // Lecturer Routes (Authenticated)
    // ===========================

    $app->group($apiPrefix . '/lecturers', function ($group) use ($container) {
        // GET /api/v1/lecturers
        $group->get('', function ($request, $response) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $authMiddleware->process([]);

            $params = $request->getQueryParams();
            $controller = $container->get(LecturerController::class);
            $controller->index($params);
            return $response;
        });

        // GET /api/v1/lecturers/search
        $group->get('/search', function ($request, $response) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $authMiddleware->process([]);

            $params = $request->getQueryParams();
            $controller = $container->get(LecturerController::class);
            $controller->search($params);
            return $response;
        });

        // GET /api/v1/lecturers/{id}
        $group->get('/{id}', function ($request, $response, $args) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $authMiddleware->process([]);

            $controller = $container->get(LecturerController::class);
            $controller->show($args['id']);
            return $response;
        });

        // POST /api/v1/lecturers
        $group->post('', function ($request, $response) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $authMiddleware->process([]);

            $data = $request->getParsedBody();
            $controller = $container->get(LecturerController::class);
            $controller->create($data);
            return $response;
        });

        // POST /api/v1/lecturers/bulk-upload
        $group->post('/bulk-upload', function ($request, $response) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $authMiddleware->process([]);

            $files = $request->getUploadedFiles();
            $filesArray = [];
            foreach ($files as $key => $file) {
                $filesArray[$key] = [
                    'name' => $file->getClientFilename(),
                    'type' => $file->getClientMediaType(),
                    'tmp_name' => $file->getStream()->getMetadata('uri'),
                    'error' => $file->getError(),
                    'size' => $file->getSize(),
                ];
            }

            $controller = $container->get(LecturerController::class);
            $controller->bulkUpload($filesArray);
            return $response;
        });

        // PATCH /api/v1/lecturers/{id}
        $group->patch('/{id}', function ($request, $response, $args) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $authMiddleware->process([]);

            $data = $request->getParsedBody();
            $controller = $container->get(LecturerController::class);
            $controller->update($args['id'], $data);
            return $response;
        });

        // DELETE /api/v1/lecturers/{id}
        $group->delete('/{id}', function ($request, $response, $args) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $authMiddleware->process([]);

            $controller = $container->get(LecturerController::class);
            $controller->delete($args['id']);
            return $response;
        });
    });

    // ===========================
    // Semester Routes (Authenticated)
    // ===========================

    $app->group($apiPrefix . '/semesters', function ($group) use ($container) {
        // GET /api/v1/semesters
        $group->get('', function ($request, $response) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $authMiddleware->process([]);

            $params = $request->getQueryParams();
            $controller = $container->get(SemesterController::class);
            $controller->index($params);
            return $response;
        });

        // GET /api/v1/semesters/active
        $group->get('/active', function ($request, $response) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $authMiddleware->process([]);

            $controller = $container->get(SemesterController::class);
            $controller->getActive();
            return $response;
        });

        // GET /api/v1/semesters/{id}
        $group->get('/{id}', function ($request, $response, $args) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $authMiddleware->process([]);

            $controller = $container->get(SemesterController::class);
            $controller->show($args['id']);
            return $response;
        });

        // POST /api/v1/semesters
        $group->post('', function ($request, $response) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $authMiddleware->process([]);

            $data = $request->getParsedBody();
            $controller = $container->get(SemesterController::class);
            $controller->create($data);
            return $response;
        });

        // PATCH /api/v1/semesters/{id}
        $group->patch('/{id}', function ($request, $response, $args) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $authMiddleware->process([]);

            $data = $request->getParsedBody();
            $controller = $container->get(SemesterController::class);
            $controller->update($args['id'], $data);
            return $response;
        });

        // POST /api/v1/semesters/{id}/toggle-active
        $group->post('/{id}/toggle-active', function ($request, $response, $args) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $authMiddleware->process([]);

            $controller = $container->get(SemesterController::class);
            $controller->toggleActive($args['id']);
            return $response;
        });

        // DELETE /api/v1/semesters/{id}
        $group->delete('/{id}', function ($request, $response, $args) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $authMiddleware->process([]);

            $controller = $container->get(SemesterController::class);
            $controller->delete($args['id']);
            return $response;
        });
    });

    // ===========================
    // Service Routes (Authenticated)
    // ===========================

    $app->group($apiPrefix . '/services', function ($group) use ($container) {
        // GET /api/v1/services
        $group->get('', function ($request, $response) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $authMiddleware->process([]);

            $params = $request->getQueryParams();
            $controller = $container->get(ServiceController::class);
            $controller->index($params);
            return $response;
        });

        // GET /api/v1/services/upcoming
        $group->get('/upcoming', function ($request, $response) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $authMiddleware->process([]);

            $params = $request->getQueryParams();
            $controller = $container->get(ServiceController::class);
            $controller->getUpcoming($params);
            return $response;
        });

        // GET /api/v1/services/date-range
        $group->get('/date-range', function ($request, $response) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $authMiddleware->process([]);

            $params = $request->getQueryParams();
            $controller = $container->get(ServiceController::class);
            $controller->getByDateRange($params);
            return $response;
        });

        // GET /api/v1/services/{id}
        $group->get('/{id}', function ($request, $response, $args) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $authMiddleware->process([]);

            $controller = $container->get(ServiceController::class);
            $controller->show($args['id']);
            return $response;
        });

        // POST /api/v1/services
        $group->post('', function ($request, $response) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $authMiddleware->process([]);

            $data = $request->getParsedBody();
            $controller = $container->get(ServiceController::class);
            $controller->create($data);
            return $response;
        });

        // PATCH /api/v1/services/{id}
        $group->patch('/{id}', function ($request, $response, $args) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $authMiddleware->process([]);

            $data = $request->getParsedBody();
            $controller = $container->get(ServiceController::class);
            $controller->update($args['id'], $data);
            return $response;
        });

        // DELETE /api/v1/services/{id}
        $group->delete('/{id}', function ($request, $response, $args) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $authMiddleware->process([]);

            $controller = $container->get(ServiceController::class);
            $controller->delete($args['id']);
            return $response;
        });
    });

    // ===========================
    // Attendance Routes (Authenticated)
    // ===========================

    $app->group($apiPrefix . '/attendance', function ($group) use ($container) {
        // POST /api/v1/attendance/search
        $group->post('/search', function ($request, $response) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $authMiddleware->process([]);

            $data = $request->getParsedBody();
            $controller = $container->get(AttendanceController::class);
            $controller->search($data);
            return $response;
        });

        // POST /api/v1/attendance/mark
        $group->post('/mark', function ($request, $response) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $requestData = $authMiddleware->process([]);

            $data = $request->getParsedBody();
            $controller = $container->get(AttendanceController::class);
            $controller->mark($data, $requestData);
            return $response;
        });

        // POST /api/v1/attendance/bulk
        $group->post('/bulk', function ($request, $response) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $requestData = $authMiddleware->process([]);

            $data = $request->getParsedBody();
            $controller = $container->get(AttendanceController::class);
            $controller->bulkMark($data, $requestData);
            return $response;
        });

        // GET /api/v1/attendance/service/{serviceId}
        $group->get('/service/{serviceId}', function ($request, $response, $args) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $authMiddleware->process([]);

            $controller = $container->get(AttendanceController::class);
            $controller->getServiceAttendance($args['serviceId']);
            return $response;
        });

        // GET /api/v1/attendance/student/{studentId}
        $group->get('/student/{studentId}', function ($request, $response, $args) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $authMiddleware->process([]);

            $params = $request->getQueryParams();
            $controller = $container->get(AttendanceController::class);
            $controller->getStudentAttendance($args['studentId'], $params);
            return $response;
        });

        // POST /api/v1/attendance/mark-lecturer
        $group->post('/mark-lecturer', function ($request, $response) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $requestData = $authMiddleware->process([]);

            $data = $request->getParsedBody();
            $controller = $container->get(AttendanceController::class);
            $controller->markLecturer($data, $requestData);
            return $response;
        });

        // GET /api/v1/attendance/service/{serviceId}/lecturers
        $group->get('/service/{serviceId}/lecturers', function ($request, $response, $args) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $authMiddleware->process([]);

            $controller = $container->get(AttendanceController::class);
            $controller->getServiceLecturerAttendance($args['serviceId']);
            return $response;
        });

        // GET /api/v1/attendance/lecturer/{lecturerId}
        $group->get('/lecturer/{lecturerId}', function ($request, $response, $args) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $authMiddleware->process([]);

            $params = $request->getQueryParams();
            $controller = $container->get(AttendanceController::class);
            $controller->getLecturerAttendance($args['lecturerId'], $params);
            return $response;
        });

        // POST /api/v1/attendance/search-lecturers
        $group->post('/search-lecturers', function ($request, $response) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $authMiddleware->process([]);

            $data = $request->getParsedBody();
            $controller = $container->get(AttendanceController::class);
            $controller->searchLecturers($data);
            return $response;
        });
    });

    // ===========================
    // Report Routes (Authenticated)
    // ===========================

    $app->group($apiPrefix . '/reports', function ($group) use ($container) {
        // GET /api/v1/reports/semester/{semesterId}
        $group->get('/semester/{semesterId}', function ($request, $response, $args) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $authMiddleware->process([]);

            $params = $request->getQueryParams();
            $controller = $container->get(ReportController::class);
            $controller->semesterReport($args['semesterId'], $params);
            return $response;
        });

        // GET /api/v1/reports/semester/{semesterId}/stats
        $group->get('/semester/{semesterId}/stats', function ($request, $response, $args) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $authMiddleware->process([]);

            $controller = $container->get(ReportController::class);
            $controller->semesterStats($args['semesterId']);
            return $response;
        });

        // GET /api/v1/reports/semester/{semesterId}/lecturers
        $group->get('/semester/{semesterId}/lecturers', function ($request, $response, $args) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $authMiddleware->process([]);

            $params = $request->getQueryParams();
            $controller = $container->get(ReportController::class);
            $controller->lecturerSemesterReport($args['semesterId'], $params);
            return $response;
        });

        // POST /api/v1/reports/upload
        $group->post('/upload', function ($request, $response) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $authMiddleware->process([]);

            $files = $request->getUploadedFiles();
            $filesArray = [];
            foreach ($files as $key => $file) {
                $filesArray[$key] = [
                    'name' => $file->getClientFilename(),
                    'type' => $file->getClientMediaType(),
                    'tmp_name' => $file->getStream()->getMetadata('uri'),
                    'error' => $file->getError(),
                    'size' => $file->getSize(),
                ];
            }

            $controller = $container->get(ReportController::class);
            $controller->uploadExcel($filesArray);
            return $response;
        });

        // GET /api/v1/reports/export
        $group->get('/export', function ($request, $response) use ($container) {
            $authMiddleware = new AuthMiddleware();
            $authMiddleware->process([]);

            $params = $request->getQueryParams();
            $controller = $container->get(ReportController::class);
            $controller->export($params);
            return $response;
        });
    });

    // ===========================
    // Health Check Route
    // ===========================

    $app->get($apiPrefix . '/health', function ($request, $response) {
        $response->getBody()->write(json_encode([
            'success' => true,
            'message' => 'API is healthy',
            'timestamp' => date('Y-m-d H:i:s'),
        ]));
        return $response->withHeader('Content-Type', 'application/json');
    });
};
