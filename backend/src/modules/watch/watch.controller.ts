import { Request, Response } from 'express';
import { WatchService } from './watch.service';
import { sendSuccess, sendError } from '../../utils/response';

const watchService = new WatchService();

export const receiveWatchData = async (req: Request, res: Response): Promise<void> => {
  try {
    const data = await watchService.receiveFromWatch(req.user!.userId, req.body);
    sendSuccess(res, data, 'Données de la montre enregistrées', 201);
  } catch (error) {
    sendError(res, (error as Error).message);
  }
};

export const simulateWatchData = async (req: Request, res: Response): Promise<void> => {
  try {
    const count = Number(req.query.count) || 5;
    const data = await watchService.simulateWatchData(req.user!.userId, count);
    sendSuccess(res, data, `${data.length} mesures simulées enregistrées`);
  } catch (error) {
    sendError(res, (error as Error).message);
  }
};

export const getWatchStatus = async (req: Request, res: Response): Promise<void> => {
  try {
    const data = await watchService.getWatchStatus(req.user!.userId);
    sendSuccess(res, data);
  } catch (error) {
    sendError(res, (error as Error).message, 500);
  }
};
