<?php
/**
 * Database Schema Loader
 * Loads and executes the schema.sql file to set up the database
 */

require_once __DIR__ . '/../vendor/autoload.php';

use Dotenv\Dotenv;

// Load environment variables
$dotenv = Dotenv::createImmutable(__DIR__ . '/..');
$dotenv->load();

// Database configuration
$host = $_ENV['DB_HOST'] ?? 'localhost';
$port = $_ENV['DB_PORT'] ?? '4306';
$database = $_ENV['DB_NAME'] ?? 'chapel_db';
$username = $_ENV['DB_USER'] ?? 'root';
$password = $_ENV['DB_PASS'] ?? '';

echo "==========================================\n";
echo "Chapel Management System - Schema Loader\n";
echo "==========================================\n\n";

echo "Database Configuration:\n";
echo "Host: $host\n";
echo "Port: $port\n";
echo "Database: $database\n";
echo "User: $username\n\n";

try {
    // Connect to MySQL server (without database selection first)
    echo "Connecting to MySQL server...\n";
    $pdo = new PDO(
        "mysql:host=$host;port=$port;charset=utf8mb4",
        $username,
        $password,
        [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        ]
    );
    echo "✓ Connected to MySQL server\n\n";

    // Create database if it doesn't exist
    echo "Creating database '$database' if not exists...\n";
    $pdo->exec("CREATE DATABASE IF NOT EXISTS `$database` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
    echo "✓ Database ready\n\n";

    // Switch to the database
    $pdo->exec("USE `$database`");
    echo "Using database '$database'\n\n";

    // Read the schema file
    $schemaFile = __DIR__ . '/../../database/schema.sql';

    if (!file_exists($schemaFile)) {
        throw new Exception("Schema file not found: $schemaFile");
    }

    echo "Reading schema file...\n";
    $sql = file_get_contents($schemaFile);
    echo "✓ Schema file loaded\n\n";

    // Split SQL into individual statements
    // Remove comments and split by semicolons
    $sql = preg_replace('/^--.*$/m', '', $sql); // Remove single-line comments
    $sql = preg_replace('/\/\*.*?\*\//s', '', $sql); // Remove multi-line comments

    // Split by semicolons but keep multi-line statements together
    $statements = array_filter(
        array_map('trim', preg_split('/;[\s]*\n/', $sql)),
        fn($stmt) => !empty($stmt)
    );

    echo "Executing schema...\n";
    echo "Found " . count($statements) . " SQL statements\n\n";

    $pdo->setAttribute(PDO::ATTR_EMULATE_PREPARES, 0);

    $successCount = 0;
    $errorCount = 0;

    foreach ($statements as $index => $statement) {
        if (empty(trim($statement))) {
            continue;
        }

        try {
            // Show progress for important operations
            if (stripos($statement, 'CREATE TABLE') !== false) {
                preg_match('/CREATE TABLE\s+(`?\w+`?)/i', $statement, $matches);
                $tableName = $matches[1] ?? 'unknown';
                echo "  Creating table $tableName...\n";
            } elseif (stripos($statement, 'DROP TABLE') !== false) {
                preg_match('/DROP TABLE\s+IF EXISTS\s+(`?\w+`?)/i', $statement, $matches);
                $tableName = $matches[1] ?? 'unknown';
                echo "  Dropping table $tableName if exists...\n";
            } elseif (stripos($statement, 'INSERT INTO') !== false) {
                preg_match('/INSERT INTO\s+(`?\w+`?)/i', $statement, $matches);
                $tableName = $matches[1] ?? 'unknown';
                echo "  Inserting data into $tableName...\n";
            } elseif (stripos($statement, 'CREATE OR REPLACE VIEW') !== false || stripos($statement, 'CREATE VIEW') !== false) {
                preg_match('/CREATE (?:OR REPLACE )?VIEW\s+(`?\w+`?)/i', $statement, $matches);
                $viewName = $matches[1] ?? 'unknown';
                echo "  Creating view $viewName...\n";
            }

            $pdo->exec($statement);
            $successCount++;
        } catch (PDOException $e) {
            // Some statements might fail gracefully (like SET statements)
            // Only show actual errors
            if ($e->getCode() !== '00000') {
                echo "  ⚠ Warning on statement " . ($index + 1) . ": " . $e->getMessage() . "\n";
                $errorCount++;
            }
        }
    }

    echo "\n==========================================\n";
    echo "Schema loaded successfully!\n";
    echo "Successful statements: $successCount\n";
    if ($errorCount > 0) {
        echo "Warnings: $errorCount\n";
    }
    echo "==========================================\n\n";

    // Verify tables were created
    echo "Verifying database setup...\n";
    $tables = $pdo->query("SHOW TABLES")->fetchAll(PDO::FETCH_COLUMN);
    echo "Tables created: " . count($tables) . "\n";
    foreach ($tables as $table) {
        echo "  ✓ $table\n";
    }

    echo "\n";

    // Check for views
    $views = $pdo->query("SHOW FULL TABLES WHERE Table_type = 'VIEW'")->fetchAll(PDO::FETCH_COLUMN);
    if (count($views) > 0) {
        echo "Views created: " . count($views) . "\n";
        foreach ($views as $view) {
            echo "  ✓ $view\n";
        }
        echo "\n";
    }

    // Show sample data counts
    echo "Sample data loaded:\n";
    $dataCheck = [
        'users' => 'SELECT COUNT(*) as count FROM users',
        'students' => 'SELECT COUNT(*) as count FROM students',
        'pastors' => 'SELECT COUNT(*) as count FROM pastors',
        'semesters' => 'SELECT COUNT(*) as count FROM semesters',
        'services' => 'SELECT COUNT(*) as count FROM services',
        'attendance' => 'SELECT COUNT(*) as count FROM attendance',
    ];

    foreach ($dataCheck as $table => $query) {
        $result = $pdo->query($query)->fetch();
        echo "  $table: {$result['count']} records\n";
    }

    echo "\n==========================================\n";
    echo "✓ Database setup complete!\n";
    echo "==========================================\n\n";

    echo "Default admin credentials:\n";
    echo "  Email: admin@chapel.local\n";
    echo "  Password: Admin#12345\n\n";

    echo "You can now start the API server:\n";
    echo "  cd api\n";
    echo "  php -S localhost:8080 -t public\n\n";

} catch (PDOException $e) {
    echo "\n✗ Database Error: " . $e->getMessage() . "\n";
    echo "Error Code: " . $e->getCode() . "\n\n";
    exit(1);
} catch (Exception $e) {
    echo "\n✗ Error: " . $e->getMessage() . "\n\n";
    exit(1);
}
