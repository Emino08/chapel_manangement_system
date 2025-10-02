# Frontend E2E Tests

## Test Structure

```
tests/
└── e2e/                     # End-to-end tests
    ├── auth.spec.ts         # Login/logout flow
    ├── students.spec.ts     # Student management
    └── attendance.spec.ts   # Attendance marking
```

## Running Tests

### All Tests
```bash
npm test
# or
npx playwright test
```

### With UI Mode
```bash
npm run test:ui
# or
npx playwright test --ui
```

### Specific Test
```bash
npx playwright test tests/e2e/auth.spec.ts
```

### View Report
```bash
npm run test:report
# or
npx playwright show-report
```

## Prerequisites

1. Backend API running on `http://localhost:8080`
2. Playwright browsers installed: `npx playwright install`
3. Frontend dev server (auto-starts with tests)

## Test Coverage

- ✅ Authentication flow
- ✅ Student CRUD operations
- ✅ Attendance marking
- ✅ Search & filtering
- ✅ Form validation
- ✅ Navigation

Total: 25+ tests across 3 browsers (Chromium, Firefox, WebKit)
