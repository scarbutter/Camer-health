import { Router } from 'express';
import { getMyProfile, updateMyProfile, listDoctors, getDoctorById, getMyPatients } from './doctors.controller';
import { authenticate, requireRole } from '../../middleware/auth.middleware';
import { upload } from '../../middleware/upload.middleware';

const router = Router();

router.use(authenticate);

router.get('/me', requireRole('DOCTOR'), getMyProfile);
router.put('/me', requireRole('DOCTOR'), upload.single('photo'), updateMyProfile);
router.get('/me/patients', requireRole('DOCTOR'), getMyPatients);
router.get('/', listDoctors);
router.get('/:doctorId', getDoctorById);

export default router;
