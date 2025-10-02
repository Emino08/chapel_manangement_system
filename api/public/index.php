<?php

/**
 * Chapel Management System API
 *
 * Entry point for the Slim Framework application
 */

// Set CORS headers immediately - BEFORE any other processing
header('Access-Control-Allow-Origin: http://localhost:3000');
header('Access-Control-Allow-Methods: GET, POST, PUT, PATCH, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With, Accept, Origin');
header('Access-Control-Allow-Credentials: true');
header('Access-Control-Max-Age: 86400');

// Handle preflight OPTIONS request immediately
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// Capture and parse JSON immediately for login route to fix NULL email issue
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $requestUri = $_SERVER['REQUEST_URI'];
    // Handle different URI formats (with or without query string)
    $path = parse_url($requestUri, PHP_URL_PATH);

    if ($path === '/api/v1/auth/login' ||
        strpos($path, '/api/v1/auth/login') !== false ||
        strpos($requestUri, '/auth/login') !== false) {

        $rawInput = file_get_contents('php://input');
        error_log("JSON Debug - Request URI: " . $requestUri);
        error_log("JSON Debug - Path: " . $path);
        error_log("JSON Debug - Raw input: " . $rawInput);

        if (!empty($rawInput)) {
            $jsonData = json_decode($rawInput, true);
            $jsonError = json_last_error();
            error_log("JSON Debug - Decoded: " . json_encode($jsonData));
            error_log("JSON Debug - JSON Error Code: " . $jsonError);

            if ($jsonError === JSON_ERROR_NONE && is_array($jsonData)) {
                // Store parsed JSON in $_POST for later retrieval
                $_POST = array_merge($_POST, $jsonData);
                // Also store in global for access in routes
                $GLOBALS['parsed_json_body'] = $jsonData;
                error_log("JSON Debug - Successfully stored in global and POST");
            }
        }
    }
}

// Set timezone from environment or default to Africa/Freetown
$timezone = $_ENV['APP_TIMEZONE'] ?? 'Africa/Freetown';
date_default_timezone_set($timezone);

use Slim\Factory\AppFactory;
use DI\Container;
use Dotenv\Dotenv;
use Chapel\Middleware\CorsMiddleware;
use Chapel\Utils\ResponseHelper;

// Load Composer autoloader
require __DIR__ . '/../vendor/autoload.php';

// Load environment variables
$dotenv = Dotenv::createImmutable(__DIR__ . '/..');
$dotenv->load();


// Create PHP-DI Container
$container = new Container();

// Register services in container
$container->set(Chapel\Repositories\UserRepository::class, function () {
    return new Chapel\Repositories\UserRepository();
});

$container->set(Chapel\Repositories\StudentRepository::class, function () {
    return new Chapel\Repositories\StudentRepository();
});

$container->set(Chapel\Repositories\PastorRepository::class, function () {
    return new Chapel\Repositories\PastorRepository();
});

$container->set(Chapel\Repositories\SemesterRepository::class, function () {
    return new Chapel\Repositories\SemesterRepository();
});

$container->set(Chapel\Repositories\ServiceRepository::class, function () {
    return new Chapel\Repositories\ServiceRepository();
});

$container->set(Chapel\Repositories\AttendanceRepository::class, function () {
    return new Chapel\Repositories\AttendanceRepository();
});

$container->set(Chapel\Repositories\LecturerRepository::class, function () {
    return new Chapel\Repositories\LecturerRepository();
});

$container->set(Chapel\Repositories\LecturerAttendanceRepository::class, function () {
    return new Chapel\Repositories\LecturerAttendanceRepository();
});

$container->set(Chapel\Utils\JwtHelper::class, function () {
    return new Chapel\Utils\JwtHelper();
});

$container->set(Chapel\Utils\Validator::class, function () {
    return new Chapel\Utils\Validator();
});

$container->set(Chapel\Utils\CsvParser::class, function () {
    return new Chapel\Utils\CsvParser();
});

$container->set(Chapel\Utils\ExcelHandler::class, function () {
    return new Chapel\Utils\ExcelHandler();
});

// Register Controllers
$container->set(Chapel\Controllers\AuthController::class, function ($c) {
    return new Chapel\Controllers\AuthController(
        $c->get(Chapel\Repositories\UserRepository::class),
        $c->get(Chapel\Utils\JwtHelper::class),
        $c->get(Chapel\Utils\Validator::class)
    );
});

$container->set(Chapel\Controllers\UserController::class, function ($c) {
    return new Chapel\Controllers\UserController(
        $c->get(Chapel\Repositories\UserRepository::class),
        $c->get(Chapel\Utils\Validator::class)
    );
});

$container->set(Chapel\Controllers\StudentController::class, function ($c) {
    return new Chapel\Controllers\StudentController(
        $c->get(Chapel\Repositories\StudentRepository::class),
        $c->get(Chapel\Utils\Validator::class),
        $c->get(Chapel\Utils\CsvParser::class),
        $c->get(Chapel\Utils\ExcelHandler::class)
    );
});

$container->set(Chapel\Controllers\PastorController::class, function ($c) {
    return new Chapel\Controllers\PastorController(
        $c->get(Chapel\Repositories\PastorRepository::class),
        $c->get(Chapel\Utils\Validator::class),
        $c->get(Chapel\Utils\CsvParser::class),
        $c->get(Chapel\Utils\ExcelHandler::class)
    );
});

$container->set(Chapel\Controllers\SemesterController::class, function ($c) {
    return new Chapel\Controllers\SemesterController(
        $c->get(Chapel\Repositories\SemesterRepository::class),
        $c->get(Chapel\Utils\Validator::class)
    );
});

$container->set(Chapel\Controllers\ServiceController::class, function ($c) {
    return new Chapel\Controllers\ServiceController(
        $c->get(Chapel\Repositories\ServiceRepository::class),
        $c->get(Chapel\Repositories\PastorRepository::class),
        $c->get(Chapel\Utils\Validator::class)
    );
});

$container->set(Chapel\Controllers\LecturerController::class, function ($c) {
    return new Chapel\Controllers\LecturerController(
        $c->get(Chapel\Repositories\LecturerRepository::class),
        $c->get(Chapel\Utils\Validator::class),
        $c->get(Chapel\Utils\CsvParser::class),
        $c->get(Chapel\Utils\ExcelHandler::class)
    );
});

$container->set(Chapel\Controllers\AttendanceController::class, function ($c) {
    return new Chapel\Controllers\AttendanceController(
        $c->get(Chapel\Repositories\AttendanceRepository::class),
        $c->get(Chapel\Repositories\ServiceRepository::class),
        $c->get(Chapel\Repositories\StudentRepository::class),
        $c->get(Chapel\Repositories\LecturerRepository::class),
        $c->get(Chapel\Repositories\LecturerAttendanceRepository::class),
        $c->get(Chapel\Utils\Validator::class)
    );
});

$container->set(Chapel\Controllers\ReportController::class, function ($c) {
    return new Chapel\Controllers\ReportController(
        $c->get(Chapel\Repositories\AttendanceRepository::class),
        $c->get(Chapel\Repositories\LecturerAttendanceRepository::class),
        $c->get(Chapel\Repositories\SemesterRepository::class),
        $c->get(Chapel\Repositories\ServiceRepository::class),
        $c->get(Chapel\Utils\ExcelHandler::class)
    );
});

// Create Slim App with container
AppFactory::setContainer($container);
$app = AppFactory::create();

// Add CORS Middleware FIRST (before any other middleware)
$app->add(new CorsMiddleware());

// Add Body Parsing Middleware (Slim's built-in handles JSON automatically)
$app->addBodyParsingMiddleware();

// Add Routing Middleware
$app->addRoutingMiddleware();

// Add Error Middleware
$errorMiddleware = $app->addErrorMiddleware(
    ($_ENV['APP_DEBUG'] ?? 'false') === 'true',
    true,
    true
);

// Custom Error Handler
$errorHandler = $errorMiddleware->getDefaultErrorHandler();
$errorHandler->forceContentType('application/json');

// Set custom error handler for all exceptions
$errorMiddleware->setDefaultErrorHandler(function (
    $request,
    $exception,
    $displayErrorDetails,
    $logErrors,
    $logErrorDetails
) {
    $statusCode = 500;
    $title = 'Internal Server Error';
    $detail = $exception->getMessage();

    // Map exception types to appropriate responses
    if ($exception instanceof Chapel\Exceptions\ValidationException) {
        ResponseHelper::validationError($exception);
        exit;
    }

    if ($exception instanceof Chapel\Exceptions\UnauthorizedException) {
        $statusCode = 401;
        $title = 'Unauthorized';
    } elseif ($exception instanceof Chapel\Exceptions\ForbiddenException) {
        $statusCode = 403;
        $title = 'Forbidden';
    } elseif ($exception instanceof Chapel\Exceptions\NotFoundException) {
        $statusCode = 404;
        $title = 'Not Found';
    } elseif ($exception instanceof Chapel\Exceptions\DatabaseException) {
        $statusCode = 500;
        $title = 'Database Error';
    }

    ResponseHelper::error($title, $detail, $statusCode);
    exit;
});

// Load routes
$routes = require __DIR__ . '/../src/routes.php';
$routes($app, $container);

// Run the application
$app->run();
