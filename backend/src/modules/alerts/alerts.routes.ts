import { Router } from 'express';
import { getMyAlerts, markAlertRead, markAllRead } from './alerts.controller';
import { authenticate, requireRole } from '../../middleware/auth.middleware';

const router = Router();

router.use(authenticate);

router.get('/', requireRole('PATIENT', 'DOCTOR'), getMyAlerts);
router.patch('/:alertId/read', authenticate, markAlertRead);
router.patch('/read-all', requireRole('PATIENT'), markAllRead);

export default router;
