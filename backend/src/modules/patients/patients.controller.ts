import { Request, Response } from 'express';
import { PatientsService } from './patients.service';
import { sendSuccess, sendError } from '../../utils/response';
import path from 'path';

const patientsService = new PatientsService();

export const getMyProfile = async (req: Request, res: Response): Promise<void> => {
  try {
    const data = await patientsService.getProfile(req.user!.userId);
    sendSuccess(res, data);
  } catch (error) {
    sendError(res, (error as Error).message, 404);
  }
};

export const updateMyProfile = async (req: Request, res: Response): Promise<void> => {
  try {
    let photoUrl: string | undefined;
    if (req.file) {
      photoUrl = `/uploads/${req.file.filename}`;
    }
    const data = await patientsService.updateProfile(req.user!.userId, { ...req.body, photoUrl });
    sendSuccess(res, data, 'Profil mis à jour');
  } catch (error) {
    sendError(res, (error as Error).message);
  }
};

export const getPatientById = async (req: Request, res: Response): Promise<void> => {
  try {
    const data = await patientsService.getPatientById(req.params.patientId);
    sendSuccess(res, data);
  } catch (error) {
    sendError(res, (error as Error).message, 404);
  }
};

export const listPatients = async (_req: Request, res: Response): Promise<void> => {
  try {
    const data = await patientsService.listPatients();
    sendSuccess(res, data);
  } catch (error) {
    sendError(res, (error as Error).message, 500);
  }
};
