import { Router } from 'express';
import { getMyProfile, updateMyProfile, getPatientById, listPatients } from './patients.controller';
import { authenticate, requireRole } from '../../middleware/auth.middleware';
import { upload } from '../../middleware/upload.middleware';
import { MedicalHistoryService } from './medical-history.service';
import { sendSuccess, sendError } from '../../utils/response';
import prisma from '../../config/database';

const router = Router();
const medicalHistoryService = new MedicalHistoryService();

router.use(authenticate);

// Patient profile
router.get('/me', requireRole('PATIENT'), getMyProfile);
router.put('/me', requireRole('PATIENT'), upload.single('photo'), updateMyProfile);

// Medical history
router.get('/me/medical-history', requireRole('PATIENT'), async (req, res) => {
  try {
    const patient = await prisma.patient.findFirst({ where: { userId: req.user!.userId } });
    if (!patient) { sendError(res, 'Patient introuvable', 404); return; }
    const data = await medicalHistoryService.get(patient.id);
    sendSuccess(res, data);
  } catch (error) {
    sendError(res, (error as Error).message, 500);
  }
});

router.put('/me/medical-history', requireRole('PATIENT'), async (req, res) => {
  try {
    const data = await medicalHistoryService.upsert(req.user!.userId, req.body);
    sendSuccess(res, data, 'Antécédents médicaux mis à jour');
  } catch (error) {
    sendError(res, (error as Error).message);
  }
});

// Doctor/admin access
router.get('/', requireRole('DOCTOR', 'ADMIN', 'SUPER_ADMIN'), listPatients);
router.get('/:patientId', requireRole('DOCTOR', 'ADMIN', 'SUPER_ADMIN'), getPatientById);
router.get('/:patientId/medical-history', requireRole('DOCTOR', 'ADMIN', 'SUPER_ADMIN'), async (req, res) => {
  try {
    const data = await medicalHistoryService.get(req.params.patientId);
    sendSuccess(res, data);
  } catch (error) {
    sendError(res, (error as Error).message, 500);
  }
});

export default router;
