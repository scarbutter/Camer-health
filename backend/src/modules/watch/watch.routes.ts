import { Router } from 'express';
import { receiveWatchData, simulateWatchData, getWatchStatus } from './watch.controller';
import { authenticate, requireRole } from '../../middleware/auth.middleware';

const router = Router();

router.use(authenticate, requireRole('PATIENT'));

/**
 * POST /api/watch/sync
 * Real smartwatch pushes data to this endpoint (authenticated as the patient)
 * Body: { deviceId, heartRate?, temperature?, spO2?, steps?, timestamp? }
 */
router.post('/sync', receiveWatchData);

/**
 * POST /api/watch/simulate
 * Generates simulated watch data for demo/dev purposes
 * ?count=5
 */
router.post('/simulate', simulateWatchData);

/**
 * GET /api/watch/status
 * Returns last sync time and connection status
 */
router.get('/status', getWatchStatus);

export default router;
