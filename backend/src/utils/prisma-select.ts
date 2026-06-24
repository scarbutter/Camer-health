// Reusable select object that excludes the password field from User queries
export const USER_SELECT = {
  id: true,
  email: true,
  role: true,
  isValidated: true,
  createdAt: true,
  updatedAt: true,
} as const;
