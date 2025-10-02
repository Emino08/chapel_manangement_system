import React, { createContext, useContext, useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import { api } from '@/lib/api'
import { User, LoginCredentials, UserRole } from '@/lib/schemas'

interface AuthContextType {
  user: User | null
  token: string | null
  isLoading: boolean
  mustChangePassword: boolean
  login: (credentials: LoginCredentials) => Promise<void>
  logout: () => void
  changePassword: (currentPassword: string, newPassword: string) => Promise<void>
  isAuthenticated: boolean
  isAdmin: () => boolean
  isStaff: () => boolean
  isSuperAdmin: () => boolean
  hasRole: (role: UserRole) => boolean
}

const AuthContext = createContext<AuthContextType | undefined>(undefined)

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<User | null>(null)
  const [token, setToken] = useState<string | null>(null)
  const [isLoading, setIsLoading] = useState(true)
  const [mustChangePassword, setMustChangePassword] = useState(false)
  const navigate = useNavigate()

  // Load user from localStorage on mount
  useEffect(() => {
    const storedToken = localStorage.getItem('auth_token')
    const storedUser = localStorage.getItem('auth_user')

    if (storedToken && storedUser) {
      setToken(storedToken)
      try {
        setUser(JSON.parse(storedUser))
      } catch (error) {
        console.error('Failed to parse stored user:', error)
        localStorage.removeItem('auth_user')
        localStorage.removeItem('auth_token')
      }
    }
    setIsLoading(false)
  }, [])

  const login = async (credentials: LoginCredentials) => {
    try {
      const response = await api.post('/auth/login', credentials)
      console.log('Login response:', response.data)

      // Backend returns { success: true, data: { token, user } }
      const responseData = response.data?.data || response.data
      const { token: authToken, user: authUser } = responseData

      if (!authToken || !authUser) {
        throw new Error('Invalid response from server')
      }

      setToken(authToken)
      setUser(authUser)

      localStorage.setItem('auth_token', authToken)
      localStorage.setItem('auth_user', JSON.stringify(authUser))

      // Check if user must change password from backend response
      const mustChange = responseData.mustChangePassword === true || authUser.must_change_password === true || authUser.must_change_password === 1

      if (mustChange) {
        setMustChangePassword(true)
        // Don't navigate to dashboard yet - wait for password change
      } else {
        setMustChangePassword(false)
        // Use setTimeout to ensure state is updated before navigation
        setTimeout(() => {
          navigate('/dashboard')
        }, 100)
      }
    } catch (error: any) {
      console.error('Login failed:', error)
      throw new Error(
        error.response?.data?.message || error.response?.data?.detail || 'Login failed. Please check your credentials.'
      )
    }
  }

  const changePassword = async (currentPassword: string, newPassword: string) => {
    try {
      if (!user) {
        throw new Error('No user logged in')
      }

      // Use the correct password change endpoint
      await api.post('/auth/change-password', {
        currentPassword,
        newPassword,
      })

      // Update user object
      const updatedUser = { ...user, must_change_password: 0 }
      setUser(updatedUser)
      setMustChangePassword(false)
      localStorage.setItem('auth_user', JSON.stringify(updatedUser))

      // Navigate to dashboard after successful password change
      setTimeout(() => {
        navigate('/dashboard')
      }, 100)
    } catch (error: any) {
      console.error('Password change failed:', error)
      throw new Error(
        error.response?.data?.message || error.response?.data?.detail || 'Failed to change password. Please try again.'
      )
    }
  }

  const logout = () => {
    setUser(null)
    setToken(null)
    localStorage.removeItem('auth_token')
    localStorage.removeItem('auth_user')
    navigate('/login')
  }

  const isAuthenticated = !!token && !!user

  const isAdmin = () => user?.role === 'ADMIN'

  const isStaff = () => user?.role === 'HR' || user?.role === 'SUO'

  const isSuperAdmin = () => user?.role === 'ADMIN' // ADMIN is the highest role

  const hasRole = (role: UserRole) => user?.role === role

  const value: AuthContextType = {
    user,
    token,
    isLoading,
    mustChangePassword,
    login,
    logout,
    changePassword,
    isAuthenticated,
    isAdmin,
    isStaff,
    isSuperAdmin,
    hasRole,
  }

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>
}

export function useAuth() {
  const context = useContext(AuthContext)
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider')
  }
  return context
}
