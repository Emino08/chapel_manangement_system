# Chapel Management System - Testing Guide

## Quick Start

### Prerequisites
1. **Backend API** running on `http://localhost:8080`
2. **MySQL Database** on port `4306` with schema loaded
3. **Admin account**: `admin@chapel.local` / `Admin#12345`
4. **Node.js 18+** and **PHP 8.2+** installed

### Run All Tests (Automated)

**Windows:**
```bash
run-tests.bat
```

**Linux/Mac:**
```bash
chmod +x run-tests.sh
./run-tests.sh
```

### Verify System Health

**Windows:**
```bash
verify-system.bat
```

**Linux/Mac:**
```bash
chmod +x verify-system.sh
./verify-system.sh
```

## Test Coverage Overview

### ✅ Backend Tests (PHPUnit)

#### Integration Tests (3 files, 20+ tests)
- **AuthTest.php** - Authentication & Authorization
  - Health check endpoint
  - Login with valid/invalid credentials
  - Token validation
  - User authentication flow

- **StudentTest.php** - Student Management
  - CRUD operations (Create, Read, Update, Delete)
  - Search and filtering
  - Duplicate validation
  - Pagination
  - Unauthorized access prevention

- **AttendanceTest.php** - Attendance System
  - Mark attendance (Present/Absent)
  - Update attendance status (idempotent)
  - Bulk attendance marking
  - Student search for attendance
  - Service attendance listing
  - Student attendance history

#### Unit Tests (2 files, 15+ tests)
- **ValidatorTest.php** - Input Validation
  - Email validation
  - Required fields validation
  - Role validation (ADMIN, HR, SUO)
  - Phone number validation
  - Date & time validation
  - UUID validation
  - Attendance status validation

- **JwtHelperTest.php** - JWT Token Management
  - Token generation
  - Token verification
  - Expired token detection
  - Invalid token handling
  - Expiration field validation

### ✅ Frontend Tests (Playwright)

#### End-to-End Tests (3 files, 25+ scenarios)
- **auth.spec.ts** - Authentication Flow
  - Login page display
  - Valid/invalid credentials
  - Field validation
  - Logout functionality

- **students.spec.ts** - Student Management UI
  - List display
  - Create new student
  - Search functionality
  - Filter by program/faculty
  - Edit student details
  - Delete student
  - Pagination handling

- **attendance.spec.ts** - Attendance Flow
  - Service selection
  - Student search
  - Mark present/absent
  - Update attendance status
  - Filter by program
  - Attendance summary view

## Running Tests

### Backend Only

#### All Backend Tests
```bash
cd api
composer test
```

#### Unit Tests Only
```bash
cd api
./vendor/bin/phpunit --testsuite "Unit Tests"
```

#### Integration Tests Only
```bash
cd api
./vendor/bin/phpunit --testsuite "Integration Tests"
```

#### Specific Test File
```bash
cd api
./vendor/bin/phpunit tests/Integration/AuthTest.php
./vendor/bin/phpunit tests/Unit/ValidatorTest.php
```

#### With Coverage Report
```bash
cd api
./vendor/bin/phpunit --coverage-html coverage
```

### Frontend Only

#### Install Playwright
```bash
cd web
npm install --save-dev @playwright/test
npx playwright install
```

#### All E2E Tests
```bash
cd web
npm test
# or
npx playwright test
```

#### Interactive UI Mode
```bash
cd web
npm run test:ui
# or
npx playwright test --ui
```

#### Specific Browser
```bash
npx playwright test --project=chromium
npx playwright test --project=firefox
npx playwright test --project=webkit
```

#### Specific Test File
```bash
npx playwright test tests/e2e/auth.spec.ts
npx playwright test tests/e2e/students.spec.ts
```

#### View Test Report
```bash
cd web
npm run test:report
# or
npx playwright show-report
```

#### Debug Mode
```bash
npx playwright test --debug
```

## Test Scenarios Covered

### 1. Authentication & Security
- ✅ User login with correct credentials
- ✅ Login failure with wrong password
- ✅ Login failure with missing fields
- ✅ JWT token generation and validation
- ✅ Token expiration handling
- ✅ Unauthorized access prevention
- ✅ Role-based access control

### 2. Student Management
- ✅ Create single student
- ✅ Bulk CSV upload (tested via integration)
- ✅ Duplicate student number validation
- ✅ Search by name, phone, student number
- ✅ Filter by program and faculty
- ✅ Update student information
- ✅ Delete student
- ✅ View student details
- ✅ Pagination with large datasets

### 3. Attendance System
- ✅ Service creation
- ✅ Mark student present
- ✅ Mark student absent
- ✅ Update attendance status (no duplicates)
- ✅ Bulk mark attendance for multiple students
- ✅ Search students for attendance
- ✅ Filter by program during attendance
- ✅ View service attendance list
- ✅ View student attendance history
- ✅ Attendance count per semester

### 4. Data Validation
- ✅ Email format validation
- ✅ Phone number format validation
- ✅ Date format validation (YYYY-MM-DD)
- ✅ Time format validation (HH:MM:SS)
- ✅ UUID format validation
- ✅ Required fields validation
- ✅ Role enumeration validation
- ✅ Attendance status enumeration

### 5. User Interface
- ✅ Login page functionality
- ✅ Dashboard access after login
- ✅ Navigation between pages
- ✅ Form submissions
- ✅ Search and filter controls
- ✅ Data table operations
- ✅ Modal dialogs
- ✅ Success/error notifications
- ✅ Logout flow

## Expected Test Results

### Successful Test Run Output

```
==========================================
Chapel Management System - Test Suite
==========================================

[1/5] Checking API Server...
✓ API Server is running

[2/5] Running Backend Unit Tests...
PHPUnit 10.5.x

Unit Tests
✓ Email validation works correctly
✓ Required fields are validated
✓ Role validation works
✓ JWT tokens are generated correctly
✓ JWT tokens are verified correctly
... (15 tests)

Time: 00:00.123, Memory: 10.00 MB
OK (15 tests, 45 assertions)

[3/5] Running Backend Integration Tests...
PHPUnit 10.5.x

Integration Tests
✓ Health check returns 200
✓ Login with valid credentials works
✓ Students can be created
✓ Attendance can be marked
... (20 tests)

Time: 00:02.456, Memory: 12.00 MB
OK (20 tests, 80 assertions)

[4/5] Checking Playwright Installation...
✓ Playwright is installed

[5/5] Running Frontend E2E Tests...

Running 25 tests using 3 workers

  ✓ auth.spec.ts:5:3 › should display login page (1.2s)
  ✓ auth.spec.ts:10:3 › should login with valid credentials (2.1s)
  ✓ students.spec.ts:8:3 › should display students list (1.5s)
  ✓ students.spec.ts:15:3 › should create a new student (3.2s)
  ✓ attendance.spec.ts:12:3 › should mark attendance (2.8s)
  ... (25 tests)

  25 passed (45.2s)

==========================================
✓ All Tests Passed Successfully!
==========================================

Test Summary:
  ✓ Backend Unit Tests (15 passed)
  ✓ Backend Integration Tests (20 passed)
  ✓ Frontend E2E Tests (25 passed)
```

## Continuous Integration

### GitHub Actions Setup

Create `.github/workflows/tests.yml`:

```yaml
name: Tests

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  backend-tests:
    runs-on: ubuntu-latest

    services:
      mysql:
        image: mysql:8.0
        env:
          MYSQL_ROOT_PASSWORD: root
          MYSQL_DATABASE: chapel_db
        ports:
          - 4306:3306
        options: >-
          --health-cmd="mysqladmin ping"
          --health-interval=10s
          --health-timeout=5s
          --health-retries=3

    steps:
      - uses: actions/checkout@v3

      - name: Setup PHP
        uses: shivammathur/setup-php@v2
        with:
          php-version: '8.2'
          extensions: pdo, pdo_mysql

      - name: Install dependencies
        run: cd api && composer install --no-interaction

      - name: Setup database
        run: |
          cd api
          php bin/load-schema.php

      - name: Run tests
        run: cd api && composer test

  frontend-tests:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'

      - name: Install dependencies
        run: cd web && npm ci

      - name: Install Playwright
        run: cd web && npx playwright install --with-deps

      - name: Run E2E tests
        run: cd web && npm test

      - name: Upload test results
        uses: actions/upload-artifact@v3
        if: always()
        with:
          name: playwright-report
          path: web/playwright-report/
```

## Troubleshooting

### Common Issues

#### 1. API Server Not Running
```bash
# Start API server
cd api
php -S localhost:8080 -t public
```

#### 2. Database Connection Failed
```bash
# Check MySQL is running on port 4306
mysql -h localhost -P 4306 -u root -p

# Reload schema
cd api
php bin/load-schema.php
```

#### 3. Authentication Tests Failing
```bash
# Verify admin user exists
cd api
php -r "
require 'vendor/autoload.php';
\$dotenv = Dotenv\Dotenv::createImmutable(__DIR__);
\$dotenv->load();
\$pdo = new PDO('mysql:host=localhost;port=4306;dbname=chapel_db', 'root', 'root');
\$stmt = \$pdo->query(\"SELECT * FROM users WHERE email='admin@chapel.local'\");
print_r(\$stmt->fetch());
"
```

#### 4. Playwright Tests Timeout
```bash
# Increase timeout in playwright.config.ts
# Add: timeout: 60000
```

#### 5. Token Expired Errors
- Tests generate fresh tokens for each run
- If still failing, check JWT_SECRET in .env matches

## Manual Testing Checklist

### Pre-Test Setup
- [ ] Database is running and accessible
- [ ] Schema is loaded with seed data
- [ ] API server is running on port 8080
- [ ] Frontend is accessible (if testing E2E)

### Core Functionality
- [ ] Login with admin credentials works
- [ ] Can create a new student
- [ ] Can search for students
- [ ] Can create a service
- [ ] Can mark attendance
- [ ] Can view reports
- [ ] Can create users (admin only)
- [ ] Can upload CSV files
- [ ] Can export reports

### Edge Cases
- [ ] Duplicate student numbers are rejected
- [ ] Invalid email formats are rejected
- [ ] Attendance cannot be marked twice (updates instead)
- [ ] Unauthorized users cannot access protected routes
- [ ] Invalid tokens are rejected
- [ ] Required fields are validated

## Performance Benchmarks

Expected test execution times:
- **Unit Tests**: < 1 second
- **Integration Tests**: 2-5 seconds
- **E2E Tests**: 30-60 seconds (depends on browser)
- **Full Suite**: < 2 minutes

## Next Steps

1. **Increase Coverage**: Add more edge case tests
2. **Performance Tests**: Add load testing with Apache Bench or K6
3. **Security Tests**: Add penetration testing scenarios
4. **Visual Testing**: Add screenshot comparison tests
5. **API Contract Tests**: Add Pact or similar contract tests
6. **Accessibility Tests**: Add a11y testing with axe-core

## Support

For test-related issues:
1. Check this guide's troubleshooting section
2. Review test output for specific error messages
3. Verify all prerequisites are met
4. Check API and database logs
5. Run `./verify-system.sh` to diagnose issues
