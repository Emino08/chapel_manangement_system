#!/bin/bash

# Chapel Management System - System Verification Script
# Comprehensive verification of all system components

set -e

echo "=========================================="
echo "Chapel Management System Verification"
echo "=========================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

ERRORS=0

# Function to check status
check_status() {
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ $1${NC}"
    else
        echo -e "${RED}✗ $1${NC}"
        ((ERRORS++))
    fi
}

# 1. Check Database Connection
echo -e "${BLUE}[1/10] Checking Database Connection...${NC}"
if php -r "
require 'api/vendor/autoload.php';
\$dotenv = Dotenv\Dotenv::createImmutable(__DIR__ . '/api');
\$dotenv->load();
try {
    \$pdo = new PDO(
        'mysql:host=' . \$_ENV['DB_HOST'] . ';port=' . \$_ENV['DB_PORT'] . ';dbname=' . \$_ENV['DB_NAME'],
        \$_ENV['DB_USER'],
        \$_ENV['DB_PASSWORD']
    );
    echo 'Connected';
    exit(0);
} catch (Exception \$e) {
    exit(1);
}
" > /dev/null 2>&1; then
    check_status "Database connection successful"
else
    check_status "Database connection failed"
fi

echo ""

# 2. Verify Database Tables
echo -e "${BLUE}[2/10] Verifying Database Tables...${NC}"
REQUIRED_TABLES=("users" "students" "pastors" "services" "semesters" "attendance")
for table in "${REQUIRED_TABLES[@]}"; do
    if php -r "
    require 'api/vendor/autoload.php';
    \$dotenv = Dotenv\Dotenv::createImmutable(__DIR__ . '/api');
    \$dotenv->load();
    \$pdo = new PDO(
        'mysql:host=' . \$_ENV['DB_HOST'] . ';port=' . \$_ENV['DB_PORT'] . ';dbname=' . \$_ENV['DB_NAME'],
        \$_ENV['DB_USER'],
        \$_ENV['DB_PASSWORD']
    );
    \$stmt = \$pdo->query(\"SHOW TABLES LIKE '$table'\");
    exit(\$stmt->rowCount() > 0 ? 0 : 1);
    " > /dev/null 2>&1; then
        echo -e "${GREEN}  ✓ Table '$table' exists${NC}"
    else
        echo -e "${RED}  ✗ Table '$table' missing${NC}"
        ((ERRORS++))
    fi
done

echo ""

# 3. Verify Admin User
echo -e "${BLUE}[3/10] Verifying Admin User...${NC}"
if php -r "
require 'api/vendor/autoload.php';
\$dotenv = Dotenv\Dotenv::createImmutable(__DIR__ . '/api');
\$dotenv->load();
\$pdo = new PDO(
    'mysql:host=' . \$_ENV['DB_HOST'] . ';port=' . \$_ENV['DB_PORT'] . ';dbname=' . \$_ENV['DB_NAME'],
    \$_ENV['DB_USER'],
    \$_ENV['DB_PASSWORD']
);
\$stmt = \$pdo->prepare(\"SELECT * FROM users WHERE email = 'admin@chapel.local' AND role = 'ADMIN'\");
\$stmt->execute();
exit(\$stmt->rowCount() > 0 ? 0 : 1);
" > /dev/null 2>&1; then
    check_status "Admin user exists (admin@chapel.local)"
else
    check_status "Admin user not found"
fi

echo ""

# 4. Check API Server
echo -e "${BLUE}[4/10] Checking API Server...${NC}"
if curl -s http://localhost:8080/api/v1/health > /dev/null 2>&1; then
    check_status "API server is running"
else
    echo -e "${YELLOW}⚠ API server not running, attempting to start...${NC}"
    cd api && php -S localhost:8080 -t public > /dev/null 2>&1 &
    API_PID=$!
    sleep 2
    if curl -s http://localhost:8080/api/v1/health > /dev/null 2>&1; then
        check_status "API server started successfully"
    else
        check_status "Failed to start API server"
    fi
    cd ..
fi

echo ""

# 5. Test Authentication
echo -e "${BLUE}[5/10] Testing Authentication...${NC}"
LOGIN_RESPONSE=$(curl -s -X POST http://localhost:8080/api/v1/auth/login \
    -H "Content-Type: application/json" \
    -d '{"email":"admin@chapel.local","password":"Admin#12345"}')

if echo "$LOGIN_RESPONSE" | grep -q '"success":true'; then
    check_status "Authentication works"
    TOKEN=$(echo "$LOGIN_RESPONSE" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
else
    check_status "Authentication failed"
    TOKEN=""
fi

echo ""

# 6. Test API Endpoints
echo -e "${BLUE}[6/10] Testing API Endpoints...${NC}"
if [ -n "$TOKEN" ]; then
    # Test Students endpoint
    if curl -s -H "Authorization: Bearer $TOKEN" http://localhost:8080/api/v1/students | grep -q '"success":true'; then
        echo -e "${GREEN}  ✓ Students endpoint working${NC}"
    else
        echo -e "${RED}  ✗ Students endpoint failed${NC}"
        ((ERRORS++))
    fi

    # Test Services endpoint
    if curl -s -H "Authorization: Bearer $TOKEN" http://localhost:8080/api/v1/services | grep -q '"success":true'; then
        echo -e "${GREEN}  ✓ Services endpoint working${NC}"
    else
        echo -e "${RED}  ✗ Services endpoint failed${NC}"
        ((ERRORS++))
    fi

    # Test Semesters endpoint
    if curl -s -H "Authorization: Bearer $TOKEN" http://localhost:8080/api/v1/semesters | grep -q '"success":true'; then
        echo -e "${GREEN}  ✓ Semesters endpoint working${NC}"
    else
        echo -e "${RED}  ✗ Semesters endpoint failed${NC}"
        ((ERRORS++))
    fi
else
    echo -e "${YELLOW}  ⚠ Skipping endpoint tests (no token)${NC}"
fi

echo ""

# 7. Check Frontend
echo -e "${BLUE}[7/10] Checking Frontend Setup...${NC}"
if [ -d "web/node_modules" ]; then
    check_status "Frontend dependencies installed"
else
    echo -e "${YELLOW}  ⚠ Frontend dependencies not installed${NC}"
    echo -e "${YELLOW}  Run: cd web && npm install${NC}"
    ((ERRORS++))
fi

if [ -f "web/dist/index.html" ] || curl -s http://localhost:3000 > /dev/null 2>&1; then
    check_status "Frontend accessible"
else
    echo -e "${YELLOW}  ⚠ Frontend not running${NC}"
    echo -e "${YELLOW}  Run: cd web && npm run dev${NC}"
fi

echo ""

# 8. Check Required Files
echo -e "${BLUE}[8/10] Verifying Required Files...${NC}"
REQUIRED_FILES=(
    "api/.env"
    "api/composer.json"
    "api/public/index.php"
    "database/schema.sql"
    "web/package.json"
    "web/index.html"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}  ✓ $file exists${NC}"
    else
        echo -e "${RED}  ✗ $file missing${NC}"
        ((ERRORS++))
    fi
done

echo ""

# 9. Check Test Files
echo -e "${BLUE}[9/10] Verifying Test Files...${NC}"
TEST_FILES=(
    "api/tests/Integration/AuthTest.php"
    "api/tests/Integration/StudentTest.php"
    "api/tests/Integration/AttendanceTest.php"
    "api/tests/Unit/ValidatorTest.php"
    "api/tests/Unit/JwtHelperTest.php"
    "web/tests/e2e/auth.spec.ts"
    "web/tests/e2e/students.spec.ts"
    "web/tests/e2e/attendance.spec.ts"
)

for file in "${TEST_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}  ✓ $file exists${NC}"
    else
        echo -e "${RED}  ✗ $file missing${NC}"
        ((ERRORS++))
    fi
done

echo ""

# 10. System Summary
echo -e "${BLUE}[10/10] System Summary${NC}"
echo ""
echo "Components Status:"
echo "  Database: $([ $ERRORS -eq 0 ] && echo -e "${GREEN}✓ Connected${NC}" || echo -e "${YELLOW}⚠ Check errors${NC}")"
echo "  API: $(curl -s http://localhost:8080/api/v1/health > /dev/null 2>&1 && echo -e "${GREEN}✓ Running${NC}" || echo -e "${RED}✗ Not Running${NC}")"
echo "  Frontend: $([ -d "web/node_modules" ] && echo -e "${GREEN}✓ Ready${NC}" || echo -e "${YELLOW}⚠ Setup Required${NC}")"
echo "  Tests: $([ -f "api/tests/Integration/AuthTest.php" ] && echo -e "${GREEN}✓ Available${NC}" || echo -e "${RED}✗ Missing${NC}")"

echo ""
echo "=========================================="
if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✓ System Verification Complete - All Checks Passed!${NC}"
    echo ""
    echo "Next Steps:"
    echo "  1. Run tests: ./run-tests.sh"
    echo "  2. Start frontend: cd web && npm run dev"
    echo "  3. Access at: http://localhost:3000"
else
    echo -e "${YELLOW}⚠ System Verification Complete - $ERRORS Issues Found${NC}"
    echo ""
    echo "Please review the errors above and fix them."
fi
echo "=========================================="

exit $ERRORS
