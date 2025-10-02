import { useState } from 'react'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { api } from '@/lib/api'
import { Pastor, CreatePastor, createPastorSchema } from '@/lib/schemas'
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
import { Plus, Search, Upload, Edit, Trash2, Church, Loader2 } from 'lucide-react'
import {
  Pagination,
  PaginationContent,
  PaginationItem,
  PaginationLink,
  PaginationNext,
  PaginationPrevious,
} from '@/components/ui/pagination'

export function Pastors() {
  const [page, setPage] = useState(1)
  const [search, setSearch] = useState('')
  const [addDialogOpen, setAddDialogOpen] = useState(false)
  const [editPastor, setEditPastor] = useState<Pastor | null>(null)
  const [importDialogOpen, setImportDialogOpen] = useState(false)
  const { toast } = useToast()
  const queryClient = useQueryClient()

  const limit = 10

  // Fetch pastors
  const { data, isLoading } = useQuery({
    queryKey: ['pastors', page, search],
    queryFn: async () => {
      const params = new URLSearchParams({
        page: page.toString(),
        limit: limit.toString(),
      })
      if (search) params.append('search', search)

      const response = await api.get(`/pastors?${params}`)

      // Transform backend data to frontend format
      const transformedData = {
        ...response.data,
        data: response.data.data.map((pastor: any) => {
          // Split name into firstName and lastName
          const [firstName = '', ...lastNameParts] = (pastor.name || '').split(' ')
          const lastName = lastNameParts.join(' ')

          return {
            id: pastor.id,
            firstName,
            lastName,
            phoneNumber: pastor.phone || null,
            isActive: true, // Backend doesn't have isActive field for pastors
            createdAt: pastor.created_at,
            updatedAt: pastor.updated_at,
          }
        })
      }

      return transformedData
    },
  })

  // Create pastor mutation
  const createMutation = useMutation({
    mutationFn: (data: CreatePastor) => {
      // Transform frontend data to backend format
      const backendData = {
        code: `PST${Date.now().toString().slice(-6)}`, // Generate pastor code
        name: `${data.firstName} ${data.lastName}`,
        phone: data.phoneNumber || null,
        email: data.email || null,
      }
      return api.post('/pastors', backendData)
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['pastors'] })
      setAddDialogOpen(false)
      toast({ title: 'Success', description: 'Pastor created successfully' })
    },
    onError: (error: any) => {
      toast({
        title: 'Error',
        description: error.response?.data?.message || 'Failed to create pastor',
        variant: 'destructive',
      })
    },
  })

  // Update pastor mutation
  const updateMutation = useMutation({
    mutationFn: ({ id, data }: { id: string; data: Partial<CreatePastor> }) => {
      // Transform frontend data to backend format
      const backendData: any = {}

      if (data.firstName || data.lastName) {
        backendData.name = `${data.firstName || ''} ${data.lastName || ''}`.trim()
      }

      if (data.phoneNumber !== undefined) {
        backendData.phone = data.phoneNumber || null
      }

      return api.put(`/pastors/${id}`, backendData)
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['pastors'] })
      setEditPastor(null)
      toast({ title: 'Success', description: 'Pastor updated successfully' })
    },
    onError: (error: any) => {
      toast({
        title: 'Error',
        description: error.response?.data?.message || 'Failed to update pastor',
        variant: 'destructive',
      })
    },
  })

  // Delete pastor mutation
  const deleteMutation = useMutation({
    mutationFn: (id: string) => api.delete(`/pastors/${id}`),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['pastors'] })
      toast({ title: 'Success', description: 'Pastor deleted successfully' })
    },
    onError: (error: any) => {
      toast({
        title: 'Error',
        description: error.response?.data?.message || 'Failed to delete pastor',
        variant: 'destructive',
      })
    },
  })

  const handleDelete = (id: string) => {
    if (confirm('Are you sure you want to delete this pastor?')) {
      deleteMutation.mutate(id)
    }
  }

  const totalPages = data ? Math.ceil(data.total / limit) : 1

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Pastors</h1>
          <p className="text-gray-500 mt-1">Manage pastor records</p>
        </div>
        <div className="flex items-center space-x-2">
          <Button variant="outline" onClick={() => setImportDialogOpen(true)}>
            <Upload className="mr-2 h-4 w-4" />
            Import CSV
          </Button>
          <Button onClick={() => setAddDialogOpen(true)}>
            <Plus className="mr-2 h-4 w-4" />
            Add Pastor
          </Button>
        </div>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Pastor List</CardTitle>
          <CardDescription>View and manage all pastor records</CardDescription>
        </CardHeader>
        <CardContent>
          {/* Search */}
          <div className="mb-6">
            <div className="relative">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
              <Input
                placeholder="Search by name..."
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
                      <TableHead>Name</TableHead>
                      <TableHead>Email</TableHead>
                      <TableHead>Phone</TableHead>
                      <TableHead>Status</TableHead>
                      <TableHead className="text-right">Actions</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {data.data.map((pastor: Pastor) => (
                      <TableRow key={pastor.id}>
                        <TableCell className="font-medium">
                          <div className="flex items-center space-x-2">
                            <Church className="h-4 w-4 text-gray-400" />
                            <span>
                              {pastor.firstName} {pastor.lastName}
                            </span>
                          </div>
                        </TableCell>
                        <TableCell>{pastor.email || 'N/A'}</TableCell>
                        <TableCell>{pastor.phoneNumber || 'N/A'}</TableCell>
                        <TableCell>
                          <Badge variant={pastor.isActive ? 'default' : 'secondary'}>
                            {pastor.isActive ? 'Active' : 'Inactive'}
                          </Badge>
                        </TableCell>
                        <TableCell className="text-right">
                          <div className="flex items-center justify-end space-x-2">
                            <Button
                              variant="ghost"
                              size="icon"
                              onClick={() => setEditPastor(pastor)}
                            >
                              <Edit className="h-4 w-4" />
                            </Button>
                            <Button
                              variant="ghost"
                              size="icon"
                              onClick={() => handleDelete(pastor.id)}
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
              <Church className="h-16 w-16 text-gray-400 mx-auto mb-4" />
              <p className="text-gray-600 mb-2">No pastors found</p>
              <p className="text-sm text-gray-500 mb-4">Get started by adding your first pastor</p>
              <Button onClick={() => setAddDialogOpen(true)}>
                <Plus className="mr-2 h-4 w-4" />
                Add Pastor
              </Button>
            </div>
          )}
        </CardContent>
      </Card>

      {/* Add Pastor Dialog */}
      <PastorDialog
        open={addDialogOpen}
        onOpenChange={setAddDialogOpen}
        onSubmit={(data) => createMutation.mutate(data)}
        isLoading={createMutation.isPending}
      />

      {/* Edit Pastor Dialog */}
      {editPastor && (
        <PastorDialog
          open={!!editPastor}
          onOpenChange={(open) => !open && setEditPastor(null)}
          onSubmit={(data) => updateMutation.mutate({ id: editPastor.id, data })}
          isLoading={updateMutation.isPending}
          defaultValues={editPastor}
        />
      )}

      {/* Import CSV Dialog */}
      <ImportDialog open={importDialogOpen} onOpenChange={setImportDialogOpen} />
    </div>
  )
}

interface PastorDialogProps {
  open: boolean
  onOpenChange: (open: boolean) => void
  onSubmit: (data: CreatePastor) => void
  isLoading: boolean
  defaultValues?: Partial<Pastor>
}

function PastorDialog({ open, onOpenChange, onSubmit, isLoading, defaultValues }: PastorDialogProps) {
  const {
    register,
    handleSubmit,
    formState: { errors },
    reset,
  } = useForm<CreatePastor>({
    resolver: zodResolver(createPastorSchema),
    defaultValues: defaultValues as CreatePastor,
  })

  const handleClose = () => {
    reset()
    onOpenChange(false)
  }

  return (
    <Dialog open={open} onOpenChange={handleClose}>
      <DialogContent className="max-w-lg">
        <DialogHeader>
          <DialogTitle>{defaultValues ? 'Edit Pastor' : 'Add New Pastor'}</DialogTitle>
          <DialogDescription>
            {defaultValues ? 'Update pastor information' : 'Enter pastor details to create a new record'}
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
                'Update Pastor'
              ) : (
                'Add Pastor'
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
      return api.post('/pastors/bulk-upload', formData, {
        headers: { 'Content-Type': 'multipart/form-data' },
      })
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['pastors'] })
      toast({ title: 'Success', description: 'Pastors imported successfully' })
      onOpenChange(false)
      setFile(null)
    },
    onError: (error: any) => {
      toast({
        title: 'Error',
        description: error.response?.data?.message || 'Failed to import pastors',
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
          <DialogTitle>Import Pastors from CSV</DialogTitle>
          <DialogDescription>Upload a CSV file with pastor data</DialogDescription>
        </DialogHeader>
        <div className="space-y-4 py-4">
          <Input
            type="file"
            accept=".csv"
            onChange={(e) => setFile(e.target.files?.[0] || null)}
          />
          <p className="text-sm text-gray-500">
            CSV should include: Code, Name, Phone (optional), Email (optional)
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
