# How to Run Tests - Chapel Management System

## 🚀 Quick Start (Easiest Method)

### Step 1: Ensure Prerequisites
Make sure these are running:
- ✅ MySQL database on port **4306**
- ✅ API server on **http://localhost:8080**
- ✅ Admin user exists: `admin@chapel.local` / `Admin#12345`

### Step 2: Start API Server (if not running)
```bash
cd api
php -S localhost:8080 -t public
```

### Step 3: Run All Tests

**Windows:**
```bash
run-tests.bat
```

**Linux/Mac:**
```bash
chmod +x run-tests.sh
./run-tests.sh
```

This will automatically:
1. ✅ Check API server status
2. ✅ Run backend unit tests (15 tests)
3. ✅ Run backend integration tests (20 tests)
4. ✅ Install Playwright if needed
5. ✅ Run frontend E2E tests (25 tests)
6. ✅ Show summary report

---

## 📋 Individual Test Commands

### Backend Tests (PHP/PHPUnit)

#### All Backend Tests
```bash
cd api
composer test
```

#### Unit Tests Only (Validators, JWT)
```bash
cd api
./vendor/bin/phpunit --testsuite "Unit Tests"
```

#### Integration Tests Only (API Endpoints)
```bash
cd api
./vendor/bin/phpunit --testsuite "Integration Tests"
```

#### Specific Test File
```bash
cd api
./vendor/bin/phpunit tests/Integration/AuthTest.php
./vendor/bin/phpunit tests/Integration/StudentTest.php
./vendor/bin/phpunit tests/Unit/ValidatorTest.php
```

#### With Detailed Output
```bash
cd api
./vendor/bin/phpunit --testdox
```

---

### Frontend Tests (Playwright/E2E)

#### Install Playwright (First Time Only)
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

#### Interactive UI Mode (Recommended)
```bash
cd web
npm run test:ui
# or
npx playwright test --ui
```

#### Specific Test File
```bash
cd web
npx playwright test tests/e2e/auth.spec.ts
npx playwright test tests/e2e/students.spec.ts
npx playwright test tests/e2e/attendance.spec.ts
```

#### Specific Browser
```bash
cd web
npx playwright test --project=chromium
npx playwright test --project=firefox
npx playwright test --project=webkit
```

#### Debug Mode
```bash
cd web
npx playwright test --debug
```

#### View Test Report
```bash
cd web
npm run test:report
# or
npx playwright show-report
```

---

## 🔍 Verify System Health

Before running tests, verify everything is set up correctly:

**Linux/Mac:**
```bash
chmod +x verify-system.sh
./verify-system.sh
```

This checks:
- ✅ Database connection
- ✅ Database tables exist
- ✅ Admin user exists
- ✅ API server running
- ✅ API endpoints working
- ✅ Frontend dependencies
- ✅ Test files exist

---

## 📊 Expected Output

### Successful Test Run
```
==========================================
Chapel Management System - Test Suite
==========================================

[1/5] Checking API Server...
✓ API Server is running

[2/5] Running Backend Unit Tests...
PHPUnit 10.5.x
.......... (15 tests)
Time: 00:00.123, Memory: 10.00 MB
OK (15 tests, 45 assertions)
✓ Unit Tests Passed

[3/5] Running Backend Integration Tests...
PHPUnit 10.5.x
.................... (20 tests)
Time: 00:02.456, Memory: 12.00 MB
OK (20 tests, 80 assertions)
✓ Integration Tests Passed

[4/5] Checking Playwright Installation...
✓ Playwright is installed

[5/5] Running Frontend E2E Tests...
Running 25 tests using 3 workers

  ✓ [chromium] › auth.spec.ts:5:3 › should display login page
  ✓ [chromium] › auth.spec.ts:10:3 › should login successfully
  ✓ [chromium] › students.spec.ts:8:3 › should list students
  ... (25 tests total)

  25 passed (45s)
✓ E2E Tests Passed

==========================================
✓ All Tests Passed Successfully!
==========================================

Test Summary:
  ✓ Backend Unit Tests (15 passed)
  ✓ Backend Integration Tests (20 passed)
  ✓ Frontend E2E Tests (25 passed)

Total: 60 tests passed
```

---

## ❌ Troubleshooting

### Issue: "API Server not running"
**Solution:**
```bash
cd api
php -S localhost:8080 -t public
```

### Issue: "Database connection failed"
**Solution:**
```bash
# Check MySQL is running
mysql -h localhost -P 4306 -u root -p

# Load schema
cd api
php bin/load-schema.php
```

### Issue: "Admin user not found"
**Solution:**
```bash
cd api
php bin/load-schema.php  # This creates admin user
```

### Issue: "Playwright not installed"
**Solution:**
```bash
cd web
npm install --save-dev @playwright/test
npx playwright install
```

### Issue: "Tests timing out"
**Solution:**
- Ensure API server is responding: `curl http://localhost:8080/api/v1/health`
- Check database is accessible
- Increase timeout in test config

### Issue: "Authentication tests failing"
**Solution:**
- Verify admin credentials: `admin@chapel.local` / `Admin#12345`
- Check JWT_SECRET in `.env` file
- Ensure database users table exists

---

## 📁 Test Files Location

### Backend
```
api/tests/
├── Integration/
│   ├── AuthTest.php           (6 tests)
│   ├── StudentTest.php        (9 tests)
│   └── AttendanceTest.php     (6 tests)
└── Unit/
    ├── ValidatorTest.php      (10 tests)
    └── JwtHelperTest.php      (5 tests)
```

### Frontend
```
web/tests/
└── e2e/
    ├── auth.spec.ts           (5 tests)
    ├── students.spec.ts       (7 tests)
    └── attendance.spec.ts     (7 tests)
```

---

## 📚 Additional Documentation

- **TEST_OVERVIEW.md** - Complete overview and quick start
- **TEST_SUMMARY.md** - Test statistics and coverage
- **TEST_SUITE.md** - Detailed technical documentation
- **TESTING_GUIDE.md** - Comprehensive guide with examples
- **api/tests/README.md** - Backend tests guide
- **web/tests/README.md** - Frontend tests guide

---

## ✅ Success Checklist

Before deployment, ensure:
- [ ] All backend unit tests pass
- [ ] All backend integration tests pass
- [ ] All frontend E2E tests pass
- [ ] No errors in test output
- [ ] API server responds correctly
- [ ] Database is accessible
- [ ] Admin user can login

---

## 🎯 Quick Commands Reference

```bash
# Run everything
./run-tests.sh              # Linux/Mac
run-tests.bat               # Windows

# Verify system
./verify-system.sh          # Linux/Mac

# Backend tests
cd api && composer test

# Frontend tests
cd web && npm test

# Frontend UI mode
cd web && npm run test:ui

# View report
cd web && npm run test:report
```

---

**Last Updated**: 2025-10-02
**Test Coverage**: 60+ tests
**Status**: ✅ All Systems Ready
