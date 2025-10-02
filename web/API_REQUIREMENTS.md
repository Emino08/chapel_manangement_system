# API Requirements for Frontend Integration

## Base URL
```
http://localhost:8080/api/v1
```

## Authentication Endpoints

### POST /auth/login
**Request:**
```json
{
  "username": "string",
  "password": "string"
}
```

**Response:**
```json
{
  "token": "jwt_token_here",
  "user": {
    "id": 1,
    "username": "admin",
    "email": "admin@example.com",
    "role": "ADMIN",
    "createdAt": "2025-01-01T00:00:00Z",
    "updatedAt": "2025-01-01T00:00:00Z"
  }
}
```

---

## Student Endpoints

### GET /students
**Query Parameters:**
- `page` (number) - Page number (default: 1)
- `limit` (number) - Items per page (default: 10)
- `search` (string) - Search by name or student ID
- `program` (string) - Filter by program

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "firstName": "John",
      "lastName": "Doe",
      "studentId": "CS2024001",
      "email": "john@example.com",
      "phoneNumber": "+1234567890",
      "yearLevel": 3,
      "program": "Computer Science",
      "isActive": true,
      "createdAt": "2025-01-01T00:00:00Z",
      "updatedAt": "2025-01-01T00:00:00Z"
    }
  ],
  "total": 100,
  "page": 1,
  "limit": 10,
  "totalPages": 10
}
```

### POST /students
**Request:**
```json
{
  "firstName": "John",
  "lastName": "Doe",
  "studentId": "CS2024001",
  "email": "john@example.com",
  "phoneNumber": "+1234567890",
  "yearLevel": 3,
  "program": "Computer Science",
  "isActive": true
}
```

### PUT /students/:id
**Request:** Same as POST

### DELETE /students/:id
**Response:** 204 No Content

### POST /students/import
**Request:** FormData with CSV file
**Content-Type:** multipart/form-data

---

## Pastor Endpoints

### GET /pastors
**Query Parameters:**
- `page` (number)
- `limit` (number)
- `search` (string)

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "firstName": "Michael",
      "lastName": "Smith",
      "email": "pastor@example.com",
      "phoneNumber": "+1234567890",
      "isActive": true,
      "createdAt": "2025-01-01T00:00:00Z",
      "updatedAt": "2025-01-01T00:00:00Z"
    }
  ],
  "total": 10,
  "page": 1,
  "limit": 10,
  "totalPages": 1
}
```

### POST /pastors
**Request:**
```json
{
  "firstName": "Michael",
  "lastName": "Smith",
  "email": "pastor@example.com",
  "phoneNumber": "+1234567890",
  "isActive": true
}
```

### PUT /pastors/:id
**Request:** Same as POST

### DELETE /pastors/:id
**Response:** 204 No Content

### POST /pastors/import
**Request:** FormData with CSV file

---

## Semester Endpoints

### GET /semesters
**Query Parameters:**
- `limit` (number)

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "name": "Fall 2025",
      "startDate": "2025-09-01",
      "endDate": "2025-12-15",
      "isActive": true,
      "createdAt": "2025-01-01T00:00:00Z",
      "updatedAt": "2025-01-01T00:00:00Z"
    }
  ],
  "total": 5,
  "page": 1,
  "limit": 100,
  "totalPages": 1
}
```

---

## Service Endpoints

### GET /services
**Query Parameters:**
- `limit` (number)
- `sort` (string) - Sort field (e.g., "serviceDate")
- `order` (string) - "asc" or "desc"

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "title": "Wednesday Chapel Service",
      "description": "Weekly chapel service",
      "serviceDate": "2025-01-15",
      "serviceTime": "09:00-12:00",
      "location": "Main Chapel",
      "pastorId": 1,
      "semesterId": 1,
      "requiredAttendance": true,
      "createdAt": "2025-01-01T00:00:00Z",
      "updatedAt": "2025-01-01T00:00:00Z",
      "pastor": {
        "id": 1,
        "firstName": "Michael",
        "lastName": "Smith",
        "email": "pastor@example.com",
        "phoneNumber": "+1234567890",
        "isActive": true,
        "createdAt": "2025-01-01T00:00:00Z",
        "updatedAt": "2025-01-01T00:00:00Z"
      },
      "semester": {
        "id": 1,
        "name": "Fall 2025",
        "startDate": "2025-09-01",
        "endDate": "2025-12-15",
        "isActive": true,
        "createdAt": "2025-01-01T00:00:00Z",
        "updatedAt": "2025-01-01T00:00:00Z"
      }
    }
  ],
  "total": 20,
  "page": 1,
  "limit": 100,
  "totalPages": 1
}
```

### POST /services
**Request:**
```json
{
  "title": "Wednesday Chapel Service",
  "description": "Weekly chapel service",
  "serviceDate": "2025-01-15",
  "serviceTime": "09:00-12:00",
  "location": "Main Chapel",
  "pastorId": 1,
  "semesterId": 1,
  "requiredAttendance": true
}
```

### PUT /services/:id
**Request:** Same as POST

### DELETE /services/:id
**Response:** 204 No Content

---

## Attendance Endpoints

### GET /attendance
**Query Parameters:**
- `serviceId` (number) - Required

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "studentId": 1,
      "serviceId": 1,
      "status": "PRESENT",
      "checkInTime": "2025-01-15T09:05:00Z",
      "notes": "",
      "createdAt": "2025-01-15T09:05:00Z",
      "updatedAt": "2025-01-15T09:05:00Z",
      "student": {
        "id": 1,
        "firstName": "John",
        "lastName": "Doe",
        "studentId": "CS2024001",
        "email": "john@example.com",
        "phoneNumber": "+1234567890",
        "yearLevel": 3,
        "program": "Computer Science",
        "isActive": true,
        "createdAt": "2025-01-01T00:00:00Z",
        "updatedAt": "2025-01-01T00:00:00Z"
      }
    }
  ]
}
```

### POST /attendance
**Request:**
```json
{
  "studentId": 1,
  "serviceId": 1,
  "status": "PRESENT",
  "checkInTime": "2025-01-15T09:05:00Z",
  "notes": ""
}
```

**Status Values:** "PRESENT", "ABSENT", "EXCUSED", "LATE"

### PUT /attendance/:id
**Request:**
```json
{
  "status": "ABSENT"
}
```

---

## Reports Endpoints

### GET /reports/attendance
**Query Parameters:**
- `semesterId` (number) - Required
- `threshold` (number) - Attendance percentage threshold (e.g., 75)
- `program` (string) - Filter by program

**Response:**
```json
[
  {
    "studentId": 1,
    "studentNo": "CS2024001",
    "firstName": "John",
    "lastName": "Doe",
    "program": "Computer Science",
    "timesAttended": 8,
    "totalServices": 10,
    "attendanceRate": 80.0,
    "eligible": true
  }
]
```

### POST /reports/upload
**Request:** FormData with Excel file
**Content-Type:** multipart/form-data

---

## User Management Endpoints (Admin Only)

### GET /users
**Response:**
```json
[
  {
    "id": 1,
    "username": "admin",
    "email": "admin@example.com",
    "role": "ADMIN",
    "createdAt": "2025-01-01T00:00:00Z",
    "updatedAt": "2025-01-01T00:00:00Z"
  }
]
```

### POST /users
**Request:**
```json
{
  "username": "newuser",
  "email": "user@example.com",
  "password": "securepassword",
  "role": "STAFF"
}
```

**Roles:** "STAFF", "ADMIN", "SUPER_ADMIN"

### PUT /users/:id
**Request:**
```json
{
  "username": "newuser",
  "email": "user@example.com",
  "role": "STAFF"
}
```

### DELETE /users/:id
**Response:** 204 No Content

### POST /users/:id/reset-password
**Request:**
```json
{
  "password": "newpassword"
}
```

---

## Error Responses

### 400 Bad Request
```json
{
  "message": "Validation error",
  "errors": [
    "Field 'email' must be a valid email address"
  ]
}
```

### 401 Unauthorized
```json
{
  "message": "Invalid credentials"
}
```

### 403 Forbidden
```json
{
  "message": "Insufficient permissions"
}
```

### 404 Not Found
```json
{
  "message": "Resource not found"
}
```

### 500 Internal Server Error
```json
{
  "message": "Internal server error"
}
```

---

## Authentication Headers

All authenticated requests must include:
```
Authorization: Bearer {jwt_token}
```

The frontend automatically adds this header via the Axios interceptor configured in `web/src/lib/api.ts`.

---

## CORS Configuration

The backend must allow requests from the frontend origin:
```
Access-Control-Allow-Origin: http://localhost:5173
Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
Access-Control-Allow-Headers: Content-Type, Authorization
Access-Control-Allow-Credentials: true
```

---

## Notes for Backend Implementation

1. **Pagination:** All list endpoints should support pagination with `page`, `limit`, `total`, and `totalPages`
2. **Search:** Implement fuzzy search for student/pastor names and IDs
3. **Filtering:** Support query parameter filtering for program, status, etc.
4. **Sorting:** Support sorting by specified fields with order direction
5. **Validation:** Use Zod or similar for request validation
6. **Error Handling:** Return consistent error response format
7. **JWT:** Implement JWT token generation and validation
8. **Role-Based Access:** Enforce role permissions at the API level
9. **File Uploads:** Handle multipart/form-data for CSV/Excel imports
10. **Relations:** Include related entities (pastor, semester) in service responses

---

## Database Schema Considerations

### Students Table
- id (PK)
- firstName
- lastName
- studentId (unique)
- email
- phoneNumber
- yearLevel
- program
- isActive
- createdAt
- updatedAt

### Pastors Table
- id (PK)
- firstName
- lastName
- email
- phoneNumber
- isActive
- createdAt
- updatedAt

### Services Table
- id (PK)
- title
- description
- serviceDate
- serviceTime
- location
- pastorId (FK)
- semesterId (FK)
- requiredAttendance
- createdAt
- updatedAt

### Attendance Table
- id (PK)
- studentId (FK)
- serviceId (FK)
- status (ENUM)
- checkInTime
- notes
- createdAt
- updatedAt

### Semesters Table
- id (PK)
- name
- startDate
- endDate
- isActive
- createdAt
- updatedAt

### Users Table
- id (PK)
- username (unique)
- email (unique)
- password (hashed)
- role (ENUM)
- createdAt
- updatedAt
