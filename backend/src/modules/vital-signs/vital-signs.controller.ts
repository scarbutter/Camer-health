import { Request, Response } from 'express';
import { VitalSignsService } from './vital-signs.service';
import { sendSuccess, sendError } from '../../utils/response';
import prisma from '../../config/database';

const vitalSignsService = new VitalSignsService();

const resolvePatientId = async (userId: string): Promise<string | null> => {
  const patient = await prisma.patient.findFirst({ where: { userId } });
  return patient?.id ?? null;
};

export const createVitalSign = async (req: Request, res: Response): Promise<void> => {
  try {
    let patientId = req.params.patientId;
    // If patient is submitting their own data, resolve from userId
    if (!patientId || patientId === 'me') {
      const id = await resolvePatientId(req.user!.userId);
      if (!id) { sendError(res, 'Patient introuvable', 404); return; }
      patientId = id;
    }
    const data = await vitalSignsService.create(patientId, req.body);
    sendSuccess(res, data, 'Données vitales enregistrées', 201);
  } catch (error) {
    sendError(res, (error as Error).message);
  }
};

export const getVitalHistory = async (req: Request, res: Response): Promise<void> => {
  try {
    let patientId = req.params.patientId;
    if (!patientId || patientId === 'me') {
      const id = await resolvePatientId(req.user!.userId);
      if (!id) { sendError(res, 'Patient introuvable', 404); return; }
      patientId = id;
    }
    const limit = Number(req.query.limit) || 50;
    const offset = Number(req.query.offset) || 0;
    const data = await vitalSignsService.getHistory(patientId, limit, offset);
    sendSuccess(res, data);
  } catch (error) {
    sendError(res, (error as Error).message, 500);
  }
};

export const getLatestVitals = async (req: Request, res: Response): Promise<void> => {
  try {
    let patientId = req.params.patientId;
    if (!patientId || patientId === 'me') {
      const id = await resolvePatientId(req.user!.userId);
      if (!id) { sendError(res, 'Patient introuvable', 404); return; }
      patientId = id;
    }
    const data = await vitalSignsService.getLatest(patientId);
    sendSuccess(res, data);
  } catch (error) {
    sendError(res, (error as Error).message, 500);
  }
};

export const getVitalStats = async (req: Request, res: Response): Promise<void> => {
  try {
    let patientId = req.params.patientId;
    if (!patientId || patientId === 'me') {
      const id = await resolvePatientId(req.user!.userId);
      if (!id) { sendError(res, 'Patient introuvable', 404); return; }
      patientId = id;
    }
    const days = Number(req.query.days) || 7;
    const data = await vitalSignsService.getStats(patientId, days);
    sendSuccess(res, data);
  } catch (error) {
    sendError(res, (error as Error).message, 500);
  }
};
