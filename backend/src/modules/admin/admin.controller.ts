import { Request, Response } from 'express';
import { AdminService } from './admin.service';
import { sendSuccess, sendError } from '../../utils/response';

const adminService = new AdminService();

export const getPendingDoctors = async (_req: Request, res: Response): Promise<void> => {
  try {
    const data = await adminService.getPendingDoctors();
    sendSuccess(res, data);
  } catch (error) {
    sendError(res, (error as Error).message, 500);
  }
};

export const validateDoctor = async (req: Request, res: Response): Promise<void> => {
  try {
    const data = await adminService.validateDoctor(req.params.userId);
    sendSuccess(res, data, 'Compte médecin validé');
  } catch (error) {
    sendError(res, (error as Error).message);
  }
};

export const rejectDoctor = async (req: Request, res: Response): Promise<void> => {
  try {
    await adminService.rejectDoctor(req.params.userId);
    sendSuccess(res, null, 'Compte médecin refusé et supprimé');
  } catch (error) {
    sendError(res, (error as Error).message);
  }
};

export const getAllUsers = async (req: Request, res: Response): Promise<void> => {
  try {
    const { role } = req.query;
    const data = await adminService.getAllUsers(role as string | undefined);
    sendSuccess(res, data);
  } catch (error) {
    sendError(res, (error as Error).message, 500);
  }
};

export const deleteUser = async (req: Request, res: Response): Promise<void> => {
  try {
    await adminService.deleteUser(req.params.userId);
    sendSuccess(res, null, 'Utilisateur supprimé');
  } catch (error) {
    sendError(res, (error as Error).message);
  }
};

export const getDashboardStats = async (_req: Request, res: Response): Promise<void> => {
  try {
    const data = await adminService.getDashboardStats();
    sendSuccess(res, data);
  } catch (error) {
    sendError(res, (error as Error).message, 500);
  }
};

export const assignPatientToDoctor = async (req: Request, res: Response): Promise<void> => {
  try {
    const { patientId, doctorId } = req.body;
    const data = await adminService.assignPatientToDoctor(patientId, doctorId);
    sendSuccess(res, data, 'Patient assigné au médecin');
  } catch (error) {
    sendError(res, (error as Error).message);
  }
};
