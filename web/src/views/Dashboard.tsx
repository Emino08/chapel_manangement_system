import { useQuery } from '@tanstack/react-query'
import { api } from '@/lib/api'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table'
import { Skeleton } from '@/components/ui/skeleton'
import { Button } from '@/components/ui/button'
import { Badge } from '@/components/ui/badge'
import { Users, Calendar, TrendingUp, BookOpen, Plus, ArrowRight } from 'lucide-react'
import { Link } from 'react-router-dom'
import { Service } from '@/lib/schemas'

export function Dashboard() {
  // Fetch statistics
  const { data: stats, isLoading: statsLoading } = useQuery({
    queryKey: ['dashboard-stats'],
    queryFn: async () => {
      const [studentsRes, servicesRes, pastorsRes] = await Promise.all([
        api.get('/students?page=1&limit=1'),
        api.get('/services?limit=1'),
        api.get('/pastors?page=1&limit=1'),
      ])
      return {
        totalStudents: studentsRes.data?.data?.total || studentsRes.data?.total || 0,
        totalServices: servicesRes.data?.data?.total || servicesRes.data?.total || 0,
        totalPastors: pastorsRes.data?.data?.total || pastorsRes.data?.total || 0,
        attendanceRate: 85, // This would come from a dedicated endpoint
      }
    },
  })

  // Fetch recent services
  const { data: recentServices, isLoading: servicesLoading } = useQuery({
    queryKey: ['recent-services'],
    queryFn: async () => {
      const response = await api.get('/services')
      return (response.data?.data?.services || response.data?.services || []).slice(0, 5)
    },
  })

  const statCards = [
    {
      title: 'Total Students',
      value: stats?.totalStudents || 0,
      icon: Users,
      description: 'Active students',
      color: 'text-blue-600',
      bgColor: 'bg-blue-50',
    },
    {
      title: 'Upcoming Services',
      value: stats?.totalServices || 0,
      icon: Calendar,
      description: 'Scheduled services',
      color: 'text-green-600',
      bgColor: 'bg-green-50',
    },
    {
      title: 'Attendance Rate',
      value: `${stats?.attendanceRate || 0}%`,
      icon: TrendingUp,
      description: 'This semester',
      color: 'text-purple-600',
      bgColor: 'bg-purple-50',
    },
    {
      title: 'Active Pastors',
      value: stats?.totalPastors || 0,
      icon: BookOpen,
      description: 'Registered pastors',
      color: 'text-orange-600',
      bgColor: 'bg-orange-50',
    },
  ]

  return (
    <div className="space-y-8">
      <div>
        <h1 className="text-3xl font-bold text-gray-900">Dashboard</h1>
        <p className="text-gray-500 mt-1">Welcome to the Chapel Management System</p>
      </div>

      {/* Statistics Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        {statCards.map((stat) => {
          const Icon = stat.icon
          return (
            <Card key={stat.title}>
              <CardHeader className="flex flex-row items-center justify-between pb-2">
                <CardTitle className="text-sm font-medium text-gray-600">
                  {stat.title}
                </CardTitle>
                <div className={`p-2 rounded-lg ${stat.bgColor}`}>
                  <Icon className={`h-5 w-5 ${stat.color}`} />
                </div>
              </CardHeader>
              <CardContent>
                {statsLoading ? (
                  <Skeleton className="h-8 w-20" />
                ) : (
                  <>
                    <div className="text-3xl font-bold">{stat.value}</div>
                    <p className="text-xs text-gray-500 mt-1">{stat.description}</p>
                  </>
                )}
              </CardContent>
            </Card>
          )
        })}
      </div>

      {/* Recent Services */}
      <Card>
        <CardHeader>
          <div className="flex items-center justify-between">
            <div>
              <CardTitle>Recent Services</CardTitle>
              <CardDescription>Latest chapel services</CardDescription>
            </div>
            <Button asChild size="sm">
              <Link to="/services">
                View All
                <ArrowRight className="ml-2 h-4 w-4" />
              </Link>
            </Button>
          </div>
        </CardHeader>
        <CardContent>
          {servicesLoading ? (
            <div className="space-y-3">
              {[...Array(3)].map((_, i) => (
                <Skeleton key={i} className="h-16 w-full" />
              ))}
            </div>
          ) : recentServices && recentServices.length > 0 ? (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Title</TableHead>
                  <TableHead>Date</TableHead>
                  <TableHead>Time</TableHead>
                  <TableHead>Pastor</TableHead>
                  <TableHead>Location</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {recentServices.map((service: any) => (
                  <TableRow key={service.id}>
                    <TableCell className="font-medium">{service.theme || 'Chapel Service'}</TableCell>
                    <TableCell>
                      {new Date(service.service_date).toLocaleDateString()}
                    </TableCell>
                    <TableCell>{`${service.start_time} - ${service.end_time}`}</TableCell>
                    <TableCell>
                      {service.pastor_name || 'TBA'}
                    </TableCell>
                    <TableCell>Main Chapel</TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          ) : (
            <div className="text-center py-8">
              <Calendar className="h-12 w-12 text-gray-400 mx-auto mb-4" />
              <p className="text-gray-600 mb-2">No services found</p>
              <p className="text-sm text-gray-500">Create your first service to get started</p>
            </div>
          )}
        </CardContent>
      </Card>

      {/* Quick Actions */}
      <Card>
        <CardHeader>
          <CardTitle>Quick Actions</CardTitle>
          <CardDescription>Common tasks and shortcuts</CardDescription>
        </CardHeader>
        <CardContent>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
            <Button asChild variant="outline" className="h-auto py-4 flex flex-col items-start">
              <Link to="/students">
                <Users className="h-5 w-5 mb-2" />
                <span className="font-semibold">Manage Students</span>
                <span className="text-xs text-gray-500 mt-1">Add or edit students</span>
              </Link>
            </Button>
            <Button asChild variant="outline" className="h-auto py-4 flex flex-col items-start">
              <Link to="/services">
                <Calendar className="h-5 w-5 mb-2" />
                <span className="font-semibold">Create Service</span>
                <span className="text-xs text-gray-500 mt-1">Schedule new service</span>
              </Link>
            </Button>
            <Button asChild variant="outline" className="h-auto py-4 flex flex-col items-start">
              <Link to="/attendance">
                <TrendingUp className="h-5 w-5 mb-2" />
                <span className="font-semibold">Mark Attendance</span>
                <span className="text-xs text-gray-500 mt-1">Record student attendance</span>
              </Link>
            </Button>
            <Button asChild variant="outline" className="h-auto py-4 flex flex-col items-start">
              <Link to="/reports">
                <BookOpen className="h-5 w-5 mb-2" />
                <span className="font-semibold">View Reports</span>
                <span className="text-xs text-gray-500 mt-1">Generate attendance reports</span>
              </Link>
            </Button>
          </div>
        </CardContent>
      </Card>
    </div>
  )
}
