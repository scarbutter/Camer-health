import { Router } from 'express';
import { registerPatient, registerDoctor, login, changePassword, me } from './auth.controller';
import { authenticate } from '../../middleware/auth.middleware';

const router = Router();

/**
 * @route POST /api/auth/register/patient
 * @desc  Register a new patient (immediately validated)
 */
router.post('/register/patient', registerPatient);

/**
 * @route POST /api/auth/register/doctor
 * @desc  Register a new doctor (awaits super admin validation)
 */
router.post('/register/doctor', registerDoctor);

/**
 * @route POST /api/auth/login
 * @desc  Login for all users
 */
router.post('/login', login);

/**
 * @route POST /api/auth/change-password
 * @desc  Change password (authenticated)
 */
router.post('/change-password', authenticate, changePassword);

/**
 * @route GET /api/auth/me
 * @desc  Get current user profile
 */
router.get('/me', authenticate, me);

export default router;
