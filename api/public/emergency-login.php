<?php
/**
 * Emergency Login Handler - Direct JSON Processing
 * This bypasses all Slim middleware to handle the login directly
 */

// Only handle login requests
if ($_SERVER['REQUEST_METHOD'] !== 'POST' ||
    strpos($_SERVER['REQUEST_URI'], '/auth/login') === false) {
    return;
}

// Set CORS headers immediately
header('Access-Control-Allow-Origin: http://localhost:3000');
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With, Accept, Origin');
header('Access-Control-Allow-Credentials: true');
header('Content-Type: application/json');

// Handle OPTIONS preflight
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// Get JSON data from request
$rawInput = file_get_contents('php://input');
$data = json_decode($rawInput, true);

if (!$data || !isset($data['email']) || !isset($data['password'])) {
    http_response_code(422);
    echo json_encode([
        'success' => false,
        'type' => 'https://httpstatuses.com/422',
        'title' => 'Validation Failed',
        'status' => 422,
        'detail' => 'Missing email or password',
        'debug' => [
            'raw_input' => $rawInput,
            'parsed_data' => $data,
            'request_uri' => $_SERVER['REQUEST_URI'],
            'method' => $_SERVER['REQUEST_METHOD']
        ]
    ]);
    exit();
}

// Simple validation
$email = $data['email'];
$password = $data['password'];

if (empty($email) || empty($password)) {
    http_response_code(422);
    echo json_encode([
        'success' => false,
        'type' => 'https://httpstatuses.com/422',
        'title' => 'Validation Failed',
        'status' => 422,
        'detail' => 'Email and password are required',
        'errors' => [
            'email' => empty($email) ? ['Email is required'] : [],
            'password' => empty($password) ? ['Password is required'] : []
        ]
    ]);
    exit();
}

// Connect to database and verify credentials
try {
    $pdo = new PDO('mysql:host=localhost;port=4306;dbname=chapel_db;charset=utf8mb4', 'root', '');
    $stmt = $pdo->prepare('SELECT id, name, email, role, password_hash FROM users WHERE email = ?');
    $stmt->execute([$email]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$user || !password_verify($password, $user['password_hash'])) {
        http_response_code(401);
        echo json_encode([
            'success' => false,
            'type' => 'https://httpstatuses.com/401',
            'title' => 'Unauthorized',
            'status' => 401,
            'detail' => 'Invalid email or password'
        ]);
        exit();
    }

    // Generate simple token (for testing - use proper JWT in production)
    $token = base64_encode(json_encode([
        'user_id' => $user['id'],
        'email' => $user['email'],
        'role' => $user['role'],
        'exp' => time() + 3600
    ]));

    // Remove password hash from response
    unset($user['password_hash']);

    // Return success response
    echo json_encode([
        'success' => true,
        'data' => [
            'token' => $token,
            'user' => $user
        ],
        'message' => 'Login successful'
    ]);
    exit();

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'type' => 'https://httpstatuses.com/500',
        'title' => 'Internal Server Error',
        'status' => 500,
        'detail' => 'Database connection failed: ' . $e->getMessage()
    ]);
    exit();
}
?>
