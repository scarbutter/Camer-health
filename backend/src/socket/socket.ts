import { Server as HttpServer } from 'http';
import { Server as SocketServer, Socket } from 'socket.io';
import jwt from 'jsonwebtoken';
import { jwtConfig } from '../config/jwt';
import { JwtPayload } from '../middleware/auth.middleware';

let io: SocketServer;

export const initSocket = (httpServer: HttpServer): SocketServer => {
  io = new SocketServer(httpServer, {
    cors: { origin: '*', methods: ['GET', 'POST'] },
  });

  // Authenticate socket connections
  io.use((socket, next) => {
    const token = socket.handshake.auth.token || socket.handshake.headers['authorization']?.split(' ')[1];
    if (!token) {
      return next(new Error('Token manquant'));
    }
    try {
      const decoded = jwt.verify(token, jwtConfig.secret) as JwtPayload;
      (socket as Socket & { user: JwtPayload }).user = decoded;
      next();
    } catch {
      next(new Error('Token invalide'));
    }
  });

  io.on('connection', (socket) => {
    const user = (socket as Socket & { user: JwtPayload }).user;
    console.log(`[Socket] User connected: ${user.userId} (${user.role})`);

    // Each user joins their own room identified by their userId
    socket.join(user.userId);

    socket.on('join_conversation', (partnerId: string) => {
      socket.join(`conv_${[user.userId, partnerId].sort().join('_')}`);
    });

    socket.on('disconnect', () => {
      console.log(`[Socket] User disconnected: ${user.userId}`);
    });
  });

  return io;
};

export const emitToUser = (userId: string, event: string, data: unknown): void => {
  if (io) {
    io.to(userId).emit(event, data);
  }
};

export const emitNewMessage = (receiverId: string, message: unknown): void => {
  emitToUser(receiverId, 'new_message', message);
};

export const emitNewAlert = (patientUserId: string, alert: unknown): void => {
  emitToUser(patientUserId, 'new_alert', alert);
};

export const getIo = (): SocketServer => io;
