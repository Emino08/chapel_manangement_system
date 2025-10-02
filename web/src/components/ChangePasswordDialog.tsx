import { useState } from 'react'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from '@/components/ui/dialog'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Loader2 } from 'lucide-react'

const changePasswordSchema = z.object({
  currentPassword: z.string().min(1, 'Current password is required'),
  newPassword: z.string().min(8, 'Password must be at least 8 characters'),
  confirmPassword: z.string().min(1, 'Please confirm your password'),
}).refine((data) => data.newPassword === data.confirmPassword, {
  message: "Passwords don't match",
  path: ['confirmPassword'],
})

type ChangePasswordForm = z.infer<typeof changePasswordSchema>

interface ChangePasswordDialogProps {
  open: boolean
  onOpenChange: (open: boolean) => void
  onSubmit: (data: { currentPassword: string; newPassword: string }) => Promise<void>
  isLoading: boolean
  forceChange?: boolean
}

export function ChangePasswordDialog({
  open,
  onOpenChange,
  onSubmit,
  isLoading,
  forceChange = false,
}: ChangePasswordDialogProps) {
  const {
    register,
    handleSubmit,
    formState: { errors },
    reset,
  } = useForm<ChangePasswordForm>({
    resolver: zodResolver(changePasswordSchema),
  })

  const handleClose = () => {
    if (!forceChange) {
      reset()
      onOpenChange(false)
    }
  }

  const handleFormSubmit = async (data: ChangePasswordForm) => {
    await onSubmit({
      currentPassword: data.currentPassword,
      newPassword: data.newPassword,
    })
    reset()
  }

  return (
    <Dialog open={open} onOpenChange={handleClose}>
      <DialogContent className="max-w-md" onPointerDownOutside={forceChange ? (e) => e.preventDefault() : undefined} onEscapeKeyDown={forceChange ? (e) => e.preventDefault() : undefined}>
        <DialogHeader>
          <DialogTitle>{forceChange ? 'Change Your Password' : 'Update Password'}</DialogTitle>
          <DialogDescription>
            {forceChange
              ? 'For security reasons, you must change your password before continuing.'
              : 'Enter your current password and choose a new one.'}
          </DialogDescription>
        </DialogHeader>
        <form onSubmit={handleSubmit(handleFormSubmit)}>
          <div className="space-y-4 py-4">
            <div className="space-y-2">
              <Label htmlFor="currentPassword">Current Password *</Label>
              <Input
                id="currentPassword"
                type="password"
                {...register('currentPassword')}
              />
              {errors.currentPassword && (
                <p className="text-sm text-red-600">{errors.currentPassword.message}</p>
              )}
            </div>
            <div className="space-y-2">
              <Label htmlFor="newPassword">New Password *</Label>
              <Input
                id="newPassword"
                type="password"
                {...register('newPassword')}
              />
              {errors.newPassword && (
                <p className="text-sm text-red-600">{errors.newPassword.message}</p>
              )}
            </div>
            <div className="space-y-2">
              <Label htmlFor="confirmPassword">Confirm New Password *</Label>
              <Input
                id="confirmPassword"
                type="password"
                {...register('confirmPassword')}
              />
              {errors.confirmPassword && (
                <p className="text-sm text-red-600">{errors.confirmPassword.message}</p>
              )}
            </div>
            {forceChange && (
              <div className="p-3 bg-amber-50 rounded-md text-sm text-amber-800">
                <strong>Password Requirements:</strong>
                <ul className="mt-2 space-y-1 text-xs list-disc list-inside">
                  <li>At least 8 characters long</li>
                  <li>Use a strong, unique password</li>
                </ul>
              </div>
            )}
          </div>
          <DialogFooter>
            {!forceChange && (
              <Button type="button" variant="outline" onClick={handleClose} disabled={isLoading}>
                Cancel
              </Button>
            )}
            <Button type="submit" disabled={isLoading}>
              {isLoading ? (
                <>
                  <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                  Changing Password...
                </>
              ) : (
                'Change Password'
              )}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  )
}
