import { Request, Response } from 'express';
import { MessagesService } from './messages.service';
import { sendSuccess, sendError } from '../../utils/response';

const messagesService = new MessagesService();

export const sendMessage = async (req: Request, res: Response): Promise<void> => {
  try {
    const senderId = req.user!.userId;
    const { receiverId } = req.params;
    const { content, type } = req.body;
    let mediaUrl: string | undefined;
    if (req.file) mediaUrl = `/uploads/${req.file.filename}`;

    const data = await messagesService.sendMessage(senderId, receiverId, content, type, mediaUrl);
    sendSuccess(res, data, 'Message envoyé', 201);
  } catch (error) {
    sendError(res, (error as Error).message);
  }
};

export const getConversation = async (req: Request, res: Response): Promise<void> => {
  try {
    const userId = req.user!.userId;
    const { partnerId } = req.params;
    const limit = Number(req.query.limit) || 50;
    const offset = Number(req.query.offset) || 0;
    const data = await messagesService.getConversation(userId, partnerId, limit, offset);
    sendSuccess(res, data);
  } catch (error) {
    sendError(res, (error as Error).message, 500);
  }
};

export const getConversationList = async (req: Request, res: Response): Promise<void> => {
  try {
    const data = await messagesService.getConversationList(req.user!.userId);
    sendSuccess(res, data);
  } catch (error) {
    sendError(res, (error as Error).message, 500);
  }
};

export const getUnreadCount = async (req: Request, res: Response): Promise<void> => {
  try {
    const count = await messagesService.getUnreadCount(req.user!.userId);
    sendSuccess(res, { count });
  } catch (error) {
    sendError(res, (error as Error).message, 500);
  }
};
