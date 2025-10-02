import { useState } from 'react'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { api } from '@/lib/api'
import { Student, CreateStudent, createStudentSchema } from '@/lib/schemas'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from '@/components/ui/dialog'
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
import { Plus, Search, Upload, Edit, Trash2, Users, Loader2 } from 'lucide-react'
import {
  Pagination,
  PaginationContent,
  PaginationItem,
  PaginationLink,
  PaginationNext,
  PaginationPrevious,
} from '@/components/ui/pagination'

export function Students() {
  const [page, setPage] = useState(1)
  const [search, setSearch] = useState('')
  const [programFilter, setProgramFilter] = useState('')
  const [addDialogOpen, setAddDialogOpen] = useState(false)
  const [editStudent, setEditStudent] = useState<Student | null>(null)
  const [importDialogOpen, setImportDialogOpen] = useState(false)
  const { toast } = useToast()
  const queryClient = useQueryClient()

  const limit = 10

  // Fetch students
  const { data, isLoading } = useQuery({
    queryKey: ['students', page, search, programFilter],
    queryFn: async () => {
      const params = new URLSearchParams({
        page: page.toString(),
        limit: limit.toString(),
      })
      if (search) params.append('search', search)
      if (programFilter) params.append('program', programFilter)

      const response = await api.get(`/students?${params}`)

      // Transform backend data to frontend format
      const transformedData = {
        ...response.data,
        data: response.data.data.map((student: any) => {
          const [firstName = '', ...lastNameParts] = (student.name || '').split(' ')
          const lastName = lastNameParts.join(' ')
          return {
            id: student.id,
            studentId: student.student_no,
            firstName,
            lastName,
            program: student.program,
            email: student.email || null,
            phoneNumber: student.phone || null,
            yearLevel: student.level ? parseInt(student.level.replace(/\D/g, '')) : 1,
            isActive: true,
            createdAt: student.created_at,
            updatedAt: student.updated_at,
          }
        })
      }

      return transformedData
    },
  })

  // Create student mutation
  const createMutation = useMutation({
    mutationFn: (data: CreateStudent) => {
      // Transform frontend fields to backend format
      const backendData = {
        student_no: data.studentId,
        name: `${data.firstName} ${data.lastName}`,
        program: data.program,
        phone: data.phoneNumber || null,
        faculty: null,
        level: data.yearLevel ? `Year ${data.yearLevel}` : null,
      }
      return api.post('/students', backendData)
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['students'] })
      setAddDialogOpen(false)
      toast({ title: 'Success', description: 'Student created successfully' })
    },
    onError: (error: any) => {
      toast({
        title: 'Error',
        description: error.response?.data?.message || 'Failed to create student',
        variant: 'destructive',
      })
    },
  })

  // Update student mutation
  const updateMutation = useMutation({
    mutationFn: ({ id, data }: { id: string; data: Partial<CreateStudent> }) => {
      // Transform frontend fields to backend format
      const backendData: any = {}
      if (data.studentId) backendData.student_no = data.studentId
      if (data.firstName || data.lastName) {
        backendData.name = `${data.firstName || ''} ${data.lastName || ''}`.trim()
      }
      if (data.program) backendData.program = data.program
      if (data.phoneNumber !== undefined) backendData.phone = data.phoneNumber || null
      if (data.yearLevel) backendData.level = `Year ${data.yearLevel}`

      return api.patch(`/students/${id}`, backendData)
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['students'] })
      setEditStudent(null)
      toast({ title: 'Success', description: 'Student updated successfully' })
    },
    onError: (error: any) => {
      toast({
        title: 'Error',
        description: error.response?.data?.message || 'Failed to update student',
        variant: 'destructive',
      })
    },
  })

  // Delete student mutation
  const deleteMutation = useMutation({
    mutationFn: (id: string) => api.delete(`/students/${id}`),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['students'] })
      toast({ title: 'Success', description: 'Student deleted successfully' })
    },
    onError: (error: any) => {
      toast({
        title: 'Error',
        description: error.response?.data?.message || 'Failed to delete student',
        variant: 'destructive',
      })
    },
  })

  const handleDelete = (id: string) => {
    if (confirm('Are you sure you want to delete this student?')) {
      deleteMutation.mutate(id)
    }
  }

  const totalPages = data ? Math.ceil(data.total / limit) : 1

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Students</h1>
          <p className="text-gray-500 mt-1">Manage student records</p>
        </div>
        <div className="flex items-center space-x-2">
          <Button variant="outline" onClick={() => setImportDialogOpen(true)}>
            <Upload className="mr-2 h-4 w-4" />
            Import CSV
          </Button>
          <Button onClick={() => setAddDialogOpen(true)}>
            <Plus className="mr-2 h-4 w-4" />
            Add Student
          </Button>
        </div>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Student List</CardTitle>
          <CardDescription>View and manage all student records</CardDescription>
        </CardHeader>
        <CardContent>
          {/* Filters */}
          <div className="flex flex-col md:flex-row gap-4 mb-6">
            <div className="flex-1">
              <div className="relative">
                <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
                <Input
                  placeholder="Search by name or student ID..."
                  value={search}
                  onChange={(e) => setSearch(e.target.value)}
                  className="pl-10"
                />
              </div>
            </div>
            <Select value={programFilter || "all"} onValueChange={(val) => setProgramFilter(val === "all" ? "" : val)}>
              <SelectTrigger className="w-full md:w-[200px]">
                <SelectValue placeholder="Filter by program" />
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

          {/* Table */}
          {isLoading ? (
            <div className="space-y-3">
              {[...Array(5)].map((_, i) => (
                <Skeleton key={i} className="h-16 w-full" />
              ))}
            </div>
          ) : data && data.data.length > 0 ? (
            <>
              <div className="rounded-md border overflow-x-auto">
                <Table>
                  <TableHeader>
                    <TableRow>
                      <TableHead>Student ID</TableHead>
                      <TableHead>Name</TableHead>
                      <TableHead>Program</TableHead>
                      <TableHead>Year</TableHead>
                      <TableHead>Email</TableHead>
                      <TableHead>Phone</TableHead>
                      <TableHead>Status</TableHead>
                      <TableHead className="text-right">Actions</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {data.data.map((student: Student) => (
                      <TableRow key={student.id}>
                        <TableCell className="font-medium">{student.studentId}</TableCell>
                        <TableCell>
                          {student.firstName} {student.lastName}
                        </TableCell>
                        <TableCell>{student.program}</TableCell>
                        <TableCell>Year {student.yearLevel}</TableCell>
                        <TableCell>{student.email || 'N/A'}</TableCell>
                        <TableCell>{student.phoneNumber || 'N/A'}</TableCell>
                        <TableCell>
                          <Badge variant={student.isActive ? 'default' : 'secondary'}>
                            {student.isActive ? 'Active' : 'Inactive'}
                          </Badge>
                        </TableCell>
                        <TableCell className="text-right">
                          <div className="flex items-center justify-end space-x-2">
                            <Button
                              variant="ghost"
                              size="icon"
                              onClick={() => setEditStudent(student)}
                            >
                              <Edit className="h-4 w-4" />
                            </Button>
                            <Button
                              variant="ghost"
                              size="icon"
                              onClick={() => handleDelete(student.id)}
                            >
                              <Trash2 className="h-4 w-4 text-red-600" />
                            </Button>
                          </div>
                        </TableCell>
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>
              </div>

              {/* Pagination */}
              {totalPages > 1 && (
                <div className="mt-4">
                  <Pagination>
                    <PaginationContent>
                      <PaginationItem>
                        <PaginationPrevious
                          onClick={() => setPage((p) => Math.max(1, p - 1))}
                          className={page === 1 ? 'pointer-events-none opacity-50' : 'cursor-pointer'}
                        />
                      </PaginationItem>
                      {[...Array(totalPages)].map((_, i) => (
                        <PaginationItem key={i}>
                          <PaginationLink
                            onClick={() => setPage(i + 1)}
                            isActive={page === i + 1}
                            className="cursor-pointer"
                          >
                            {i + 1}
                          </PaginationLink>
                        </PaginationItem>
                      ))}
                      <PaginationItem>
                        <PaginationNext
                          onClick={() => setPage((p) => Math.min(totalPages, p + 1))}
                          className={page === totalPages ? 'pointer-events-none opacity-50' : 'cursor-pointer'}
                        />
                      </PaginationItem>
                    </PaginationContent>
                  </Pagination>
                </div>
              )}
            </>
          ) : (
            <div className="text-center py-12">
              <Users className="h-16 w-16 text-gray-400 mx-auto mb-4" />
              <p className="text-gray-600 mb-2">No students found</p>
              <p className="text-sm text-gray-500 mb-4">Get started by adding your first student</p>
              <Button onClick={() => setAddDialogOpen(true)}>
                <Plus className="mr-2 h-4 w-4" />
                Add Student
              </Button>
            </div>
          )}
        </CardContent>
      </Card>

      {/* Add Student Dialog */}
      <StudentDialog
        open={addDialogOpen}
        onOpenChange={setAddDialogOpen}
        onSubmit={(data) => createMutation.mutate(data)}
        isLoading={createMutation.isPending}
      />

      {/* Edit Student Dialog */}
      {editStudent && (
        <StudentDialog
          open={!!editStudent}
          onOpenChange={(open) => !open && setEditStudent(null)}
          onSubmit={(data) => updateMutation.mutate({ id: editStudent.id, data })}
          isLoading={updateMutation.isPending}
          defaultValues={editStudent}
        />
      )}

      {/* Import CSV Dialog */}
      <ImportDialog open={importDialogOpen} onOpenChange={setImportDialogOpen} />
    </div>
  )
}

interface StudentDialogProps {
  open: boolean
  onOpenChange: (open: boolean) => void
  onSubmit: (data: CreateStudent) => void
  isLoading: boolean
  defaultValues?: Partial<Student>
}

function StudentDialog({ open, onOpenChange, onSubmit, isLoading, defaultValues }: StudentDialogProps) {
  const {
    register,
    handleSubmit,
    formState: { errors },
    reset,
    setValue,
  } = useForm<CreateStudent>({
    resolver: zodResolver(createStudentSchema),
    defaultValues: defaultValues as CreateStudent,
  })

  const handleClose = () => {
    reset()
    onOpenChange(false)
  }

  return (
    <Dialog open={open} onOpenChange={handleClose}>
      <DialogContent className="max-w-2xl max-h-[90vh] overflow-y-auto">
        <DialogHeader>
          <DialogTitle>{defaultValues ? 'Edit Student' : 'Add New Student'}</DialogTitle>
          <DialogDescription>
            {defaultValues ? 'Update student information' : 'Enter student details to create a new record'}
          </DialogDescription>
        </DialogHeader>
        <form onSubmit={handleSubmit(onSubmit)}>
          <div className="grid grid-cols-2 gap-4 py-4">
            <div className="space-y-2">
              <Label htmlFor="firstName">First Name *</Label>
              <Input id="firstName" {...register('firstName')} />
              {errors.firstName && <p className="text-sm text-red-600">{errors.firstName.message}</p>}
            </div>
            <div className="space-y-2">
              <Label htmlFor="lastName">Last Name *</Label>
              <Input id="lastName" {...register('lastName')} />
              {errors.lastName && <p className="text-sm text-red-600">{errors.lastName.message}</p>}
            </div>
            <div className="space-y-2">
              <Label htmlFor="studentId">Student ID *</Label>
              <Input id="studentId" {...register('studentId')} />
              {errors.studentId && <p className="text-sm text-red-600">{errors.studentId.message}</p>}
            </div>
            <div className="space-y-2">
              <Label htmlFor="program">Program *</Label>
              <Input id="program" {...register('program')} />
              {errors.program && <p className="text-sm text-red-600">{errors.program.message}</p>}
            </div>
            <div className="space-y-2">
              <Label htmlFor="yearLevel">Year Level *</Label>
              <Input id="yearLevel" type="number" {...register('yearLevel', { valueAsNumber: true })} />
              {errors.yearLevel && <p className="text-sm text-red-600">{errors.yearLevel.message}</p>}
            </div>
            <div className="space-y-2">
              <Label htmlFor="email">Email</Label>
              <Input id="email" type="email" {...register('email')} />
              {errors.email && <p className="text-sm text-red-600">{errors.email.message}</p>}
            </div>
            <div className="space-y-2 col-span-2">
              <Label htmlFor="phoneNumber">Phone Number</Label>
              <Input id="phoneNumber" {...register('phoneNumber')} />
              {errors.phoneNumber && <p className="text-sm text-red-600">{errors.phoneNumber.message}</p>}
            </div>
          </div>
          <DialogFooter>
            <Button type="button" variant="outline" onClick={handleClose} disabled={isLoading}>
              Cancel
            </Button>
            <Button type="submit" disabled={isLoading}>
              {isLoading ? (
                <>
                  <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                  Saving...
                </>
              ) : defaultValues ? (
                'Update Student'
              ) : (
                'Add Student'
              )}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  )
}

function ImportDialog({ open, onOpenChange }: { open: boolean; onOpenChange: (open: boolean) => void }) {
  const [file, setFile] = useState<File | null>(null)
  const { toast } = useToast()
  const queryClient = useQueryClient()

  const importMutation = useMutation({
    mutationFn: async (file: File) => {
      const formData = new FormData()
      formData.append('file', file)
      return api.post('/students/bulk-upload', formData, {
        headers: { 'Content-Type': 'multipart/form-data' },
      })
    },
    onSuccess: (response: any) => {
      queryClient.invalidateQueries({ queryKey: ['students'] })
      const summary = response.data?.data?.summary
      if (summary) {
        toast({
          title: 'Import Complete',
          description: `Inserted: ${summary.inserted}, Updated: ${summary.updated}, Errors: ${summary.errors}`,
        })
      } else {
        toast({ title: 'Success', description: 'Students imported successfully' })
      }
      onOpenChange(false)
      setFile(null)
    },
    onError: (error: any) => {
      toast({
        title: 'Error',
        description: error.response?.data?.message || error.response?.data?.detail || 'Failed to import students',
        variant: 'destructive',
      })
    },
  })

  const handleImport = () => {
    if (file) {
      importMutation.mutate(file)
    }
  }

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Import Students from CSV</DialogTitle>
          <DialogDescription>Upload a CSV file with student data</DialogDescription>
        </DialogHeader>
        <div className="space-y-4 py-4">
          <Input
            type="file"
            accept=".csv"
            onChange={(e) => setFile(e.target.files?.[0] || null)}
          />
          <p className="text-sm text-gray-500">
            CSV should include columns: <strong>No</strong>, <strong>Name</strong>, <strong>Program</strong>, <strong>Phone Number</strong> (optional: Faculty, Level)
          </p>
        </div>
        <DialogFooter>
          <Button variant="outline" onClick={() => onOpenChange(false)}>
            Cancel
          </Button>
          <Button onClick={handleImport} disabled={!file || importMutation.isPending}>
            {importMutation.isPending ? (
              <>
                <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                Importing...
              </>
            ) : (
              'Import'
            )}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  )
}
