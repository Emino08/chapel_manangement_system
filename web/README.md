Build a “Chapel Management System” (Slim + Vite/React + shadcn/ui + MySQL)
Goal

Implement a production-ready Chapel Management System that replaces manual paper attendance—supporting admin, HR, and Student Union roles, bulk CSV imports, weekly service attendance (Wednesdays 9:00–12:00 AM), searchable check-ins, and per-semester attendance reports. Use Slim for the backend API, Vite + React + shadcn/ui for the frontend, and MySQL (listening on port 4306). Provide a single SQL file for DB setup—no terminal SQL commands.

Tech Stack & Conventions

Backend: PHP 8.2+, Slim Framework (latest), PHP-DI, nyholm/psr7, respect/validation, vlucas/phpdotenv, league/csv, phpoffice/phpspreadsheet for Excel, firebase/php-jwt for JWT auth, ramsey/uuid.

Frontend: Vite + React + TypeScript, shadcn/ui + Tailwind, React Query (TanStack Query), React Router, Zod + React Hook Form.

DB: MySQL on port 4306. Use a single SQL file database/schema.sql to create schema, seed an initial Admin user, and insert sample data.

Project Layout:

/api — Slim app (PSR-4 autoloading via Composer).

/web — Vite React app.

Root README with setup steps.

Auth: JWT Bearer tokens; roles: ADMIN, HR, SUO (Student Union Official). Admin can create sub-accounts.

Time zone: Africa/Freetown.

Environment: .env files for both apps; backend reads DB + JWT secrets from .env.

Core Features

User & Role Management

Admin can create users with roles ADMIN, HR, SUO.

Password reset (email stub or console log is fine).

Audit fields: created_at, updated_at, created_by.

Students Management

Create single student.

Bulk CSV upload (No, Name, Program, Phone Number); validate & upsert by No (student number).

Optional fields: Faculty, Level, StudentID card number.

Searchable list with filters (Program, Faculty) and free-text (name, phone, No).

Pastors Management

Create single pastor.

Bulk CSV upload (No, Name, Program, Phone Number)—use same parser; store relevant fields (No can be internal code).

Services

Model weekly Chapel Service—default every Wednesday 09:00–12:00.

Admin can create a “Service” record per week with date/time and optional theme/pastor.

Attendance

Attendance page lets staff pick the Service first, then search for a student (by No or Phone) with filters (Program, Faculty).

Mark Present or Absent quickly—keyboard friendly.

Prevent duplicate attendance per student per service.

Reports

Show per-semester attendance counts—how many times each student attended.

Upload an Excel file (xlsx) with official semester roster to cross-check current DB (optional) or to import a “semester definition”.

Criteria flag—if a student’s attendance < threshold (configurable), mark NOT ELIGIBLE for exams.

Export results to CSV/XLSX.

Data Model (create in database/schema.sql)

users (id UUID, name, email UNIQUE, role ENUM[ADMIN,HR,SUO], password_hash, created_at, updated_at)

students (id UUID, student_no UNIQUE, name, program, faculty, phone UNIQUE NULL, level NULL, created_at, updated_at)

pastors (id UUID, code UNIQUE, name, program NULL, phone UNIQUE NULL, created_at, updated_at)

services (id UUID, service_date DATE, start_time TIME, end_time TIME, theme NULL, pastor_id NULL FK, UNIQUE(service_date))

attendance (id UUID, service_id FK, student_id FK, status ENUM[PRESENT,ABSENT], marked_by FK users.id, created_at, UNIQUE(service_id, student_id))

semesters (id UUID, name, start_date DATE, end_date DATE, active TINYINT)

Derived views or queries to count per-semester attendance per student.

Seed:

Create one Admin user: email admin@chapel.local, password Admin#12345 (hashed).

Create a sample semester covering current date.

Insert a sample Wednesday service.

Add a few students.

Backend API (Slim)

Base URL: /api/v1

Auth

POST /auth/login → {token, user}.

Middleware: protect all non-auth routes; attach req.user. Role guard for ADMIN endpoints.

Users (ADMIN only)

POST /users (name, email, role, temp password).

GET /users list; PATCH /users/:id; DELETE /users/:id.

Students

POST /students (single).

POST /students:bulk (CSV upload).

GET /students?program=&faculty=&q= (search by name/phone/no).

GET /students/:id — detail; PATCH /students/:id.

Pastors

POST /pastors (single).

POST /pastors:bulk (CSV upload).

GET /pastors?q=.

Semesters

GET /semesters (list + active).

POST /semesters (ADMIN).

PATCH /semesters/:id (toggle active).

Services

GET /services?from=&to=.

POST /services (create weekly service; default next Wednesday 09:00–12:00; allow override; attach optional pastor).

GET /services/:id.

Attendance

POST /attendance/search → accepts {serviceId, program?, faculty?, query?} where query matches student_no or phone. Returns candidates.

POST /attendance/mark → {serviceId, studentId, status}; idempotent (update if exists).

GET /attendance/service/:serviceId → list with filters.

Reports

GET /reports/semester/:semesterId?program=&faculty=&eligibleThreshold= → list with counts & eligibility flag.

POST /reports/upload (Excel) → Parse roster or semester definition; validate and return normalized rows.

GET /reports/export.csv|.xlsx with same filters.

Validation & Errors: Use JSON problem-details style; consistent codes/messages.

Frontend (Vite + shadcn/ui)

Auth views: Login, role-based guard; persist token in HttpOnly cookie if possible (fallback localStorage with CSRF notes).

Layout: Sidebar (Students, Pastors, Services, Attendance, Reports, Users*), topbar with role indicator.

Students: Table with pagination, filters (Program, Faculty), search box; Add/Import CSV modal; row actions.

Pastors: Similar to Students with Import CSV.

Services: Calendar/list; “Create next Wednesday” button pre-filled 09:00–12:00; optional theme/pastor.

Attendance: Step 1 = Select Service (dropdown of upcoming/current week). Step 2 = Filters (Program, Faculty). Step 3 = Search bar for No or Phone. Results show quick action chips Present / Absent—instant optimistic updates.

Reports: Pick Semester → show table with columns: Student No, Name, Program, Faculty, Times Attended, Eligibility (Yes/No). Controls for threshold (default 75% of services in semester). Buttons: Upload Excel, Export CSV/XLSX.

CSV/Excel Handling

CSV format (Students & Pastors): No,Name,Program,Phone Number—accept header or no header; trim, dedupe, validate; upsert by No.

Excel upload (Reports): Accept .xlsx; parse first sheet; map “No” and “Name” at minimum; ignore extra columns; show preview before commit.

Business Rules

A student can be marked Present or Absent for a service—single record per service.

Duplicate scans/selections overwrite status rather than insert duplicates.

A “semester” determines the set of services used for counts; any service with service_date within [start_date, end_date] is in scope.

Eligibility = attendance_count >= ceil(threshold * total_services_in_semester_for_program)—threshold is configurable per report request.

Service default: every Wednesday 09:00–12:00; allow manual creation/edit.

Quality & DX

README with step-by-step setup:

Create .env in /api with DB host/port (4306), user, pass, dbname, JWT_SECRET.

Run php -S localhost:8080 -t public or composer start.

Import DB by running the provided database/schema.sql file (agent should create a small PHP script /api/bin/load-schema.php that opens the SQL file and executes it programmatically—no terminal SQL needed).

In /web, pnpm i && pnpm dev.

Testing: a few PHPUnit tests for validators and attendance logic; Playwright or Cypress smoke test for Attendance flow.

Security: password hashing (password_hash default algo), JWT 1h expiry + refresh, CORS locked to frontend origin, input validation everywhere.

Performance: indexes on students.student_no, students.phone, attendance (service_id, student_id), services.service_date, users.email.

Deliverables

Complete repo with /api, /web, /database/schema.sql, /api/bin/load-schema.php.

Seeded admin: admin@chapel.local / Admin#12345.

Screens polished with shadcn/ui components; mobile friendly; empty-state and error toasts in all tables and flows.

Acceptance Tests (must pass)

Login as Admin → create HR and SUO users.

Upload students.csv with at least 20 rows → appears in Students list with filters working.

Create this Wednesday’s service (auto-filled times).

Attendance page → select service → filter Program, search by student No → mark Present and Absent rapidly; no duplicates.

Upload an Excel roster in Reports → calculate counts for the active semester → export CSV and XLSX.

Eligibility threshold slider changes flags live.

Restart project, DB persists; schema can be re-loaded from database/schema.sql via the PHP loader file—no manual MySQL commands.

If anything is ambiguous, assume sensible defaults—then implement with clean code, strong validation, and thorough README.