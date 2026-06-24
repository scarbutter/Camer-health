import prisma from '../../config/database';
import { stripUser } from '../../utils/strip-password';

export class AlertsService {
  async getAlertsForPatient(patientId: string, unreadOnly = false) {
    return prisma.alert.findMany({
      where: { patientId, ...(unreadOnly ? { isRead: false } : {}) },
      orderBy: { createdAt: 'desc' },
    });
  }

  async getAlertsForDoctor(doctorUserId: string, unreadOnly = false) {
    const doctor = await prisma.doctor.findFirst({ where: { userId: doctorUserId } });
    if (!doctor) throw new Error('Médecin introuvable');

    const alerts = await prisma.alert.findMany({
      where: {
        patient: { assignedDoctorId: doctor.id },
        ...(unreadOnly ? { isRead: false } : {}),
      },
      include: { patient: { include: { user: true } } },
      orderBy: { createdAt: 'desc' },
    });

    return alerts.map(a => ({
      ...a,
      patient: { ...a.patient, user: stripUser(a.patient.user) },
    }));
  }

  async markAsRead(alertId: string) {
    return prisma.alert.update({ where: { id: alertId }, data: { isRead: true } });
  }

  async markAllAsReadForPatient(patientId: string) {
    return prisma.alert.updateMany({ where: { patientId }, data: { isRead: true } });
  }
}
