#!/bin/bash

# Chapel Management System - Test Runner Script
# This script runs all tests for both backend and frontend

set -e  # Exit on error

echo "=========================================="
echo "Chapel Management System - Test Suite"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if API server is running
echo -e "${YELLOW}[1/5] Checking API Server...${NC}"
if curl -s http://localhost:8080/api/v1/health > /dev/null; then
    echo -e "${GREEN}✓ API Server is running${NC}"
else
    echo -e "${RED}✗ API Server is not running on http://localhost:8080${NC}"
    echo -e "${YELLOW}Please start the API server: cd api && php -S localhost:8080 -t public${NC}"
    exit 1
fi

echo ""

# Run Backend Unit Tests
echo -e "${YELLOW}[2/5] Running Backend Unit Tests...${NC}"
cd api
if ./vendor/bin/phpunit --testsuite "Unit Tests" --colors=always; then
    echo -e "${GREEN}✓ Unit Tests Passed${NC}"
else
    echo -e "${RED}✗ Unit Tests Failed${NC}"
    exit 1
fi

echo ""

# Run Backend Integration Tests
echo -e "${YELLOW}[3/5] Running Backend Integration Tests...${NC}"
if ./vendor/bin/phpunit --testsuite "Integration Tests" --colors=always; then
    echo -e "${GREEN}✓ Integration Tests Passed${NC}"
else
    echo -e "${RED}✗ Integration Tests Failed${NC}"
    exit 1
fi

cd ..

echo ""

# Install Playwright if needed
echo -e "${YELLOW}[4/5] Checking Playwright Installation...${NC}"
cd web
if [ ! -d "node_modules/@playwright/test" ]; then
    echo "Installing Playwright..."
    npm install --save-dev @playwright/test
    npx playwright install
fi

echo ""

# Run Frontend E2E Tests
echo -e "${YELLOW}[5/5] Running Frontend E2E Tests...${NC}"
if npx playwright test; then
    echo -e "${GREEN}✓ E2E Tests Passed${NC}"
else
    echo -e "${RED}✗ E2E Tests Failed${NC}"
    echo -e "${YELLOW}View detailed report: npx playwright show-report${NC}"
    exit 1
fi

cd ..

echo ""
echo "=========================================="
echo -e "${GREEN}✓ All Tests Passed Successfully!${NC}"
echo "=========================================="
echo ""
echo "Test Summary:"
echo "  ✓ Backend Unit Tests"
echo "  ✓ Backend Integration Tests"
echo "  ✓ Frontend E2E Tests"
echo ""
echo "View Playwright report: cd web && npx playwright show-report"
