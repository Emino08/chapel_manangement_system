# Backend Tests

## Test Structure

```
tests/
├── Integration/          # API endpoint tests
│   ├── AuthTest.php
│   ├── StudentTest.php
│   └── AttendanceTest.php
└── Unit/                # Utility function tests
    ├── ValidatorTest.php
    └── JwtHelperTest.php
```

## Running Tests

### All Tests
```bash
composer test
```

### Unit Tests Only
```bash
./vendor/bin/phpunit --testsuite "Unit Tests"
```

### Integration Tests Only
```bash
./vendor/bin/phpunit --testsuite "Integration Tests"
```

### Specific Test File
```bash
./vendor/bin/phpunit tests/Integration/AuthTest.php
```

## Prerequisites

1. API server running on `http://localhost:8080`
2. Database on port `4306` with schema loaded
3. Admin user: `admin@chapel.local` / `Admin#12345`

## Test Coverage

- ✅ Authentication & JWT
- ✅ Student CRUD operations
- ✅ Attendance management
- ✅ Input validation
- ✅ Token handling

Total: 35+ tests
