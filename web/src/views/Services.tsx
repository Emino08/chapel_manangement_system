import { useState } from 'react'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { api } from '@/lib/api'
import { Service, CreateService, createServiceSchema, Pastor, Semester } from '@/lib/schemas'
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
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Skeleton } from '@/components/ui/skeleton'
import { Badge } from '@/components/ui/badge'
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs'
import { useToast } from '@/components/ui/use-toast'
import { Plus, Calendar as CalendarIcon, List, Edit, Trash2, Loader2, Clock, MapPin } from 'lucide-react'

export function Services() {
  const [viewMode, setViewMode] = useState<'list' | 'calendar'>('list')
  const [addDialogOpen, setAddDialogOpen] = useState(false)
  const [editService, setEditService] = useState<Service | null>(null)
  const { toast } = useToast()
  const queryClient = useQueryClient()

  // Fetch services
  const { data: services, isLoading: servicesLoading } = useQuery({
    queryKey: ['services'],
    queryFn: async () => {
      const response = await api.get('/services?limit=100&sort=serviceDate&order=desc')

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

  // Fetch pastors for dropdown
  const { data: pastors } = useQuery({
    queryKey: ['pastors-all'],
    queryFn: async () => {
      const response = await api.get('/pastors?limit=100')

      // Transform backend data to frontend format
      const transformedPastors = response.data.data.map((pastor: any) => {
        const [firstName = '', ...lastNameParts] = (pastor.name || '').split(' ')
        const lastName = lastNameParts.join(' ')

        return {
          id: pastor.id,
          firstName,
          lastName,
          email: pastor.email || null,
          phoneNumber: pastor.phone || null,
          isActive: true,
          createdAt: pastor.created_at,
          updatedAt: pastor.updated_at,
        }
      })

      return transformedPastors as Pastor[]
    },
  })

  // Fetch semesters
  const { data: semesters } = useQuery({
    queryKey: ['semesters-all'],
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

  // Create service mutation
  const createMutation = useMutation({
    mutationFn: (data: CreateService) => {
      // Parse serviceTime to extract start and end times
      const [startTime, endTime] = data.serviceTime.includes('-')
        ? data.serviceTime.split('-').map(t => t.trim())
        : [data.serviceTime, '12:00:00']

      // Transform frontend data to backend format
      const backendData = {
        service_date: data.serviceDate,
        start_time: startTime,
        end_time: endTime,
        theme: data.title || null,
        pastor_id: data.pastorId || null,
      }

      return api.post('/services', backendData)
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['services'] })
      setAddDialogOpen(false)
      toast({ title: 'Success', description: 'Service created successfully' })
    },
    onError: (error: any) => {
      toast({
        title: 'Error',
        description: error.response?.data?.message || 'Failed to create service',
        variant: 'destructive',
      })
    },
  })

  // Update service mutation
  const updateMutation = useMutation({
    mutationFn: ({ id, data }: { id: string; data: Partial<CreateService> }) => {
      // Transform frontend data to backend format
      const backendData: any = {}

      if (data.serviceDate) {
        backendData.service_date = data.serviceDate
      }

      if (data.serviceTime) {
        const [startTime, endTime] = data.serviceTime.includes('-')
          ? data.serviceTime.split('-').map(t => t.trim())
          : [data.serviceTime, '12:00:00']
        backendData.start_time = startTime
        backendData.end_time = endTime
      }

      if (data.title !== undefined) {
        backendData.theme = data.title || null
      }

      if (data.pastorId !== undefined) {
        backendData.pastor_id = data.pastorId || null
      }

      return api.put(`/services/${id}`, backendData)
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['services'] })
      setEditService(null)
      toast({ title: 'Success', description: 'Service updated successfully' })
    },
    onError: (error: any) => {
      toast({
        title: 'Error',
        description: error.response?.data?.message || 'Failed to update service',
        variant: 'destructive',
      })
    },
  })

  // Delete service mutation
  const deleteMutation = useMutation({
    mutationFn: (id: string) => api.delete(`/services/${id}`),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['services'] })
      toast({ title: 'Success', description: 'Service deleted successfully' })
    },
    onError: (error: any) => {
      toast({
        title: 'Error',
        description: error.response?.data?.message || 'Failed to delete service',
        variant: 'destructive',
      })
    },
  })

  const handleDelete = (id: string) => {
    if (confirm('Are you sure you want to delete this service?')) {
      deleteMutation.mutate(id)
    }
  }

  const createNextWednesday = () => {
    const now = new Date()
    const dayOfWeek = now.getDay()
    const daysUntilWednesday = (3 - dayOfWeek + 7) % 7 || 7
    const nextWednesday = new Date(now)
    nextWednesday.setDate(now.getDate() + daysUntilWednesday)

    const activeSemester = semesters?.find(s => s.isActive)
    if (!activeSemester) {
      toast({
        title: 'Error',
        description: 'No active semester found. Please create one first.',
        variant: 'destructive',
      })
      return
    }

    const defaultService: Partial<CreateService> = {
      title: 'Wednesday Chapel Service',
      serviceDate: nextWednesday.toISOString().split('T')[0],
      serviceTime: '09:00-12:00',
      semesterId: activeSemester.id,
      requiredAttendance: true,
    }

    setEditService({ ...defaultService, id: 0 } as Service)
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Services</h1>
          <p className="text-gray-500 mt-1">Manage chapel services</p>
        </div>
        <div className="flex items-center space-x-2">
          <Button variant="outline" onClick={createNextWednesday}>
            <CalendarIcon className="mr-2 h-4 w-4" />
            Create Next Wednesday
          </Button>
          <Button onClick={() => setAddDialogOpen(true)}>
            <Plus className="mr-2 h-4 w-4" />
            Add Service
          </Button>
        </div>
      </div>

      <Tabs value={viewMode} onValueChange={(v) => setViewMode(v as 'list' | 'calendar')}>
        <TabsList>
          <TabsTrigger value="list">
            <List className="mr-2 h-4 w-4" />
            List View
          </TabsTrigger>
          <TabsTrigger value="calendar">
            <CalendarIcon className="mr-2 h-4 w-4" />
            Calendar View
          </TabsTrigger>
        </TabsList>

        <TabsContent value="list" className="mt-6">
          <Card>
            <CardHeader>
              <CardTitle>Service List</CardTitle>
              <CardDescription>View and manage all chapel services</CardDescription>
            </CardHeader>
            <CardContent>
              {servicesLoading ? (
                <div className="space-y-3">
                  {[...Array(3)].map((_, i) => (
                    <Skeleton key={i} className="h-32 w-full" />
                  ))}
                </div>
              ) : services && services.length > 0 ? (
                <div className="space-y-4">
                  {services.map((service) => (
                    <Card key={service.id} className="border-l-4 border-l-primary">
                      <CardContent className="p-6">
                        <div className="flex items-start justify-between">
                          <div className="flex-1">
                            <div className="flex items-center space-x-3 mb-2">
                              <h3 className="text-lg font-semibold">{service.title}</h3>
                              {service.requiredAttendance && (
                                <Badge variant="default">Required</Badge>
                              )}
                            </div>
                            {service.description && (
                              <p className="text-gray-600 mb-3">{service.description}</p>
                            )}
                            <div className="grid grid-cols-1 md:grid-cols-3 gap-3 text-sm">
                              <div className="flex items-center text-gray-600">
                                <CalendarIcon className="h-4 w-4 mr-2" />
                                {new Date(service.serviceDate).toLocaleDateString('en-US', {
                                  weekday: 'long',
                                  year: 'numeric',
                                  month: 'long',
                                  day: 'numeric',
                                })}
                              </div>
                              <div className="flex items-center text-gray-600">
                                <Clock className="h-4 w-4 mr-2" />
                                {service.serviceTime}
                              </div>
                              {service.location && (
                                <div className="flex items-center text-gray-600">
                                  <MapPin className="h-4 w-4 mr-2" />
                                  {service.location}
                                </div>
                              )}
                            </div>
                            {service.pastor && (
                              <div className="mt-3">
                                <Badge variant="secondary">
                                  Pastor: {service.pastor.firstName} {service.pastor.lastName}
                                </Badge>
                              </div>
                            )}
                          </div>
                          <div className="flex items-center space-x-2 ml-4">
                            <Button
                              variant="ghost"
                              size="icon"
                              onClick={() => setEditService(service)}
                            >
                              <Edit className="h-4 w-4" />
                            </Button>
                            <Button
                              variant="ghost"
                              size="icon"
                              onClick={() => handleDelete(service.id)}
                            >
                              <Trash2 className="h-4 w-4 text-red-600" />
                            </Button>
                          </div>
                        </div>
                      </CardContent>
                    </Card>
                  ))}
                </div>
              ) : (
                <div className="text-center py-12">
                  <CalendarIcon className="h-16 w-16 text-gray-400 mx-auto mb-4" />
                  <p className="text-gray-600 mb-2">No services found</p>
                  <p className="text-sm text-gray-500 mb-4">Get started by creating your first service</p>
                  <Button onClick={() => setAddDialogOpen(true)}>
                    <Plus className="mr-2 h-4 w-4" />
                    Add Service
                  </Button>
                </div>
              )}
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="calendar" className="mt-6">
          <Card>
            <CardHeader>
              <CardTitle>Calendar View</CardTitle>
              <CardDescription>Simple calendar view of services</CardDescription>
            </CardHeader>
            <CardContent>
              <SimpleCalendar services={services || []} onServiceClick={setEditService} />
            </CardContent>
          </Card>
        </TabsContent>
      </Tabs>

      {/* Add Service Dialog */}
      <ServiceDialog
        open={addDialogOpen}
        onOpenChange={setAddDialogOpen}
        onSubmit={(data) => createMutation.mutate(data)}
        isLoading={createMutation.isPending}
        pastors={pastors || []}
        semesters={semesters || []}
      />

      {/* Edit Service Dialog */}
      {editService && (
        <ServiceDialog
          open={!!editService}
          onOpenChange={(open) => !open && setEditService(null)}
          onSubmit={(data) =>
            editService.id === 0
              ? createMutation.mutate(data)
              : updateMutation.mutate({ id: editService.id, data })
          }
          isLoading={updateMutation.isPending || createMutation.isPending}
          defaultValues={editService}
          pastors={pastors || []}
          semesters={semesters || []}
        />
      )}
    </div>
  )
}

interface ServiceDialogProps {
  open: boolean
  onOpenChange: (open: boolean) => void
  onSubmit: (data: CreateService) => void
  isLoading: boolean
  pastors: Pastor[]
  semesters: Semester[]
  defaultValues?: Partial<Service>
}

function ServiceDialog({
  open,
  onOpenChange,
  onSubmit,
  isLoading,
  pastors,
  semesters,
  defaultValues,
}: ServiceDialogProps) {
  const {
    register,
    handleSubmit,
    formState: { errors },
    reset,
    setValue,
    watch,
  } = useForm<CreateService>({
    resolver: zodResolver(createServiceSchema),
    defaultValues: defaultValues as CreateService,
  })

  const handleClose = () => {
    reset()
    onOpenChange(false)
  }

  return (
    <Dialog open={open} onOpenChange={handleClose}>
      <DialogContent className="max-w-2xl max-h-[90vh] overflow-y-auto">
        <DialogHeader>
          <DialogTitle>{defaultValues ? 'Edit Service' : 'Add New Service'}</DialogTitle>
          <DialogDescription>
            {defaultValues ? 'Update service information' : 'Create a new chapel service'}
          </DialogDescription>
        </DialogHeader>
        <form onSubmit={handleSubmit(onSubmit)}>
          <div className="grid grid-cols-2 gap-4 py-4">
            <div className="space-y-2 col-span-2">
              <Label htmlFor="title">Service Title *</Label>
              <Input id="title" {...register('title')} />
              {errors.title && <p className="text-sm text-red-600">{errors.title.message}</p>}
            </div>
            <div className="space-y-2 col-span-2">
              <Label htmlFor="description">Description</Label>
              <Input id="description" {...register('description')} />
              {errors.description && <p className="text-sm text-red-600">{errors.description.message}</p>}
            </div>
            <div className="space-y-2">
              <Label htmlFor="serviceDate">Service Date *</Label>
              <Input id="serviceDate" type="date" {...register('serviceDate')} />
              {errors.serviceDate && <p className="text-sm text-red-600">{errors.serviceDate.message}</p>}
            </div>
            <div className="space-y-2">
              <Label htmlFor="serviceTime">Service Time *</Label>
              <Input id="serviceTime" placeholder="e.g., 09:00-12:00" {...register('serviceTime')} />
              {errors.serviceTime && <p className="text-sm text-red-600">{errors.serviceTime.message}</p>}
            </div>
            <div className="space-y-2">
              <Label htmlFor="location">Location</Label>
              <Input id="location" {...register('location')} />
              {errors.location && <p className="text-sm text-red-600">{errors.location.message}</p>}
            </div>
            <div className="space-y-2">
              <Label htmlFor="semesterId">Semester *</Label>
              <Select
                value={watch('semesterId') || ''}
                onValueChange={(value) => setValue('semesterId', value)}
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
              {errors.semesterId && <p className="text-sm text-red-600">{errors.semesterId.message}</p>}
            </div>
            <div className="space-y-2 col-span-2">
              <Label htmlFor="pastorId">Pastor</Label>
              <Select
                value={watch('pastorId') || 'none'}
                onValueChange={(value) => setValue('pastorId', value === 'none' ? null : value)}
              >
                <SelectTrigger>
                  <SelectValue placeholder="Select pastor (optional)" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="none">No Pastor</SelectItem>
                  {pastors?.map((pastor) => (
                    <SelectItem key={pastor.id} value={pastor.id}>
                      {pastor.firstName} {pastor.lastName}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
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
                'Update Service'
              ) : (
                'Create Service'
              )}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  )
}

function SimpleCalendar({ services, onServiceClick }: { services: Service[]; onServiceClick: (service: Service) => void }) {
  const [currentDate, setCurrentDate] = useState(new Date())

  const year = currentDate.getFullYear()
  const month = currentDate.getMonth()

  const firstDay = new Date(year, month, 1).getDay()
  const daysInMonth = new Date(year, month + 1, 0).getDate()

  const servicesByDate = services.reduce((acc, service) => {
    const date = new Date(service.serviceDate).toDateString()
    if (!acc[date]) acc[date] = []
    acc[date].push(service)
    return acc
  }, {} as Record<string, Service[]>)

  const days = []
  for (let i = 0; i < firstDay; i++) {
    days.push(<div key={`empty-${i}`} className="h-24 border border-gray-200"></div>)
  }

  for (let day = 1; day <= daysInMonth; day++) {
    const date = new Date(year, month, day)
    const dateString = date.toDateString()
    const dayServices = servicesByDate[dateString] || []

    days.push(
      <div key={day} className="h-24 border border-gray-200 p-2 overflow-y-auto hover:bg-gray-50">
        <div className="font-semibold text-sm mb-1">{day}</div>
        {dayServices.map((service) => (
          <div
            key={service.id}
            className="text-xs bg-primary text-primary-foreground rounded px-1 py-0.5 mb-1 cursor-pointer hover:opacity-80"
            onClick={() => onServiceClick(service)}
          >
            {service.title}
          </div>
        ))}
      </div>
    )
  }

  return (
    <div>
      <div className="flex items-center justify-between mb-4">
        <Button variant="outline" size="sm" onClick={() => setCurrentDate(new Date(year, month - 1))}>
          Previous
        </Button>
        <h3 className="text-lg font-semibold">
          {currentDate.toLocaleDateString('en-US', { month: 'long', year: 'numeric' })}
        </h3>
        <Button variant="outline" size="sm" onClick={() => setCurrentDate(new Date(year, month + 1))}>
          Next
        </Button>
      </div>
      <div className="grid grid-cols-7 gap-0">
        {['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'].map((day) => (
          <div key={day} className="text-center font-semibold py-2 border border-gray-200 bg-gray-100">
            {day}
          </div>
        ))}
        {days}
      </div>
    </div>
  )
}
