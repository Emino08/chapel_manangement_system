import { useState } from 'react'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { api } from '@/lib/api'
import { Semester } from '@/lib/schemas'
import { Button } from '@/components/ui/button'
import { Label } from '@/components/ui/label'
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select'
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Skeleton } from '@/components/ui/skeleton'
import { Badge } from '@/components/ui/badge'
import { useToast } from '@/components/ui/use-toast'
import { Download, Upload, FileSpreadsheet, Filter, BarChart3, CheckCircle, XCircle, Loader2, Users, GraduationCap } from 'lucide-react'
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from '@/components/ui/dialog'
import { Input } from '@/components/ui/input'
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs'

interface AttendanceReport {
  studentId: string
  studentNo: string
  firstName: string
  lastName: string
  program: string
  timesAttended: number
  totalServices: number
  attendanceRate: number
  eligible: boolean
}

interface LecturerAttendanceReport {
  lecturerId: string
  lecturerNo: string
  firstName: string
  lastName: string
  department: string
  faculty: string | null
  position: string | null
  timesAttended: number
  totalServices: number
  attendanceRate: number
  eligible: boolean
}

export function Reports() {
  const [reportType, setReportType] = useState<'students' | 'lecturers'>('students')
  const [selectedSemesterId, setSelectedSemesterId] = useState<string | null>(null)
  const [programFilter, setProgramFilter] = useState('')
  const [departmentFilter, setDepartmentFilter] = useState('')
  const [threshold, setThreshold] = useState(75)
  const [uploadDialogOpen, setUploadDialogOpen] = useState(false)
  const { toast } = useToast()
  const queryClient = useQueryClient()

  // Fetch semesters
  const { data: semesters } = useQuery({
    queryKey: ['semesters-for-reports'],
    queryFn: async () => {
      const response = await api.get('/semesters?limit=100')

      // Transform backend data to frontend format
      const transformedSemesters = response.data.data.map((semester: any) => ({
        id: semester.id,
        name: semester.name,
        startDate: semester.start_date,
        endDate: semester.end_date,
        isActive: semester.active === 1 || semester.active === true,
        createdAt: semester.created_at,
        updatedAt: semester.updated_at,
      }))

      return transformedSemesters as Semester[]
    },
  })

  // Fetch attendance report
  const { data: reportData, isLoading: reportLoading } = useQuery({
    queryKey: ['attendance-report', selectedSemesterId, programFilter, threshold],
    queryFn: async () => {
      if (!selectedSemesterId) return null

      const params = new URLSearchParams({
        threshold: threshold.toString(),
      })
      if (programFilter) params.append('program', programFilter)

      const response = await api.get(`/reports/semester/${selectedSemesterId}?${params}`)

      // Transform backend data to frontend format
      const transformedReport = response.data.data.map((record: any) => {
        // Split name into firstName and lastName
        const [firstName = '', ...lastNameParts] = (record.student_name || '').split(' ')
        const lastName = lastNameParts.join(' ')

        return {
          studentId: record.student_id,
          studentNo: record.student_no,
          firstName,
          lastName,
          program: record.program,
          timesAttended: parseInt(record.times_attended) || 0,
          totalServices: parseInt(record.total_services) || 0,
          attendanceRate: parseFloat(record.attendance_percentage) || 0,
          eligible: record.is_eligible === true || record.is_eligible === 1,
        }
      })

      return transformedReport as AttendanceReport[]
    },
    enabled: !!selectedSemesterId && reportType === 'students',
  })

  // Fetch lecturer attendance report
  const { data: lecturerReportData, isLoading: lecturerReportLoading } = useQuery({
    queryKey: ['lecturer-attendance-report', selectedSemesterId, departmentFilter, threshold],
    queryFn: async () => {
      if (!selectedSemesterId) return null

      const params = new URLSearchParams({
        threshold: threshold.toString(),
      })
      if (departmentFilter) params.append('department', departmentFilter)

      const response = await api.get(`/reports/semester/${selectedSemesterId}/lecturers?${params}`)

      // Transform backend data to frontend format
      const transformedReport = response.data.data.map((record: any) => {
        // Split name into firstName and lastName
        const [firstName = '', ...lastNameParts] = (record.lecturer_name || '').split(' ')
        const lastName = lastNameParts.join(' ')

        return {
          lecturerId: record.lecturer_id,
          lecturerNo: record.lecturer_no,
          firstName,
          lastName,
          department: record.department,
          faculty: record.faculty || null,
          position: record.position || null,
          timesAttended: parseInt(record.times_attended) || 0,
          totalServices: parseInt(record.total_services) || 0,
          attendanceRate: parseFloat(record.attendance_percentage) || 0,
          eligible: record.is_eligible === true || record.is_eligible === 1,
        }
      })

      return transformedReport as LecturerAttendanceReport[]
    },
    enabled: !!selectedSemesterId && reportType === 'lecturers',
  })

  // Export CSV
  const exportCSV = () => {
    const currentData = reportType === 'students' ? reportData : lecturerReportData

    if (!currentData || currentData.length === 0) {
      toast({
        title: 'No Data',
        description: 'No data available to export',
        variant: 'destructive',
      })
      return
    }

    let headers: string[]
    let rows: any[]

    if (reportType === 'students') {
      headers = ['Student ID', 'First Name', 'Last Name', 'Program', 'Times Attended', 'Total Services', 'Attendance Rate (%)', 'Eligible']
      rows = (reportData || []).map(row => [
        row.studentNo,
        row.firstName,
        row.lastName,
        row.program,
        row.timesAttended,
        row.totalServices,
        row.attendanceRate.toFixed(2),
        row.eligible ? 'Yes' : 'No'
      ])
    } else {
      headers = ['Lecturer ID', 'First Name', 'Last Name', 'Department', 'Faculty', 'Position', 'Times Attended', 'Total Services', 'Attendance Rate (%)', 'Eligible']
      rows = (lecturerReportData || []).map(row => [
        row.lecturerNo,
        row.firstName,
        row.lastName,
        row.department,
        row.faculty || '',
        row.position || '',
        row.timesAttended,
        row.totalServices,
        row.attendanceRate.toFixed(2),
        row.eligible ? 'Yes' : 'No'
      ])
    }

    const csvContent = [
      headers.join(','),
      ...rows.map(row => row.join(','))
    ].join('\n')

    const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' })
    const link = document.createElement('a')
    const url = URL.createObjectURL(blob)
    link.setAttribute('href', url)
    link.setAttribute('download', `attendance-report-${new Date().toISOString().split('T')[0]}.csv`)
    link.style.visibility = 'hidden'
    document.body.appendChild(link)
    link.click()
    document.body.removeChild(link)

    toast({
      title: 'Success',
      description: 'Report exported successfully',
    })
  }

  // Export XLSX (simplified version - in production you'd use a library like xlsx)
  const exportXLSX = () => {
    const currentData = reportType === 'students' ? reportData : lecturerReportData

    if (!currentData || currentData.length === 0) {
      toast({
        title: 'No Data',
        description: 'No data available to export',
        variant: 'destructive',
      })
      return
    }

    // For a real implementation, you would use a library like 'xlsx'
    // For now, we'll just export as CSV with .xlsx extension
    exportCSV()
  }

  const currentReportData = reportType === 'students' ? reportData : lecturerReportData
  const currentReportLoading = reportType === 'students' ? reportLoading : lecturerReportLoading
  const eligibleCount = currentReportData?.filter(r => r.eligible).length || 0
  const totalCount = currentReportData?.length || 0

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Reports</h1>
          <p className="text-gray-500 mt-1">Generate and export attendance reports</p>
        </div>
        <Button variant="outline" onClick={() => setUploadDialogOpen(true)}>
          <Upload className="mr-2 h-4 w-4" />
          Upload Excel
        </Button>
      </div>

      {/* Tabs for Student/Lecturer Reports */}
      <Tabs value={reportType} onValueChange={(val) => setReportType(val as 'students' | 'lecturers')}>
        <TabsList className="grid w-full max-w-md grid-cols-2">
          <TabsTrigger value="students" className="flex items-center">
            <Users className="mr-2 h-4 w-4" />
            Student Reports
          </TabsTrigger>
          <TabsTrigger value="lecturers" className="flex items-center">
            <GraduationCap className="mr-2 h-4 w-4" />
            Lecturer Reports
          </TabsTrigger>
        </TabsList>
      </Tabs>

      {/* Filters Card */}
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center">
            <Filter className="mr-2 h-5 w-5" />
            Report Filters
          </CardTitle>
          <CardDescription>Configure your attendance report parameters</CardDescription>
        </CardHeader>
        <CardContent>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div className="space-y-2">
              <Label>Semester *</Label>
              <Select
                value={selectedSemesterId || ''}
                onValueChange={(value) => setSelectedSemesterId(value)}
              >
                <SelectTrigger>
                  <SelectValue placeholder="Select semester" />
                </SelectTrigger>
                <SelectContent>
                  {semesters?.map((semester) => (
                    <SelectItem key={semester.id} value={semester.id}>
                      {semester.name} {semester.isActive && '(Active)'}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            {reportType === 'students' ? (
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
            ) : (
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
            )}
            <div className="space-y-2">
              <Label>Eligibility Threshold: {threshold}%</Label>
              <input
                type="range"
                min="0"
                max="100"
                step="5"
                value={threshold}
                onChange={(e) => setThreshold(parseInt(e.target.value))}
                className="w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer"
              />
              <p className="text-xs text-gray-500">
                {reportType === 'students' ? 'Students' : 'Lecturers'} with attendance below {threshold}% are marked ineligible
              </p>
            </div>
          </div>
        </CardContent>
      </Card>

      {selectedSemesterId && (
        <>
          {/* Summary Stats */}
          {currentReportData && currentReportData.length > 0 && (
            <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
              <Card>
                <CardHeader className="pb-2">
                  <CardTitle className="text-sm font-medium text-gray-600">
                    Total {reportType === 'students' ? 'Students' : 'Lecturers'}
                  </CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="text-3xl font-bold">{totalCount}</div>
                </CardContent>
              </Card>
              <Card>
                <CardHeader className="pb-2">
                  <CardTitle className="text-sm font-medium text-gray-600">Eligible</CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="text-3xl font-bold text-green-600">{eligibleCount}</div>
                  <p className="text-xs text-gray-500 mt-1">
                    {totalCount > 0 ? ((eligibleCount / totalCount) * 100).toFixed(1) : 0}% of total
                  </p>
                </CardContent>
              </Card>
              <Card>
                <CardHeader className="pb-2">
                  <CardTitle className="text-sm font-medium text-gray-600">Ineligible</CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="text-3xl font-bold text-red-600">{totalCount - eligibleCount}</div>
                  <p className="text-xs text-gray-500 mt-1">
                    {totalCount > 0 ? (((totalCount - eligibleCount) / totalCount) * 100).toFixed(1) : 0}% of total
                  </p>
                </CardContent>
              </Card>
              <Card>
                <CardHeader className="pb-2">
                  <CardTitle className="text-sm font-medium text-gray-600">Avg Attendance</CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="text-3xl font-bold text-blue-600">
                    {currentReportData && currentReportData.length > 0
                      ? (currentReportData.reduce((sum, r) => sum + r.attendanceRate, 0) / currentReportData.length).toFixed(1)
                      : 0}%
                  </div>
                </CardContent>
              </Card>
            </div>
          )}

          {/* Report Table */}
          <Card>
            <CardHeader>
              <div className="flex items-center justify-between">
                <div>
                  <CardTitle className="flex items-center">
                    <BarChart3 className="mr-2 h-5 w-5" />
                    Attendance Report
                  </CardTitle>
                  <CardDescription>
                    Detailed attendance records and eligibility status
                  </CardDescription>
                </div>
                <div className="flex space-x-2">
                  <Button variant="outline" size="sm" onClick={exportCSV}>
                    <Download className="mr-2 h-4 w-4" />
                    Export CSV
                  </Button>
                  <Button variant="outline" size="sm" onClick={exportXLSX}>
                    <FileSpreadsheet className="mr-2 h-4 w-4" />
                    Export XLSX
                  </Button>
                </div>
              </div>
            </CardHeader>
            <CardContent>
              {currentReportLoading ? (
                <div className="space-y-3">
                  {[...Array(5)].map((_, i) => (
                    <Skeleton key={i} className="h-16 w-full" />
                  ))}
                </div>
              ) : currentReportData && currentReportData.length > 0 ? (
                <div className="rounded-md border overflow-x-auto">
                  <Table>
                    <TableHeader>
                      <TableRow>
                        {reportType === 'students' ? (
                          <>
                            <TableHead>Student ID</TableHead>
                            <TableHead>Name</TableHead>
                            <TableHead>Program</TableHead>
                          </>
                        ) : (
                          <>
                            <TableHead>Lecturer ID</TableHead>
                            <TableHead>Name</TableHead>
                            <TableHead>Department</TableHead>
                            <TableHead>Position</TableHead>
                          </>
                        )}
                        <TableHead className="text-center">Times Attended</TableHead>
                        <TableHead className="text-center">Total Services</TableHead>
                        <TableHead className="text-center">Attendance Rate</TableHead>
                        <TableHead className="text-center">Eligibility</TableHead>
                      </TableRow>
                    </TableHeader>
                    <TableBody>
                      {reportType === 'students' ? (
                        reportData?.map((row) => (
                          <TableRow key={row.studentId}>
                            <TableCell className="font-medium">{row.studentNo}</TableCell>
                            <TableCell>
                              {row.firstName} {row.lastName}
                            </TableCell>
                            <TableCell>{row.program}</TableCell>
                            <TableCell className="text-center">{row.timesAttended}</TableCell>
                            <TableCell className="text-center">{row.totalServices}</TableCell>
                            <TableCell className="text-center">
                              <Badge
                                variant={row.attendanceRate >= threshold ? 'default' : 'destructive'}
                              >
                                {row.attendanceRate.toFixed(1)}%
                              </Badge>
                            </TableCell>
                            <TableCell className="text-center">
                              {row.eligible ? (
                                <Badge variant="default" className="bg-green-600">
                                  <CheckCircle className="h-3 w-3 mr-1" />
                                  Eligible
                                </Badge>
                              ) : (
                                <Badge variant="destructive">
                                  <XCircle className="h-3 w-3 mr-1" />
                                  Ineligible
                                </Badge>
                              )}
                            </TableCell>
                          </TableRow>
                        ))
                      ) : (
                        lecturerReportData?.map((row) => (
                          <TableRow key={row.lecturerId}>
                            <TableCell className="font-medium">{row.lecturerNo}</TableCell>
                            <TableCell>
                              {row.firstName} {row.lastName}
                            </TableCell>
                            <TableCell>{row.department}</TableCell>
                            <TableCell>{row.position || '-'}</TableCell>
                            <TableCell className="text-center">{row.timesAttended}</TableCell>
                            <TableCell className="text-center">{row.totalServices}</TableCell>
                            <TableCell className="text-center">
                              <Badge
                                variant={row.attendanceRate >= threshold ? 'default' : 'destructive'}
                              >
                                {row.attendanceRate.toFixed(1)}%
                              </Badge>
                            </TableCell>
                            <TableCell className="text-center">
                              {row.eligible ? (
                                <Badge variant="default" className="bg-green-600">
                                  <CheckCircle className="h-3 w-3 mr-1" />
                                  Eligible
                                </Badge>
                              ) : (
                                <Badge variant="destructive">
                                  <XCircle className="h-3 w-3 mr-1" />
                                  Ineligible
                                </Badge>
                              )}
                            </TableCell>
                          </TableRow>
                        ))
                      )}
                    </TableBody>
                  </Table>
                </div>
              ) : (
                <div className="text-center py-12">
                  <BarChart3 className="h-16 w-16 text-gray-400 mx-auto mb-4" />
                  <p className="text-gray-600 mb-2">No report data available</p>
                  <p className="text-sm text-gray-500">
                    Select a semester and ensure there are attendance records
                  </p>
                </div>
              )}
            </CardContent>
          </Card>
        </>
      )}

      {!selectedSemesterId && (
        <Card>
          <CardContent className="py-12">
            <div className="text-center">
              <BarChart3 className="h-16 w-16 text-gray-400 mx-auto mb-4" />
              <p className="text-gray-600 mb-2">Select a semester to view reports</p>
              <p className="text-sm text-gray-500">
                Choose a semester from the filters above to generate attendance reports
              </p>
            </div>
          </CardContent>
        </Card>
      )}

      {/* Upload Excel Dialog */}
      <UploadExcelDialog open={uploadDialogOpen} onOpenChange={setUploadDialogOpen} />
    </div>
  )
}

function UploadExcelDialog({ open, onOpenChange }: { open: boolean; onOpenChange: (open: boolean) => void }) {
  const [file, setFile] = useState<File | null>(null)
  const { toast } = useToast()
  const queryClient = useQueryClient()

  const uploadMutation = useMutation({
    mutationFn: async (file: File) => {
      const formData = new FormData()
      formData.append('file', file)
      return api.post('/reports/upload', formData, {
        headers: { 'Content-Type': 'multipart/form-data' },
      })
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['attendance-report'] })
      toast({ title: 'Success', description: 'Report uploaded successfully' })
      onOpenChange(false)
      setFile(null)
    },
    onError: (error: any) => {
      toast({
        title: 'Error',
        description: error.response?.data?.message || 'Failed to upload report',
        variant: 'destructive',
      })
    },
  })

  const handleUpload = () => {
    if (file) {
      uploadMutation.mutate(file)
    }
  }

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Upload Excel Report</DialogTitle>
          <DialogDescription>
            Upload an Excel file containing attendance data
          </DialogDescription>
        </DialogHeader>
        <div className="space-y-4 py-4">
          <Input
            type="file"
            accept=".xlsx,.xls"
            onChange={(e) => setFile(e.target.files?.[0] || null)}
          />
          <p className="text-sm text-gray-500">
            Accepted formats: .xlsx, .xls
          </p>
        </div>
        <DialogFooter>
          <Button variant="outline" onClick={() => onOpenChange(false)}>
            Cancel
          </Button>
          <Button onClick={handleUpload} disabled={!file || uploadMutation.isPending}>
            {uploadMutation.isPending ? (
              <>
                <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                Uploading...
              </>
            ) : (
              'Upload'
            )}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  )
}
