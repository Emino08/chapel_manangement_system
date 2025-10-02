# Chapel Management System - Test Suite Documentation

## Overview

This document describes the comprehensive test suite for the Chapel Management System. The test suite includes backend integration tests, unit tests, and frontend end-to-end tests.

## Test Structure

```
api/
├── tests/
│   ├── Integration/
│   │   ├── AuthTest.php          # Authentication API tests
│   │   ├── StudentTest.php       # Student management tests
│   │   └── AttendanceTest.php    # Attendance management tests
│   └── Unit/
│       ├── ValidatorTest.php     # Validator utility tests
│       └── JwtHelperTest.php     # JWT helper tests
└── phpunit.xml                    # PHPUnit configuration

web/
├── tests/
│   └── e2e/
│       ├── auth.spec.ts          # Authentication flow tests
│       ├── students.spec.ts      # Student management tests
│       └── attendance.spec.ts    # Attendance flow tests
└── playwright.config.ts           # Playwright configuration
```

## Backend Tests

### Integration Tests

#### AuthTest.php
Tests authentication functionality:
- ✅ Health check endpoint
- ✅ Login with valid credentials
- ✅ Login with invalid credentials
- ✅ Login with missing email
- ✅ Get current user with valid token
- ✅ Get current user without token

#### StudentTest.php
Tests student management:
- ✅ Get students list
- ✅ Create new student
- ✅ Create student with duplicate number (validation)
- ✅ Search students by query
- ✅ Filter students by program
- ✅ Get student by ID
- ✅ Update student information
- ✅ Delete student
- ✅ Unauthorized access prevention

#### AttendanceTest.php
Tests attendance functionality:
- ✅ Mark attendance (present/absent)
- ✅ Update attendance status (idempotent)
- ✅ Search students for attendance
- ✅ Get service attendance list
- ✅ Bulk mark attendance
- ✅ Get student attendance history

### Unit Tests

#### ValidatorTest.php
Tests validation utilities:
- ✅ Email validation (valid/invalid)
- ✅ Required fields validation
- ✅ Role validation (ADMIN, HR, SUO)
- ✅ Phone number validation
- ✅ Date validation
- ✅ Time validation
- ✅ UUID validation
- ✅ Attendance status validation

#### JwtHelperTest.php
Tests JWT token handling:
- ✅ Token generation
- ✅ Valid token verification
- ✅ Expired token detection
- ✅ Invalid token rejection
- ✅ Expiration field presence

## Frontend E2E Tests

### auth.spec.ts
Tests authentication flow:
- ✅ Display login page
- ✅ Login with valid credentials
- ✅ Show error with invalid credentials
- ✅ Validate required fields
- ✅ Logout successfully

### students.spec.ts
Tests student management UI:
- ✅ Display students list
- ✅ Create new student
- ✅ Search students
- ✅ Filter by program
- ✅ Edit student
- ✅ Delete student
- ✅ Handle pagination

### attendance.spec.ts
Tests attendance marking:
- ✅ Display attendance page
- ✅ Select service
- ✅ Search and mark student present
- ✅ Mark student absent
- ✅ Update attendance status
- ✅ Filter by program
- ✅ View attendance summary

## Running Tests

### Backend Tests

#### Prerequisites
1. Ensure the API server is running on `http://localhost:8080`
2. Database is set up with schema loaded
3. Admin user exists: `admin@chapel.local` / `Admin#12345`

#### Run All Tests
```bash
cd api
composer test
```

#### Run Specific Test Suite
```bash
# Integration tests only
./vendor/bin/phpunit --testsuite "Integration Tests"

# Unit tests only
./vendor/bin/phpunit --testsuite "Unit Tests"
```

#### Run Specific Test File
```bash
./vendor/bin/phpunit tests/Integration/AuthTest.php
./vendor/bin/phpunit tests/Unit/ValidatorTest.php
```

### Frontend E2E Tests

#### Prerequisites
1. Backend API running on `http://localhost:8080`
2. Frontend dev server will auto-start on `http://localhost:3000`
3. Install Playwright browsers:
```bash
cd web
npx playwright install
```

#### Run All E2E Tests
```bash
cd web
npx playwright test
```

#### Run Tests in UI Mode
```bash
npx playwright test --ui
```

#### Run Tests in Specific Browser
```bash
npx playwright test --project=chromium
npx playwright test --project=firefox
npx playwright test --project=webkit
```

#### Run Specific Test File
```bash
npx playwright test tests/e2e/auth.spec.ts
npx playwright test tests/e2e/students.spec.ts
npx playwright test tests/e2e/attendance.spec.ts
```

#### View Test Report
```bash
npx playwright show-report
```

## Test Coverage

### Backend API Coverage
- ✅ Authentication (login, token validation)
- ✅ User management (ADMIN only)
- ✅ Student CRUD operations
- ✅ Pastor management
- ✅ Service scheduling
- ✅ Attendance marking and tracking
- ✅ Reports generation
- ✅ CSV/Excel file handling
- ✅ Input validation
- ✅ JWT token handling

### Frontend Coverage
- ✅ Authentication flow
- ✅ Student management UI
- ✅ Attendance marking flow
- ✅ Search and filtering
- ✅ Form validation
- ✅ CRUD operations
- ✅ Pagination
- ✅ Error handling

## Continuous Integration

### GitHub Actions (Recommended)
```yaml
# .github/workflows/test.yml
name: Test Suite

on: [push, pull_request]

jobs:
  backend-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup PHP
        uses: shivammathur/setup-php@v2
        with:
          php-version: '8.2'
      - name: Install dependencies
        run: cd api && composer install
      - name: Run tests
        run: cd api && composer test

  frontend-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Node
        uses: actions/setup-node@v3
        with:
          node-version: '18'
      - name: Install dependencies
        run: cd web && npm ci
      - name: Install Playwright
        run: cd web && npx playwright install --with-deps
      - name: Run tests
        run: cd web && npx playwright test
```

## Test Data Management

### Backend
- Tests create their own test data with unique identifiers (timestamps)
- No test data cleanup required - each test is isolated
- Uses actual database for integration tests

### Frontend
- Tests use existing seeded data
- Creates temporary test data that can be cleaned up manually
- No fixtures required - tests are self-contained

## Best Practices

1. **Isolation**: Each test is independent and doesn't rely on others
2. **Cleanup**: Backend tests create unique data; frontend tests can reuse seeded data
3. **Assertions**: Clear, specific assertions for each test case
4. **Error Handling**: Tests verify both success and error scenarios
5. **Authentication**: Tests properly handle authentication tokens
6. **Real Environment**: Tests run against actual API and database

## Troubleshooting

### Backend Tests Failing
1. Ensure API server is running: `cd api && php -S localhost:8080 -t public`
2. Check database is accessible on port 4306
3. Verify admin user exists with correct credentials
4. Check PHP version is 8.2+

### Frontend Tests Failing
1. Ensure backend API is running
2. Check if frontend can connect to API
3. Verify Playwright browsers are installed
4. Check CORS settings allow localhost:3000

### Common Issues
- **Connection Refused**: API server not running
- **401 Unauthorized**: Token expired or invalid credentials
- **404 Not Found**: Route misconfiguration
- **Timeout**: Server response too slow, increase timeout in tests

## Next Steps

1. Add more edge case tests
2. Implement performance tests
3. Add security penetration tests
4. Create load testing suite
5. Add visual regression tests
6. Implement API contract tests
