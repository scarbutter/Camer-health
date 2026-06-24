import { Request, Response } from 'express';
import { AlertsService } from './alerts.service';
import { sendSuccess, sendError } from '../../utils/response';
import prisma from '../../config/database';

const alertsService = new AlertsService();

export const getMyAlerts = async (req: Request, res: Response): Promise<void> => {
  try {
    const { role, userId } = req.user!;
    const unreadOnly = req.query.unread === 'true';

    if (role === 'PATIENT') {
      const patient = await prisma.patient.findFirst({ where: { userId } });
      if (!patient) { sendError(res, 'Patient introuvable', 404); return; }
      const data = await alertsService.getAlertsForPatient(patient.id, unreadOnly);
      sendSuccess(res, data);
    } else if (role === 'DOCTOR') {
      const data = await alertsService.getAlertsForDoctor(userId, unreadOnly);
      sendSuccess(res, data);
    } else {
      sendError(res, 'Rôle non autorisé', 403);
    }
  } catch (error) {
    sendError(res, (error as Error).message, 500);
  }
};

export const markAlertRead = async (req: Request, res: Response): Promise<void> => {
  try {
    const data = await alertsService.markAsRead(req.params.alertId);
    sendSuccess(res, data, 'Alerte marquée comme lue');
  } catch (error) {
    sendError(res, (error as Error).message);
  }
};

export const markAllRead = async (req: Request, res: Response): Promise<void> => {
  try {
    const patient = await prisma.patient.findFirst({ where: { userId: req.user!.userId } });
    if (!patient) { sendError(res, 'Patient introuvable', 404); return; }
    await alertsService.markAllAsReadForPatient(patient.id);
    sendSuccess(res, null, 'Toutes les alertes marquées comme lues');
  } catch (error) {
    sendError(res, (error as Error).message);
  }
};
