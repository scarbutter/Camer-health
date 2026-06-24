import { Request, Response } from 'express';
import { DoctorsService } from './doctors.service';
import { sendSuccess, sendError } from '../../utils/response';

const doctorsService = new DoctorsService();

export const getMyProfile = async (req: Request, res: Response): Promise<void> => {
  try {
    const data = await doctorsService.getProfile(req.user!.userId);
    sendSuccess(res, data);
  } catch (error) {
    sendError(res, (error as Error).message, 404);
  }
};

export const updateMyProfile = async (req: Request, res: Response): Promise<void> => {
  try {
    let photoUrl: string | undefined;
    if (req.file) photoUrl = `/uploads/${req.file.filename}`;
    const data = await doctorsService.updateProfile(req.user!.userId, { ...req.body, photoUrl });
    sendSuccess(res, data, 'Profil mis à jour');
  } catch (error) {
    sendError(res, (error as Error).message);
  }
};

export const listDoctors = async (req: Request, res: Response): Promise<void> => {
  try {
    const { specialization } = req.query;
    const data = await doctorsService.listDoctors(specialization as string | undefined);
    sendSuccess(res, data);
  } catch (error) {
    sendError(res, (error as Error).message, 500);
  }
};

export const getDoctorById = async (req: Request, res: Response): Promise<void> => {
  try {
    const data = await doctorsService.getDoctorById(req.params.doctorId);
    sendSuccess(res, data);
  } catch (error) {
    sendError(res, (error as Error).message, 404);
  }
};

export const getMyPatients = async (req: Request, res: Response): Promise<void> => {
  try {
    const data = await doctorsService.getMyPatients(req.user!.userId);
    sendSuccess(res, data);
  } catch (error) {
    sendError(res, (error as Error).message, 500);
  }
};
