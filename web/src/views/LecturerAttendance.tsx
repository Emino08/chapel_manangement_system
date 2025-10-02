import React, { useState, useEffect } from 'react'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { api } from '@/lib/api'
import { Service, Lecturer, AttendanceStatus } from '@/lib/schemas'
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
import { Search, CheckCircle, XCircle, Calendar, Filter, GraduationCap } from 'lucide-react'

export function LecturerAttendance() {
  const [selectedServiceId, setSelectedServiceId] = useState<string | null>(null)
  const [departmentFilter, setDepartmentFilter] = useState('')
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
    queryKey: ['services-for-lecturer-attendance'],
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

  // Fetch lecturers
  const { data: lecturers, isLoading: lecturersLoading } = useQuery({
    queryKey: ['lecturers-for-attendance', departmentFilter, debouncedSearch],
    queryFn: async () => {
      const params = new URLSearchParams({ limit: '100' })
      if (departmentFilter) params.append('department', departmentFilter)
      if (debouncedSearch) params.append('search', debouncedSearch)

      const response = await api.get(`/lecturers?${params}`)

      // Transform backend data to frontend format
      const transformedData = response.data.data.map((lecturer: any) => {
        const [firstName = '', ...lastNameParts] = (lecturer.name || '').split(' ')
        const lastName = lastNameParts.join(' ')

        return {
          id: lecturer.id,
          lecturerNo: lecturer.lecturer_no,
          firstName,
          lastName,
          department: lecturer.department,
          faculty: lecturer.faculty || null,
          phoneNumber: lecturer.phone || null,
          email: lecturer.email || null,
          position: lecturer.position || null,
          createdAt: lecturer.created_at,
          updatedAt: lecturer.updated_at,
        }
      })

      return transformedData as Lecturer[]
    },
    enabled: !!selectedServiceId,
  })

  // Fetch existing attendance for selected service
  const { data: existingAttendance } = useQuery({
    queryKey: ['lecturer-attendance', selectedServiceId],
    queryFn: async () => {
      if (!selectedServiceId) return []
      const response = await api.get(`/attendance/service/${selectedServiceId}/lecturers`)

      // Backend wraps response in data object
      const responseData = response.data?.data || response.data
      const attendanceRecords = responseData?.attendance || []

      // Transform backend data to frontend format
      const transformedAttendance = attendanceRecords.map((attendance: any) => ({
        id: attendance.id,
        lecturerId: attendance.lecturer_id,
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
    mutationFn: async ({ lecturerId, status }: { lecturerId: string; status: AttendanceStatus }) => {
      if (!selectedServiceId) throw new Error('No service selected')

      // Always use the mark endpoint - it handles both create and update
      return api.post('/attendance/mark-lecturer', {
        service_id: selectedServiceId,
        lecturer_id: lecturerId,
        status,
      })
    },
    onMutate: async ({ lecturerId, status }) => {
      // Cancel any outgoing refetches
      await queryClient.cancelQueries({ queryKey: ['lecturer-attendance', selectedServiceId] })

      // Snapshot the previous value
      const previousAttendance = queryClient.getQueryData(['lecturer-attendance', selectedServiceId])

      // Optimistically update to the new value
      queryClient.setQueryData(['lecturer-attendance', selectedServiceId], (old: any) => {
        if (!old) return []

        const newAttendance = {
          id: `temp-${Date.now()}`,
          lecturerId: lecturerId,
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
        queryClient.setQueryData(['lecturer-attendance', selectedServiceId], context.previousAttendance)
      }
      toast({
        title: 'Error',
        description: err.response?.data?.message || 'Failed to mark attendance',
        variant: 'destructive',
      })
    },
    onSettled: () => {
      // Always refetch after error or success to ensure data is in sync
      queryClient.invalidateQueries({ queryKey: ['lecturer-attendance', selectedServiceId] })
    },
  })

  const handleMarkAttendance = (lecturerId: string, status: AttendanceStatus) => {
    markAttendanceMutation.mutate({ lecturerId, status })
    toast({
      title: 'Attendance Marked',
      description: `Marked as ${status.toLowerCase()}`,
      duration: 2000,
    })
  }

  const getAttendanceStatus = (lecturerId: string): AttendanceStatus | null => {
    const record = existingAttendance?.find((a: any) => a.lecturerId === lecturerId)
    return record?.status || null
  }

  // Filter out lecturers who already have attendance marked
  const unmarkedLecturers = React.useMemo(() => {
    if (!lecturers) return []
    if (!existingAttendance || !Array.isArray(existingAttendance)) return lecturers

    return lecturers.filter((lecturer) => {
      const hasAttendance = existingAttendance.some((a: any) => a.lecturerId === lecturer.id)
      return !hasAttendance
    })
  }, [lecturers, existingAttendance])

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Lecturer Attendance</h1>
          <p className="text-gray-500 mt-1">Mark lecturer attendance for services</p>
        </div>
      </div>

      {/* Step 1: Select Service */}
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center">
            <Calendar className="mr-2 h-5 w-5" />
            Step 1: Select Service
          </CardTitle>
          <CardDescription>Choose a service to mark lecturer attendance</CardDescription>
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
                Step 2: Filter Lecturers
              </CardTitle>
              <CardDescription>Narrow down the lecturer list</CardDescription>
            </CardHeader>
            <CardContent>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div className="space-y-2">
                  <Label>Department Filter</Label>
                  <Select value={departmentFilter || "all"} onValueChange={(val) => setDepartmentFilter(val === "all" ? "" : val)}>
                    <SelectTrigger>
                      <SelectValue placeholder="All Departments" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="all">All Departments</SelectItem>
                      <SelectItem value="Computer Science">Computer Science</SelectItem>
                      <SelectItem value="Business Administration">Business Administration</SelectItem>
                      <SelectItem value="Civil Engineering">Civil Engineering</SelectItem>
                      <SelectItem value="Nursing">Nursing</SelectItem>
                      <SelectItem value="Law">Law</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
                <div className="space-y-2">
                  <Label>Search Lecturer</Label>
                  <div className="relative">
                    <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
                    <Input
                      placeholder="Search by number or phone..."
                      value={search}
                      onChange={(e) => setSearch(e.target.value)}
                      className="pl-10"
                    />
                  </div>
                </div>
              </div>
            </CardContent>
          </Card>

          {/* Step 3: Mark Attendance */}
          <Card>
            <CardHeader>
              <CardTitle>Step 3: Mark Attendance</CardTitle>
              <CardDescription>
                Click on lecturer cards to mark their attendance
                {unmarkedLecturers && ` (${unmarkedLecturers.length} unmarked lecturers)`}
              </CardDescription>
            </CardHeader>
            <CardContent>
              {lecturersLoading ? (
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                  {[...Array(6)].map((_, i) => (
                    <Skeleton key={i} className="h-32 w-full" />
                  ))}
                </div>
              ) : unmarkedLecturers && unmarkedLecturers.length > 0 ? (
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                  {unmarkedLecturers.map((lecturer) => (
                    <Card
                      key={lecturer.id}
                      className="border-2 border-gray-200 transition-all cursor-pointer hover:shadow-lg hover:border-blue-300"
                    >
                      <CardContent className="p-4">
                        <div className="flex items-start justify-between mb-3">
                          <div className="flex-1 min-w-0">
                            <div className="flex items-center space-x-2 mb-1">
                              <GraduationCap className="h-4 w-4 text-gray-400" />
                              <h3 className="font-semibold text-lg truncate">
                                {lecturer.firstName} {lecturer.lastName}
                              </h3>
                            </div>
                            <p className="text-sm text-gray-600">{lecturer.lecturerNo}</p>
                            <Badge variant="outline" className="mt-1">
                              {lecturer.department}
                            </Badge>
                            {lecturer.position && (
                              <p className="text-xs text-gray-500 mt-1">{lecturer.position}</p>
                            )}
                          </div>
                        </div>
                        <div className="flex space-x-2">
                          <Button
                            size="sm"
                            variant="outline"
                            className="flex-1 hover:bg-green-50 hover:border-green-500"
                            onClick={() => handleMarkAttendance(lecturer.id, 'PRESENT')}
                            disabled={markAttendanceMutation.isPending}
                          >
                            <CheckCircle className="h-4 w-4 mr-1" />
                            Present
                          </Button>
                          <Button
                            size="sm"
                            variant="outline"
                            className="flex-1 hover:bg-red-50 hover:border-red-500"
                            onClick={() => handleMarkAttendance(lecturer.id, 'ABSENT')}
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
                  <p className="text-gray-600 mb-2">All lecturers marked!</p>
                  <p className="text-sm text-gray-500">All lecturers for this service have attendance recorded</p>
                </div>
              )}
            </CardContent>
          </Card>

          {/* Attendance Summary */}
          {existingAttendance && existingAttendance.length > 0 && (
            <Card>
              <CardHeader>
                <CardTitle>Attendance Summary</CardTitle>
                <CardDescription>Current lecturer attendance statistics for this service</CardDescription>
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
