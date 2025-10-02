<?php

/**
 * Fix Admin Password
 *
 * This script updates the admin user password to Admin#12345
 */

require __DIR__ . '/../vendor/autoload.php';

use Dotenv\Dotenv;

// Load environment variables
$dotenv = Dotenv::createImmutable(__DIR__ . '/..');
$dotenv->load();

try {
    // Connect to database
    $pdo = new PDO(
        sprintf(
            'mysql:host=%s;port=%s;dbname=%s',
            $_ENV['DB_HOST'],
            $_ENV['DB_PORT'],
            $_ENV['DB_NAME']
        ),
        $_ENV['DB_USER'],
        $_ENV['DB_PASS'],
        [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
    );

    echo "Connected to database successfully.\n\n";

    // Generate correct password hash for Admin#12345
    $correctPassword = 'Admin#12345';
    $correctHash = password_hash($correctPassword, PASSWORD_DEFAULT);

    echo "Generated password hash for 'Admin#12345':\n";
    echo $correctHash . "\n\n";

    // Update admin user password
    $stmt = $pdo->prepare("
        UPDATE users
        SET password_hash = :password_hash
        WHERE email = 'admin@chapel.local'
    ");

    $stmt->execute(['password_hash' => $correctHash]);

    echo "✓ Admin password updated successfully!\n\n";

    // Verify the update
    $stmt = $pdo->prepare("SELECT * FROM users WHERE email = 'admin@chapel.local'");
    $stmt->execute();
    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($user) {
        echo "Admin user details:\n";
        echo "  Email: " . $user['email'] . "\n";
        echo "  Name: " . $user['name'] . "\n";
        echo "  Role: " . $user['role'] . "\n";
        echo "  Password Hash: " . substr($user['password_hash'], 0, 20) . "...\n\n";

        // Test password verification
        if (password_verify($correctPassword, $user['password_hash'])) {
            echo "✓ Password verification test PASSED\n";
            echo "✓ You can now login with:\n";
            echo "    Email: admin@chapel.local\n";
            echo "    Password: Admin#12345\n";
        } else {
            echo "✗ Password verification test FAILED\n";
        }
    } else {
        echo "✗ Admin user not found!\n";
    }

} catch (PDOException $e) {
    echo "Database error: " . $e->getMessage() . "\n";
    exit(1);
} catch (Exception $e) {
    echo "Error: " . $e->getMessage() . "\n";
    exit(1);
}
