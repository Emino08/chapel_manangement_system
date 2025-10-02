import { z } from 'zod'

// User schemas
export const userRoleSchema = z.enum(['ADMIN', 'HR', 'SUO'])

export const userSchema = z.object({
  id: z.string(), // UUID from backend
  name: z.string(),
  email: z.string().email(),
  role: userRoleSchema,
  must_change_password: z.boolean().optional(),
  created_at: z.string().optional(),
  updated_at: z.string().optional(),
})

export const createUserSchema = z.object({
  name: z.string().min(3, 'Name must be at least 3 characters'),
  email: z.string().email('Invalid email address'),
  password: z.string().min(8, 'Password must be at least 8 characters'),
  role: userRoleSchema,
})

export const loginSchema = z.object({
  username: z.string().min(1, 'Username is required'),
  password: z.string().min(1, 'Password is required'),
})

// Student schemas
export const studentSchema = z.object({
  id: z.string(), // UUID from backend
  firstName: z.string(),
  lastName: z.string(),
  studentId: z.string(),
  email: z.string().email().nullable(),
  phoneNumber: z.string().nullable(),
  yearLevel: z.number(),
  program: z.string(),
  isActive: z.boolean(),
  createdAt: z.string().datetime(),
  updatedAt: z.string().datetime(),
})

export const createStudentSchema = z.object({
  firstName: z.string().min(1, 'First name is required'),
  lastName: z.string().min(1, 'Last name is required'),
  studentId: z.string().min(1, 'Student ID is required'),
  email: z.string().email('Invalid email address').optional().or(z.literal('')),
  phoneNumber: z.string().optional().or(z.literal('')),
  yearLevel: z.number().min(1).max(6),
  program: z.string().min(1, 'Program is required'),
  isActive: z.boolean().default(true),
})

// Pastor schemas
export const pastorSchema = z.object({
  id: z.string(), // UUID from backend
  firstName: z.string(),
  lastName: z.string(),
  phoneNumber: z.string().nullable(),
  isActive: z.boolean(),
  createdAt: z.string().datetime(),
  updatedAt: z.string().datetime(),
})

export const createPastorSchema = z.object({
  firstName: z.string().min(1, 'First name is required'),
  lastName: z.string().min(1, 'Last name is required'),
  phoneNumber: z.string().optional().or(z.literal('')),
  isActive: z.boolean().default(true),
})

// Semester schemas
export const semesterSchema = z.object({
  id: z.string(), // UUID from backend
  name: z.string(),
  startDate: z.string(),
  endDate: z.string(),
  isActive: z.boolean(),
  createdAt: z.string().datetime(),
  updatedAt: z.string().datetime(),
})

export const createSemesterSchema = z.object({
  name: z.string().min(1, 'Semester name is required'),
  startDate: z.string().min(1, 'Start date is required'),
  endDate: z.string().min(1, 'End date is required'),
  isActive: z.boolean().default(true),
})

// Service schemas
export const serviceSchema = z.object({
  id: z.string(), // UUID from backend
  title: z.string(),
  description: z.string().nullable(),
  serviceDate: z.string(),
  serviceTime: z.string(),
  location: z.string().nullable(),
  pastorId: z.string().nullable(), // UUID from backend
  semesterId: z.string(), // UUID from backend
  requiredAttendance: z.boolean(),
  createdAt: z.string().datetime(),
  updatedAt: z.string().datetime(),
  pastor: pastorSchema.nullable().optional(),
  semester: semesterSchema.nullable().optional(),
})

export const createServiceSchema = z.object({
  title: z.string().min(1, 'Service title is required'),
  description: z.string().optional().or(z.literal('')),
  serviceDate: z.string().min(1, 'Service date is required'),
  serviceTime: z.string().min(1, 'Service time is required'),
  location: z.string().optional().or(z.literal('')),
  pastorId: z.string().nullable().optional(), // UUID from backend
  semesterId: z.string().min(1, 'Semester is required'), // UUID from backend
  requiredAttendance: z.boolean().default(true),
})

// Attendance schemas
export const attendanceStatusSchema = z.enum(['PRESENT', 'ABSENT'])

export const attendanceSchema = z.object({
  id: z.string(), // UUID from backend
  studentId: z.string(), // UUID from backend
  serviceId: z.string(), // UUID from backend
  status: attendanceStatusSchema,
  checkInTime: z.string().datetime().nullable(),
  notes: z.string().nullable(),
  createdAt: z.string().datetime(),
  updatedAt: z.string().datetime(),
  student: studentSchema.optional(),
  service: serviceSchema.optional(),
})

export const createAttendanceSchema = z.object({
  studentId: z.string().min(1, 'Student is required'), // UUID from backend
  serviceId: z.string().min(1, 'Service is required'), // UUID from backend
  status: attendanceStatusSchema.default('PRESENT'),
  checkInTime: z.string().datetime().optional(),
  notes: z.string().optional().or(z.literal('')),
})

export const bulkAttendanceSchema = z.object({
  serviceId: z.string().min(1, 'Service is required'), // UUID from backend
  attendances: z.array(
    z.object({
      studentId: z.string(), // UUID from backend
      status: attendanceStatusSchema,
    })
  ),
})

// Response schemas
export const paginatedResponseSchema = <T extends z.ZodTypeAny>(dataSchema: T) =>
  z.object({
    data: z.array(dataSchema),
    total: z.number(),
    page: z.number(),
    limit: z.number(),
    totalPages: z.number(),
  })

export const apiErrorSchema = z.object({
  message: z.string(),
  errors: z.array(z.string()).optional(),
})

// Type exports
export type User = z.infer<typeof userSchema>
export type CreateUser = z.infer<typeof createUserSchema>
export type LoginCredentials = z.infer<typeof loginSchema>
export type UserRole = z.infer<typeof userRoleSchema>

export type Student = z.infer<typeof studentSchema>
export type CreateStudent = z.infer<typeof createStudentSchema>

export type Pastor = z.infer<typeof pastorSchema>
export type CreatePastor = z.infer<typeof createPastorSchema>

export type Semester = z.infer<typeof semesterSchema>
export type CreateSemester = z.infer<typeof createSemesterSchema>

export type Service = z.infer<typeof serviceSchema>
export type CreateService = z.infer<typeof createServiceSchema>

export type Attendance = z.infer<typeof attendanceSchema>
export type CreateAttendance = z.infer<typeof createAttendanceSchema>
export type BulkAttendance = z.infer<typeof bulkAttendanceSchema>
export type AttendanceStatus = z.infer<typeof attendanceStatusSchema>

export type ApiError = z.infer<typeof apiErrorSchema>

// Lecturer schemas
export const lecturerSchema = z.object({
  id: z.string(), // UUID from backend
  firstName: z.string(),
  lastName: z.string(),
  lecturerNo: z.string(),
  department: z.string(),
  faculty: z.string().nullable(),
  phoneNumber: z.string().nullable(),
  email: z.string().email().nullable(),
  position: z.string().nullable(),
  createdAt: z.string().datetime(),
  updatedAt: z.string().datetime(),
})

export const createLecturerSchema = z.object({
  firstName: z.string().min(1, 'First name is required'),
  lastName: z.string().min(1, 'Last name is required'),
  lecturerNo: z.string().min(1, 'Lecturer number is required'),
  department: z.string().min(1, 'Department is required'),
  faculty: z.string().optional().or(z.literal('')),
  phoneNumber: z.string().optional().or(z.literal('')),
  email: z.string().email('Invalid email address').optional().or(z.literal('')),
  position: z.string().optional().or(z.literal('')),
})

export type Lecturer = z.infer<typeof lecturerSchema>
export type CreateLecturer = z.infer<typeof createLecturerSchema>
