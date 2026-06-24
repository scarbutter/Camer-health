import { Router } from 'express';
import {
  getPendingDoctors,
  validateDoctor,
  rejectDoctor,
  getAllUsers,
  deleteUser,
  getDashboardStats,
  assignPatientToDoctor,
} from './admin.controller';
import { authenticate, requireRole } from '../../middleware/auth.middleware';

const router = Router();

router.use(authenticate, requireRole('SUPER_ADMIN', 'ADMIN'));

router.get('/stats', getDashboardStats);
router.get('/users', getAllUsers);
router.delete('/users/:userId', requireRole('SUPER_ADMIN'), deleteUser);

// Doctor validation — SUPER_ADMIN only
router.get('/doctors/pending', requireRole('SUPER_ADMIN'), getPendingDoctors);
router.patch('/doctors/:userId/validate', requireRole('SUPER_ADMIN'), validateDoctor);
router.delete('/doctors/:userId/reject', requireRole('SUPER_ADMIN'), rejectDoctor);

// Assign patient to doctor
router.post('/assign-patient', assignPatientToDoctor);

export default router;
