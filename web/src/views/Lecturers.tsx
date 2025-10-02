import { useState } from 'react'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { api } from '@/lib/api'
import { Lecturer, CreateLecturer, createLecturerSchema } from '@/lib/schemas'
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
} from '@/components/ui/dialog'
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
import { Plus, Search, Upload, Edit, Trash2, GraduationCap, Loader2 } from 'lucide-react'
import {
  Pagination,
  PaginationContent,
  PaginationItem,
  PaginationLink,
  PaginationNext,
  PaginationPrevious,
} from '@/components/ui/pagination'

export function Lecturers() {
  const [page, setPage] = useState(1)
  const [search, setSearch] = useState('')
  const [addDialogOpen, setAddDialogOpen] = useState(false)
  const [editLecturer, setEditLecturer] = useState<Lecturer | null>(null)
  const [importDialogOpen, setImportDialogOpen] = useState(false)
  const { toast } = useToast()
  const queryClient = useQueryClient()

  const limit = 10

  // Fetch lecturers
  const { data, isLoading } = useQuery({
    queryKey: ['lecturers', page, search],
    queryFn: async () => {
      const params = new URLSearchParams({
        page: page.toString(),
        limit: limit.toString(),
      })
      if (search) params.append('search', search)

      const response = await api.get(`/lecturers?${params}`)

      // Transform backend data to frontend format
      const transformedData = {
        ...response.data,
        data: response.data.data.map((lecturer: any) => {
          // Split name into firstName and lastName
          const [firstName = '', ...lastNameParts] = (lecturer.name || '').split(' ')
          const lastName = lastNameParts.join(' ')

          return {
            id: lecturer.id,
            firstName,
            lastName,
            lecturerNo: lecturer.lecturer_no,
            department: lecturer.department,
            faculty: lecturer.faculty || null,
            phoneNumber: lecturer.phone || null,
            email: lecturer.email || null,
            position: lecturer.position || null,
            createdAt: lecturer.created_at,
            updatedAt: lecturer.updated_at,
          }
        })
      }

      return transformedData
    },
  })

  // Create lecturer mutation
  const createMutation = useMutation({
    mutationFn: (data: CreateLecturer) => {
      // Transform frontend data to backend format
      const backendData = {
        lecturer_no: data.lecturerNo,
        name: `${data.firstName} ${data.lastName}`,
        department: data.department,
        faculty: data.faculty || null,
        phone: data.phoneNumber || null,
        email: data.email || null,
        position: data.position || null,
      }
      return api.post('/lecturers', backendData)
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['lecturers'] })
      setAddDialogOpen(false)
      toast({ title: 'Success', description: 'Lecturer created successfully' })
    },
    onError: (error: any) => {
      toast({
        title: 'Error',
        description: error.response?.data?.message || 'Failed to create lecturer',
        variant: 'destructive',
      })
    },
  })

  // Update lecturer mutation
  const updateMutation = useMutation({
    mutationFn: ({ id, data }: { id: string; data: Partial<CreateLecturer> }) => {
      // Transform frontend data to backend format
      const backendData: any = {}

      if (data.firstName || data.lastName) {
        backendData.name = `${data.firstName || ''} ${data.lastName || ''}`.trim()
      }

      if (data.lecturerNo !== undefined) {
        backendData.lecturer_no = data.lecturerNo
      }

      if (data.department !== undefined) {
        backendData.department = data.department
      }

      if (data.faculty !== undefined) {
        backendData.faculty = data.faculty || null
      }

      if (data.phoneNumber !== undefined) {
        backendData.phone = data.phoneNumber || null
      }

      if (data.email !== undefined) {
        backendData.email = data.email || null
      }

      if (data.position !== undefined) {
        backendData.position = data.position || null
      }

      return api.patch(`/lecturers/${id}`, backendData)
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['lecturers'] })
      setEditLecturer(null)
      toast({ title: 'Success', description: 'Lecturer updated successfully' })
    },
    onError: (error: any) => {
      toast({
        title: 'Error',
        description: error.response?.data?.message || 'Failed to update lecturer',
        variant: 'destructive',
      })
    },
  })

  // Delete lecturer mutation
  const deleteMutation = useMutation({
    mutationFn: (id: string) => api.delete(`/lecturers/${id}`),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['lecturers'] })
      toast({ title: 'Success', description: 'Lecturer deleted successfully' })
    },
    onError: (error: any) => {
      toast({
        title: 'Error',
        description: error.response?.data?.message || 'Failed to delete lecturer',
        variant: 'destructive',
      })
    },
  })

  const handleDelete = (id: string) => {
    if (confirm('Are you sure you want to delete this lecturer?')) {
      deleteMutation.mutate(id)
    }
  }

  const totalPages = data ? Math.ceil(data.total / limit) : 1

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Lecturers</h1>
          <p className="text-gray-500 mt-1">Manage lecturer records</p>
        </div>
        <div className="flex items-center space-x-2">
          <Button variant="outline" onClick={() => setImportDialogOpen(true)}>
            <Upload className="mr-2 h-4 w-4" />
            Import CSV
          </Button>
          <Button onClick={() => setAddDialogOpen(true)}>
            <Plus className="mr-2 h-4 w-4" />
            Add Lecturer
          </Button>
        </div>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Lecturer List</CardTitle>
          <CardDescription>View and manage all lecturer records</CardDescription>
        </CardHeader>
        <CardContent>
          {/* Search */}
          <div className="mb-6">
            <div className="relative">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
              <Input
                placeholder="Search by name or lecturer number..."
                value={search}
                onChange={(e) => setSearch(e.target.value)}
                className="pl-10"
              />
            </div>
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
                      <TableHead>Lecturer No</TableHead>
                      <TableHead>Name</TableHead>
                      <TableHead>Department</TableHead>
                      <TableHead>Faculty</TableHead>
                      <TableHead>Phone</TableHead>
                      <TableHead>Position</TableHead>
                      <TableHead className="text-right">Actions</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {data.data.map((lecturer: Lecturer) => (
                      <TableRow key={lecturer.id}>
                        <TableCell className="font-medium">
                          <div className="flex items-center space-x-2">
                            <GraduationCap className="h-4 w-4 text-gray-400" />
                            <span>{lecturer.lecturerNo}</span>
                          </div>
                        </TableCell>
                        <TableCell>
                          {lecturer.firstName} {lecturer.lastName}
                        </TableCell>
                        <TableCell>{lecturer.department}</TableCell>
                        <TableCell>{lecturer.faculty || 'N/A'}</TableCell>
                        <TableCell>{lecturer.phoneNumber || 'N/A'}</TableCell>
                        <TableCell>
                          <Badge variant="outline">{lecturer.position || 'Lecturer'}</Badge>
                        </TableCell>
                        <TableCell className="text-right">
                          <div className="flex items-center justify-end space-x-2">
                            <Button
                              variant="ghost"
                              size="icon"
                              onClick={() => setEditLecturer(lecturer)}
                            >
                              <Edit className="h-4 w-4" />
                            </Button>
                            <Button
                              variant="ghost"
                              size="icon"
                              onClick={() => handleDelete(lecturer.id)}
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
              <GraduationCap className="h-16 w-16 text-gray-400 mx-auto mb-4" />
              <p className="text-gray-600 mb-2">No lecturers found</p>
              <p className="text-sm text-gray-500 mb-4">Get started by adding your first lecturer</p>
              <Button onClick={() => setAddDialogOpen(true)}>
                <Plus className="mr-2 h-4 w-4" />
                Add Lecturer
              </Button>
            </div>
          )}
        </CardContent>
      </Card>

      {/* Add Lecturer Dialog */}
      <LecturerDialog
        open={addDialogOpen}
        onOpenChange={setAddDialogOpen}
        onSubmit={(data) => createMutation.mutate(data)}
        isLoading={createMutation.isPending}
      />

      {/* Edit Lecturer Dialog */}
      {editLecturer && (
        <LecturerDialog
          open={!!editLecturer}
          onOpenChange={(open) => !open && setEditLecturer(null)}
          onSubmit={(data) => updateMutation.mutate({ id: editLecturer.id, data })}
          isLoading={updateMutation.isPending}
          defaultValues={editLecturer}
        />
      )}

      {/* Import CSV Dialog */}
      <ImportDialog open={importDialogOpen} onOpenChange={setImportDialogOpen} />
    </div>
  )
}

interface LecturerDialogProps {
  open: boolean
  onOpenChange: (open: boolean) => void
  onSubmit: (data: CreateLecturer) => void
  isLoading: boolean
  defaultValues?: Partial<Lecturer>
}

function LecturerDialog({ open, onOpenChange, onSubmit, isLoading, defaultValues }: LecturerDialogProps) {
  const {
    register,
    handleSubmit,
    formState: { errors },
    reset,
  } = useForm<CreateLecturer>({
    resolver: zodResolver(createLecturerSchema),
    defaultValues: defaultValues as CreateLecturer,
  })

  const handleClose = () => {
    reset()
    onOpenChange(false)
  }

  return (
    <Dialog open={open} onOpenChange={handleClose}>
      <DialogContent className="max-w-2xl">
        <DialogHeader>
          <DialogTitle>{defaultValues ? 'Edit Lecturer' : 'Add New Lecturer'}</DialogTitle>
          <DialogDescription>
            {defaultValues ? 'Update lecturer information' : 'Enter lecturer details to create a new record'}
          </DialogDescription>
        </DialogHeader>
        <form onSubmit={handleSubmit(onSubmit)}>
          <div className="grid grid-cols-2 gap-4 py-4">
            <div className="space-y-2">
              <Label htmlFor="lecturerNo">Lecturer Number *</Label>
              <Input id="lecturerNo" {...register('lecturerNo')} />
              {errors.lecturerNo && <p className="text-sm text-red-600">{errors.lecturerNo.message}</p>}
            </div>
            <div className="space-y-2">
              <Label htmlFor="position">Position</Label>
              <Input id="position" placeholder="e.g., Senior Lecturer" {...register('position')} />
              {errors.position && <p className="text-sm text-red-600">{errors.position.message}</p>}
            </div>
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
              <Label htmlFor="department">Department *</Label>
              <Input id="department" placeholder="e.g., Computer Science" {...register('department')} />
              {errors.department && <p className="text-sm text-red-600">{errors.department.message}</p>}
            </div>
            <div className="space-y-2">
              <Label htmlFor="faculty">Faculty</Label>
              <Input id="faculty" placeholder="e.g., Engineering & Technology" {...register('faculty')} />
              {errors.faculty && <p className="text-sm text-red-600">{errors.faculty.message}</p>}
            </div>
            <div className="space-y-2">
              <Label htmlFor="phoneNumber">Phone Number</Label>
              <Input id="phoneNumber" {...register('phoneNumber')} />
              {errors.phoneNumber && <p className="text-sm text-red-600">{errors.phoneNumber.message}</p>}
            </div>
            <div className="space-y-2">
              <Label htmlFor="email">Email</Label>
              <Input id="email" type="email" {...register('email')} />
              {errors.email && <p className="text-sm text-red-600">{errors.email.message}</p>}
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
                'Update Lecturer'
              ) : (
                'Add Lecturer'
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
      return api.post('/lecturers/bulk-upload', formData, {
        headers: { 'Content-Type': 'multipart/form-data' },
      })
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['lecturers'] })
      toast({ title: 'Success', description: 'Lecturers imported successfully' })
      onOpenChange(false)
      setFile(null)
    },
    onError: (error: any) => {
      toast({
        title: 'Error',
        description: error.response?.data?.message || 'Failed to import lecturers',
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
          <DialogTitle>Import Lecturers from CSV</DialogTitle>
          <DialogDescription>Upload a CSV file with lecturer data</DialogDescription>
        </DialogHeader>
        <div className="space-y-4 py-4">
          <Input
            type="file"
            accept=".csv"
            onChange={(e) => setFile(e.target.files?.[0] || null)}
          />
          <p className="text-sm text-gray-500">
            CSV should include: Lecturer No, Name, Department, Faculty (optional), Phone (optional), Email (optional), Position (optional)
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
