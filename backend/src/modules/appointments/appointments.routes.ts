import { Router } from 'express';
import { createAppointment, getMyAppointments, updateAppointmentStatus } from './appointments.controller';
import { authenticate, requireRole } from '../../middleware/auth.middleware';

const router = Router();

router.use(authenticate);

router.post('/', requireRole('PATIENT'), createAppointment);
router.get('/', requireRole('PATIENT', 'DOCTOR'), getMyAppointments);
router.patch('/:appointmentId/status', requireRole('DOCTOR'), updateAppointmentStatus);

export default router;
