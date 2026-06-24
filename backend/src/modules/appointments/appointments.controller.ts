import { Request, Response } from 'express';
import { AppointmentsService } from './appointments.service';
import { sendSuccess, sendError } from '../../utils/response';

const appointmentsService = new AppointmentsService();

export const createAppointment = async (req: Request, res: Response): Promise<void> => {
  try {
    const { doctorId, reason, date } = req.body;
    const data = await appointmentsService.createRequest(req.user!.userId, doctorId, reason, date);
    sendSuccess(res, data, 'Rendez-vous demandé', 201);
  } catch (error) {
    sendError(res, (error as Error).message);
  }
};

export const getMyAppointments = async (req: Request, res: Response): Promise<void> => {
  try {
    const data = await appointmentsService.getMyAppointments(req.user!.userId, req.user!.role);
    sendSuccess(res, data);
  } catch (error) {
    sendError(res, (error as Error).message, 500);
  }
};

export const updateAppointmentStatus = async (req: Request, res: Response): Promise<void> => {
  try {
    const { status, notes } = req.body;
    const data = await appointmentsService.updateStatus(req.params.appointmentId, status, notes);
    sendSuccess(res, data, 'Statut mis à jour');
  } catch (error) {
    sendError(res, (error as Error).message);
  }
};
