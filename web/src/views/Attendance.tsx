import React, { useState, useEffect } from 'react'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { api } from '@/lib/api'
import { Service, Student, AttendanceStatus } from '@/lib/schemas'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Skeleton } from '@/components/ui/skeleton'
import { Badge } from '@/components/ui/badge'
import { useToast } from '@/components/ui/use-toast'
import { Search, CheckCircle, XCircle, Loader2, Calendar, Filter } from 'lucide-react'

export function Attendance() {
  const [selectedServiceId, setSelectedServiceId] = useState<string | null>(null)
  const [programFilter, setProgramFilter] = useState('')
  const [search, setSearch] = useState('')
  const [debouncedSearch, setDebouncedSearch] = useState('')
  const { toast } = useToast()
  const queryClient = useQueryClient()

  // Debounce search
  useEffect(() => {
    const timer = setTimeout(() => {
      setDebouncedSearch(search)
    }, 300)
    return () => clearTimeout(timer)
  }, [search])

  // Fetch services
  const { data: services } = useQuery({
    queryKey: ['services-for-attendance'],
    queryFn: async () => {
      const response = await api.get('/services?limit=50&sort=serviceDate&order=desc')

      // Transform backend data to frontend format
      const transformedServices = response.data.data.map((service: any) => ({
        id: service.id,
        title: service.theme || 'Chapel Service',
        description: service.theme || null,
        serviceDate: service.service_date,
        serviceTime: `${service.start_time} - ${service.end_time}`,
        location: null,
        pastorId: service.pastor_id || null,
        semesterId: null,
        requiredAttendance: true,
        createdAt: service.created_at,
        updatedAt: service.updated_at,
        pastor: service.pastor || null,
        semester: null,
      }))

      return transformedServices as Service[]
    },
  })

  // Fetch students
  const { data: students, isLoading: studentsLoading } = useQuery({
    queryKey: ['students-for-attendance', programFilter, debouncedSearch],
    queryFn: async () => {
      const params = new URLSearchParams({ limit: '100' })
      if (programFilter) params.append('program', programFilter)
      if (debouncedSearch) params.append('search', debouncedSearch)

      const response = await api.get(`/students?${params}`)

      // Transform backend data to frontend format
      const transformedData = response.data.data.map((student: any) => {
        const [firstName = '', ...lastNameParts] = (student.name || '').split(' ')
        const lastName = lastNameParts.join(' ')

        return {
          id: student.id,
          studentId: student.student_no,
          firstName,
          lastName,
          program: student.program,
          phoneNumber: student.phone || null,
          yearLevel: student.level ? parseInt(student.level.replace(/\D/g, '')) : 1,
          email: null,
          isActive: true,
          createdAt: student.created_at,
          updatedAt: student.updated_at,
        }
      })

      return transformedData as Student[]
    },
    enabled: !!selectedServiceId,
  })

  // Fetch existing attendance for selected service
  const { data: existingAttendance } = useQuery({
    queryKey: ['attendance', selectedServiceId],
    queryFn: async () => {
      if (!selectedServiceId) return []
      const response = await api.get(`/attendance/service/${selectedServiceId}`)

      // Backend wraps response in data object
      const responseData = response.data?.data || response.data
      const attendanceRecords = responseData?.attendance || []

      // Transform backend data to frontend format
      const transformedAttendance = attendanceRecords.map((attendance: any) => ({
        id: attendance.id,
        studentId: attendance.student_id,
        serviceId: attendance.service_id,
        status: attendance.status,
        checkInTime: attendance.created_at,
        notes: null,
        createdAt: attendance.created_at,
        updatedAt: attendance.updated_at,
      }))

      return transformedAttendance
    },
    enabled: !!selectedServiceId,
  })

  // Mark attendance mutation
  const markAttendanceMutation = useMutation({
    mutationFn: async ({ studentId, status }: { studentId: string; status: AttendanceStatus }) => {
      if (!selectedServiceId) throw new Error('No service selected')

      // Always use the mark endpoint - it handles both create and update
      return api.post('/attendance/mark', {
        service_id: selectedServiceId,
        student_id: studentId,
        status,
      })
    },
    onMutate: async ({ studentId, status }) => {
      // Cancel any outgoing refetches
      await queryClient.cancelQueries({ queryKey: ['attendance', selectedServiceId] })

      // Snapshot the previous value
      const previousAttendance = queryClient.getQueryData(['attendance', selectedServiceId])

      // Optimistically update to the new value
      queryClient.setQueryData(['attendance', selectedServiceId], (old: any) => {
        if (!old) return []

        const newAttendance = {
          id: `temp-${Date.now()}`,
          studentId: studentId,
          serviceId: selectedServiceId,
          status: status,
          checkInTime: new Date().toISOString(),
          notes: null,
          createdAt: new Date().toISOString(),
          updatedAt: new Date().toISOString(),
        }

        // old is already an array of attendance records
        return [...(Array.isArray(old) ? old : []), newAttendance]
      })

      // Return a context object with the snapshotted value
      return { previousAttendance }
    },
    onError: (err: any, variables, context) => {
      // If the mutation fails, use the context returned from onMutate to roll back
      if (context?.previousAttendance) {
        queryClient.setQueryData(['attendance', selectedServiceId], context.previousAttendance)
      }
      toast({
        title: 'Error',
        description: err.response?.data?.message || 'Failed to mark attendance',
        variant: 'destructive',
      })
    },
    onSettled: () => {
      // Always refetch after error or success to ensure data is in sync
      queryClient.invalidateQueries({ queryKey: ['attendance', selectedServiceId] })
    },
  })

  const handleMarkAttendance = (studentId: string, status: AttendanceStatus) => {
    markAttendanceMutation.mutate({ studentId, status })
    toast({
      title: 'Attendance Marked',
      description: `Marked as ${status.toLowerCase()}`,
      duration: 2000,
    })
  }

  const getAttendanceStatus = (studentId: string): AttendanceStatus | null => {
    const record = existingAttendance?.find((a: any) => a.studentId === studentId)
    return record?.status || null
  }

  // Filter out students who already have attendance marked
  const unmarkedStudents = React.useMemo(() => {
    if (!students) return []
    if (!existingAttendance || !Array.isArray(existingAttendance)) return students

    return students.filter((student) => {
      const hasAttendance = existingAttendance.some((a: any) => a.studentId === student.id)
      return !hasAttendance
    })
  }, [students, existingAttendance])

  // Keyboard shortcuts
  useEffect(() => {
    const handleKeyPress = (e: KeyboardEvent) => {
      if (e.target instanceof HTMLInputElement) return

      if (e.key === 'p' || e.key === 'P') {
        // Focus on first student or mark as present
        e.preventDefault()
      } else if (e.key === 'a' || e.key === 'A') {
        // Mark as absent
        e.preventDefault()
      }
    }

    window.addEventListener('keydown', handleKeyPress)
    return () => window.removeEventListener('keydown', handleKeyPress)
  }, [])

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Attendance</h1>
          <p className="text-gray-500 mt-1">Mark student attendance for services</p>
        </div>
      </div>

      {/* Step 1: Select Service */}
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center">
            <Calendar className="mr-2 h-5 w-5" />
            Step 1: Select Service
          </CardTitle>
          <CardDescription>Choose a service to mark attendance</CardDescription>
        </CardHeader>
        <CardContent>
          <Select
            value={selectedServiceId || ''}
            onValueChange={(value) => setSelectedServiceId(value)}
          >
            <SelectTrigger className="w-full">
              <SelectValue placeholder="Select a service" />
            </SelectTrigger>
            <SelectContent>
              {services?.map((service) => (
                <SelectItem key={service.id} value={service.id}>
                  {service.title} - {new Date(service.serviceDate).toLocaleDateString()} ({service.serviceTime})
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        </CardContent>
      </Card>

      {selectedServiceId && (
        <>
          {/* Step 2: Filters */}
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center">
                <Filter className="mr-2 h-5 w-5" />
                Step 2: Filter Students
              </CardTitle>
              <CardDescription>Narrow down the student list</CardDescription>
            </CardHeader>
            <CardContent>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div className="space-y-2">
                  <Label>Program Filter</Label>
                  <Select value={programFilter || "all"} onValueChange={(val) => setProgramFilter(val === "all" ? "" : val)}>
                    <SelectTrigger>
                      <SelectValue placeholder="All Programs" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="all">All Programs</SelectItem>
                      <SelectItem value="Computer Science">Computer Science</SelectItem>
                      <SelectItem value="Engineering">Engineering</SelectItem>
                      <SelectItem value="Business">Business</SelectItem>
                      <SelectItem value="Medicine">Medicine</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
                <div className="space-y-2">
                  <Label>Search Student</Label>
                  <div className="relative">
                    <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
                    <Input
                      placeholder="Search by ID or phone..."
                      value={search}
                      onChange={(e) => setSearch(e.target.value)}
                      className="pl-10"
                    />
                  </div>
                </div>
              </div>
              <div className="mt-4 p-3 bg-blue-50 rounded-md text-sm text-blue-800">
                <strong>Keyboard Shortcuts:</strong> Press <kbd className="px-2 py-1 bg-white rounded border">P</kbd> for Present,
                <kbd className="px-2 py-1 bg-white rounded border ml-1">A</kbd> for Absent
              </div>
            </CardContent>
          </Card>

          {/* Step 3: Mark Attendance */}
          <Card>
            <CardHeader>
              <CardTitle>Step 3: Mark Attendance</CardTitle>
              <CardDescription>
                Click on student cards to mark their attendance
                {unmarkedStudents && ` (${unmarkedStudents.length} unmarked students)`}
              </CardDescription>
            </CardHeader>
            <CardContent>
              {studentsLoading ? (
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                  {[...Array(6)].map((_, i) => (
                    <Skeleton key={i} className="h-32 w-full" />
                  ))}
                </div>
              ) : unmarkedStudents && unmarkedStudents.length > 0 ? (
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                  {unmarkedStudents.map((student) => (
                    <Card
                      key={student.id}
                      className="border-2 border-gray-200 transition-all cursor-pointer hover:shadow-lg hover:border-blue-300"
                    >
                      <CardContent className="p-4">
                        <div className="flex items-start justify-between mb-3">
                          <div className="flex-1 min-w-0">
                            <h3 className="font-semibold text-lg truncate">
                              {student.firstName} {student.lastName}
                            </h3>
                            <p className="text-sm text-gray-600">{student.studentId}</p>
                            <Badge variant="outline" className="mt-1">
                              {student.program}
                            </Badge>
                          </div>
                        </div>
                        <div className="flex space-x-2">
                          <Button
                            size="sm"
                            variant="outline"
                            className="flex-1 hover:bg-green-50 hover:border-green-500"
                            onClick={() => handleMarkAttendance(student.id, 'PRESENT')}
                            disabled={markAttendanceMutation.isPending}
                          >
                            <CheckCircle className="h-4 w-4 mr-1" />
                            Present
                          </Button>
                          <Button
                            size="sm"
                            variant="outline"
                            className="flex-1 hover:bg-red-50 hover:border-red-500"
                            onClick={() => handleMarkAttendance(student.id, 'ABSENT')}
                            disabled={markAttendanceMutation.isPending}
                          >
                            <XCircle className="h-4 w-4 mr-1" />
                            Absent
                          </Button>
                        </div>
                      </CardContent>
                    </Card>
                  ))}
                </div>
              ) : (
                <div className="text-center py-12">
                  <CheckCircle className="h-16 w-16 text-green-400 mx-auto mb-4" />
                  <p className="text-gray-600 mb-2">All students marked!</p>
                  <p className="text-sm text-gray-500">All students for this service have attendance recorded</p>
                </div>
              )}
            </CardContent>
          </Card>

          {/* Attendance Summary */}
          {existingAttendance && existingAttendance.length > 0 && (
            <Card>
              <CardHeader>
                <CardTitle>Attendance Summary</CardTitle>
                <CardDescription>Current attendance statistics for this service</CardDescription>
              </CardHeader>
              <CardContent>
                <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                  <div className="text-center p-4 bg-blue-50 rounded-lg">
                    <div className="text-3xl font-bold text-blue-600">
                      {existingAttendance.length}
                    </div>
                    <div className="text-sm text-blue-800">Total Marked</div>
                  </div>
                  <div className="text-center p-4 bg-green-50 rounded-lg">
                    <div className="text-3xl font-bold text-green-600">
                      {existingAttendance.filter((a: any) => a.status === 'PRESENT').length}
                    </div>
                    <div className="text-sm text-green-800">Present</div>
                  </div>
                  <div className="text-center p-4 bg-red-50 rounded-lg">
                    <div className="text-3xl font-bold text-red-600">
                      {existingAttendance.filter((a: any) => a.status === 'ABSENT').length}
                    </div>
                    <div className="text-sm text-red-800">Absent</div>
                  </div>
                </div>
              </CardContent>
            </Card>
          )}
        </>
      )}
    </div>
  )
}
