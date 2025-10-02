@echo off
REM Chapel Management System - Test Runner Script (Windows)
REM This script runs all tests for both backend and frontend

echo ==========================================
echo Chapel Management System - Test Suite
echo ==========================================
echo.

REM Check if API server is running
echo [1/5] Checking API Server...
curl -s http://localhost:8080/api/v1/health >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] API Server is running
) else (
    echo [ERROR] API Server is not running on http://localhost:8080
    echo Please start the API server: cd api ^&^& php -S localhost:8080 -t public
    exit /b 1
)

echo.

REM Run Backend Unit Tests
echo [2/5] Running Backend Unit Tests...
cd api
call vendor\bin\phpunit --testsuite "Unit Tests" --colors=always
if %errorlevel% neq 0 (
    echo [ERROR] Unit Tests Failed
    exit /b 1
)
echo [OK] Unit Tests Passed

echo.

REM Run Backend Integration Tests
echo [3/5] Running Backend Integration Tests...
call vendor\bin\phpunit --testsuite "Integration Tests" --colors=always
if %errorlevel% neq 0 (
    echo [ERROR] Integration Tests Failed
    exit /b 1
)
echo [OK] Integration Tests Passed

cd ..

echo.

REM Check Playwright Installation
echo [4/5] Checking Playwright Installation...
cd web
if not exist "node_modules\@playwright\test" (
    echo Installing Playwright...
    call npm install --save-dev @playwright/test
    call npx playwright install
)

echo.

REM Run Frontend E2E Tests
echo [5/5] Running Frontend E2E Tests...
call npx playwright test
if %errorlevel% neq 0 (
    echo [ERROR] E2E Tests Failed
    echo View detailed report: npx playwright show-report
    exit /b 1
)
echo [OK] E2E Tests Passed

cd ..

echo.
echo ==========================================
echo [SUCCESS] All Tests Passed Successfully!
echo ==========================================
echo.
echo Test Summary:
echo   [OK] Backend Unit Tests
echo   [OK] Backend Integration Tests
echo   [OK] Frontend E2E Tests
echo.
echo View Playwright report: cd web ^&^& npx playwright show-report
