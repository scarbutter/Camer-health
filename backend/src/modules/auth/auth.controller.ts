import { Request, Response } from 'express';
import { AuthService } from './auth.service';
import { sendSuccess, sendError } from '../../utils/response';
import prisma from '../../config/database';

const authService = new AuthService();

export const registerPatient = async (req: Request, res: Response): Promise<void> => {
  try {
    const result = await authService.registerPatient(req.body);
    sendSuccess(res, result, 'Compte patient créé avec succès', 201);
  } catch (error) {
    sendError(res, (error as Error).message);
  }
};

export const registerDoctor = async (req: Request, res: Response): Promise<void> => {
  try {
    const result = await authService.registerDoctor(req.body);
    sendSuccess(res, result, result.message, 201);
  } catch (error) {
    sendError(res, (error as Error).message);
  }
};

export const login = async (req: Request, res: Response): Promise<void> => {
  try {
    const result = await authService.login(req.body);
    sendSuccess(res, result, 'Connexion réussie');
  } catch (error) {
    sendError(res, (error as Error).message, 401);
  }
};

export const changePassword = async (req: Request, res: Response): Promise<void> => {
  try {
    const { oldPassword, newPassword } = req.body;
    await authService.changePassword(req.user!.userId, oldPassword, newPassword);
    sendSuccess(res, null, 'Mot de passe modifié avec succès');
  } catch (error) {
    sendError(res, (error as Error).message);
  }
};

export const me = async (req: Request, res: Response): Promise<void> => {
  try {
    const user = await prisma.user.findUnique({
      where: { id: req.user!.userId },
      include: { patient: true, doctor: true, admin: true },
    });
    if (!user) { sendError(res, 'Utilisateur introuvable', 404); return; }
    const { password: _pw, ...safe } = user;
    sendSuccess(res, safe);
  } catch (error) {
    sendError(res, (error as Error).message, 500);
  }
};
