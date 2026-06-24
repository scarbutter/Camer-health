import { Router } from 'express';
import { createVitalSign, getVitalHistory, getLatestVitals, getVitalStats } from './vital-signs.controller';
import { authenticate } from '../../middleware/auth.middleware';

const router = Router();

router.use(authenticate);

// Patient submits their own vitals
router.post('/me', createVitalSign);
router.get('/me', getVitalHistory);
router.get('/me/latest', getLatestVitals);
router.get('/me/stats', getVitalStats);

// Doctor/admin accessing a specific patient's vitals
router.post('/:patientId', createVitalSign);
router.get('/:patientId', getVitalHistory);
router.get('/:patientId/latest', getLatestVitals);
router.get('/:patientId/stats', getVitalStats);

export default router;
