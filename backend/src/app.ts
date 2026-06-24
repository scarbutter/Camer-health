import 'dotenv/config';
import express from 'express';
import http from 'http';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import path from 'path';

import { initSocket } from './socket/socket';

// Routes
import authRoutes from './modules/auth/auth.routes';
import adminRoutes from './modules/admin/admin.routes';
import patientsRoutes from './modules/patients/patients.routes';
import doctorsRoutes from './modules/doctors/doctors.routes';
import vitalSignsRoutes from './modules/vital-signs/vital-signs.routes';
import alertsRoutes from './modules/alerts/alerts.routes';
import messagesRoutes from './modules/messages/messages.routes';
import appointmentsRoutes from './modules/appointments/appointments.routes';
import watchRoutes from './modules/watch/watch.routes';

const app = express();
const httpServer = http.createServer(app);

// Init socket.io
initSocket(httpServer);

// Core middleware
app.use(cors());
app.use(helmet({ crossOriginResourcePolicy: { policy: 'cross-origin' } }));
app.use(morgan('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Serve uploaded files
app.use('/uploads', express.static(path.join(process.cwd(), process.env.UPLOAD_DIR || 'uploads')));

// API Routes
app.use('/api/auth', authRoutes);
app.use('/api/admin', adminRoutes);
app.use('/api/patients', patientsRoutes);
app.use('/api/doctors', doctorsRoutes);
app.use('/api/vitals', vitalSignsRoutes);
app.use('/api/alerts', alertsRoutes);
app.use('/api/messages', messagesRoutes);
app.use('/api/appointments', appointmentsRoutes);
app.use('/api/watch', watchRoutes);

// Health check
app.get('/health', (_req, res) => res.json({ status: 'ok', timestamp: new Date().toISOString() }));

// 404 handler
app.use((_req, res) => res.status(404).json({ success: false, message: 'Route introuvable' }));

const PORT = process.env.PORT || 3000;
httpServer.listen(PORT, () => {
  console.log(`\n🚀 CamerHealth API running on http://localhost:${PORT}`);
  console.log(`📡 WebSocket server ready`);
  console.log(`📁 Uploads served at http://localhost:${PORT}/uploads\n`);
});

export default app;
