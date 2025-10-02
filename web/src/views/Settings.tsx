import { useState } from 'react'
import { useAuth } from '@/contexts/AuthContext'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { ChangePasswordDialog } from '@/components/ChangePasswordDialog'
import { useToast } from '@/components/ui/use-toast'
import { User, Lock, Mail, Shield } from 'lucide-react'

export function Settings() {
  const [showPasswordDialog, setShowPasswordDialog] = useState(false)
  const [isChangingPassword, setIsChangingPassword] = useState(false)
  const { user, changePassword } = useAuth()
  const { toast } = useToast()

  const handlePasswordChange = async (data: { currentPassword: string; newPassword: string }) => {
    setIsChangingPassword(true)
    try {
      await changePassword(data.currentPassword, data.newPassword)
      toast({
        title: 'Success',
        description: 'Password changed successfully',
      })
      setShowPasswordDialog(false)
    } catch (error: any) {
      toast({
        title: 'Error',
        description: error.message || 'Failed to change password',
        variant: 'destructive',
      })
      throw error
    } finally {
      setIsChangingPassword(false)
    }
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold text-gray-900">Settings</h1>
        <p className="text-gray-500 mt-1">Manage your account settings and preferences</p>
      </div>

      {/* User Profile Card */}
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center">
            <User className="mr-2 h-5 w-5" />
            Profile Information
          </CardTitle>
          <CardDescription>View your account details</CardDescription>
        </CardHeader>
        <CardContent>
          <div className="space-y-4">
            <div className="flex items-start">
              <User className="h-5 w-5 text-gray-400 mt-0.5 mr-3" />
              <div>
                <p className="text-sm font-medium text-gray-500">Full Name</p>
                <p className="text-base font-semibold text-gray-900">{user?.name || 'N/A'}</p>
              </div>
            </div>
            <div className="flex items-start">
              <Mail className="h-5 w-5 text-gray-400 mt-0.5 mr-3" />
              <div>
                <p className="text-sm font-medium text-gray-500">Email Address</p>
                <p className="text-base font-semibold text-gray-900">{user?.email || 'N/A'}</p>
              </div>
            </div>
            <div className="flex items-start">
              <Shield className="h-5 w-5 text-gray-400 mt-0.5 mr-3" />
              <div>
                <p className="text-sm font-medium text-gray-500">Role</p>
                <p className="text-base font-semibold text-gray-900">{user?.role || 'N/A'}</p>
              </div>
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Security Card */}
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center">
            <Lock className="mr-2 h-5 w-5" />
            Security
          </CardTitle>
          <CardDescription>Manage your password and security settings</CardDescription>
        </CardHeader>
        <CardContent>
          <div className="space-y-4">
            <div>
              <h3 className="text-sm font-medium text-gray-900 mb-2">Password</h3>
              <p className="text-sm text-gray-500 mb-4">
                Change your password to keep your account secure. Use a strong password with at least 8 characters.
              </p>
              <Button onClick={() => setShowPasswordDialog(true)}>
                <Lock className="mr-2 h-4 w-4" />
                Change Password
              </Button>
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Change Password Dialog */}
      <ChangePasswordDialog
        open={showPasswordDialog}
        onOpenChange={setShowPasswordDialog}
        onSubmit={handlePasswordChange}
        isLoading={isChangingPassword}
        forceChange={false}
      />
    </div>
  )
}
